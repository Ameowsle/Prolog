# Problem 067: Quasigroup Completion

*(Source: CSPLib Problem [prob067](https://github.com/csplib/csplib/tree/main/Problems/prob067))*

A **quasigroup** is a Latin square of size $m \times m$. That is, an $m \times m$ multiplication table where each element (typically values from 1 to $m$) occurs exactly once in every row and every column.

The **Quasigroup Completion problem** asks to complete a partially specified quasigroup. Given some entries of the table already filled in, the task is to fill in the remaining entries such that each row and column contains each value exactly once.

### Example

A partial 4×4 quasigroup:
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

## Performance Comparison (7×7 Grid, 7 pre-filled cells)

The following metrics were recorded using the `time/1` predicate in SWI-Prolog:

| Approach | Logical Inferences | CPU Time | Wall Time | Speed vs. per Line |
| :--- | :--- | :--- | :--- | :--- |
| **Backtracking per Cell** | 32,256 | 0.001s | 0.001s | **~2,329x faster** |
| **CLP (Constraint Logic)** | 354,451 | 0.010s | 0.010s | **~212x faster** |
| **Backtracking per Line** | 75,128,144 | 1.91s | 1.92s | Baseline |

## Approaches

### 1. Backtracking per Line (`068:Backtracking_per_Line.pl`)

- **Strategy:** Row-by-row assignment with immediate row and column checks after each row
- **Method:** For each row, `assign_cell/2` picks a value from the full domain for every empty cell. After filling an entire row, `all_diff/1` checks the row, then `check_col_partial/2` checks every column index for duplicates among already-filled cells.
- **Key Feature:** Column feasibility is only verified once a whole row is complete — backtracking happens at the row level, not the cell level. 

### 2. Backtracking per Cell (`068:Backtracking_per_Cell.pl`)

- **Strategy:** Cell-by-cell assignment with immediate column check after each cell placement
- **Method:** `fill_row/3` computes the reduced domain per row by subtracting pre-filled values. `assign_cell/4` then picks values one cell at a time via `select/3` and immediately calls `check_col_partial/2` after each placement.
- **Key Optimization:** Column constraints are checked at the cell level rather than the row level, allowing earlier backtracking and pruning of invalid branches before a full row is built.

### 3. Constraint Logic Programming (`068:quasigroupCLP.pl`)

- **Strategy:** Declarative constraint solving using `library(clpfd)`
- **Method:** The matrix is flattened with `append/2` and all variables are constrained to `1..M`. `all_distinct/1` is applied to every row and (via `transpose/2`) every column. `label/1` then searches for a consistent assignment.
- **Key Feature:** Constraint propagation reduces variable domains before search begins, often eliminating large parts of the search space without explicit backtracking logic.

## How to Run

1. Start SWI-Prolog: `swipl`
2. Consult a file, e.g.: `?- ['068:quasigroupCLP.pl'].`
3. Run the solver: `?- quasigroup(Solution), maplist(writeln, Solution).`

To try a different approach, replace the filename with `068:Backtracking_per_Cell.pl` or `068:Backtracking_per_Line.pl`.

## Observations

The per-cell backtracking approach dramatically outperforms both alternatives, using **~2,329x fewer inferences than per-line backtracking**. The key insight is that checking column constraints immediately after each cell placement prunes invalid branches before an entire row is built — far earlier than waiting until the end of a row. Interestingly, **CLP is faster than per-line backtracking** (~212x) because constraint propagation at the start eliminates large parts of the search space that per-line backtracking still has to explore row by row. For small 4×4 puzzles all three approaches are negligibly fast, but the difference becomes dramatic on sparser or larger grids where backtracking without early pruning explodes combinatorially.

### Why per-Cell Backtracking beats CLP

CLP is not a magic wand — it carries overhead from building and maintaining the constraint network, and `label/1` still performs search internally. For this problem, the per-cell approach already performs **manual domain reduction** before any search begins:

```prolog
subtract(Domain, Prefilled, Reduced)
```

This removes all pre-filled values from the domain of a row upfront, which is exactly what CLP's `all_distinct` achieves through propagation — but without the framework overhead. Combined with an immediate column check after every single cell placement, the per-cell approach effectively does what CLP does, but with less machinery. CLP becomes the better choice for larger or more complex problems where propagation can eliminate entire subtrees that manual backtracking would still have to explore.
