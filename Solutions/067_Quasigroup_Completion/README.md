# Problem 067: Quasigroup Completion

*(Source: CSPLib Problem [prob067](https://github.com/csplib/csplib/tree/main/Problems/prob067))*

A **quasigroup** is a Latin square of size $m \times m$. That is, an $m \times m$ multiplication table where each element (typically values from 1 to $m$) occurs exactly once in every row and every column.

The **Quasigroup Completion problem** asks to complete a partially specified quasigroup. Given some entries of the table already filled in, the task is to fill in the remaining entries such that each row and column contains each value exactly once.

### Example

A partial 4x4 quasigroup:
```
1  _  _  4
_  _  2  _
3  _  _  _
_  3  _  _
```

Completed:
```
1  2  3  4
4  1  2  3
3  4  1  2
2  3  4  1
```

## Constraints

1. **Row constraint:** Each row must contain each value 1 to $m$ exactly once
2. **Column constraint:** Each column must contain each value 1 to $m$ exactly once
3. **Initial values:** Certain cells are pre-filled and must be respected

## Approaches

Two solvers are provided: a declarative `clpfd` model and a backtracking solver.
Both take the puzzle as an argument (`quasigroup(+Puzzle, -Solution)`), so the
same relation completes any board. The `partially_quasigroup/1` fact is only an
example instance to run them on.

### 1. Constraint Logic Programming (`067QuasigroupCompletionCLP.pl`)

- **Strategy:** Declarative constraint solving using `library(clpfd)`
- **Method:** The matrix is flattened with `append/2` and all variables are constrained to `1..M`. `all_distinct/1` is applied to every row and (via `transpose/2`) every column. `label/1` then searches for a consistent assignment.
- **Key Feature:** Constraint propagation reduces variable domains before search begins, often eliminating large parts of the search space without explicit backtracking logic.

### 2. Backtracking per Cell + Domain Constraint (`067QuasigroupCompletionBacktrackingPerCellDomainConstraint.pl`)

- **Strategy:** Cell-by-cell assignment with row and column domain restriction before each placement
- **Method:** `fill_row_dc/3` computes the reduced domain per row by subtracting pre-filled values. Before assigning a value, `assign_cell_dc/4` extracts the already-filled values from the current column and subtracts them from the remaining row domain. The cell is then assigned from this reduced candidate set.
- **Key Optimization:** Column conflicts are ruled out before a value is chosen, so invalid candidates never enter the search tree. This prunes the search far earlier than checking a row or column only after it is complete.

## Performance Comparison (7x7 Grid, 15 pre-filled cells)

Both solvers find all 42 completions of this instance. The following metrics were
recorded for the first solution using the `time/1` predicate in SWI-Prolog, on
the same instance:

| Approach | Logical Inferences | CPU Time |
| :--- | ---: | ---: |
| **CLP (Constraint Logic)** | 159,997 | 0.005s |
| **Backtracking per Cell + Domain Constraint** | 35,342 | 0.002s |

## How to Run

1. Start SWI-Prolog: `swipl`
2. Consult a file, e.g.: `?- ['067QuasigroupCompletionCLP.pl'].`
3. Run the solver on the example instance: `?- partially_quasigroup(P), quasigroup(P, Solution), maplist(writeln, Solution).`

To try the backtracking solver, consult `067QuasigroupCompletionBacktrackingPerCellDomainConstraint.pl` instead. To solve a different board, pass your own partial grid (a list of rows with unbound variables for empty cells) as the first argument of `quasigroup/2`.

## Observations

The backtracking solver with up-front domain restriction reaches the first
solution in far fewer inferences than the `clpfd` model on this instance:
column-conflicting values are filtered out before a cell is ever assigned, so
they never enter the search tree. The `clpfd` model carries the overhead of
building and maintaining the constraint network, but propagation makes it robust
across instances and keeps the model compact and declarative. The gap between the
two grows on sparser or larger grids, where more candidates are available and the
explicit column filtering eliminates a larger fraction of them upfront.
