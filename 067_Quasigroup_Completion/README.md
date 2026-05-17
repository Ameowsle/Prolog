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

## Performance Comparison (7×7 Grid, 15 pre-filled cells)

The following metrics were recorded using the `time/1` predicate in SWI-Prolog:

| Approach | Logical Inferences | CPU Time | Wall Time | Speed vs. per Line |
| :--- | ---: | ---: | ---: | ---: |
| **Backtracking per Line** | 271,419,219 | 6.733s | 6.762s | Baseline |
| **CLP (Constraint Logic)** | 458,720 | 0.015s | 0.016s | **~592x faster** |
| **Backtracking per Cell** | 43,995 | 0.002s | 0.003s | **~6,169x faster** |
| **Backtracking per Cell + Domain Constraint** | 35,394 | 0.002s | 0.002s | **~7,670x faster** |

## Approaches

### 1. Backtracking per Line (`067:Backtracking_per_Line.pl`)

- **Strategy:** Row-by-row assignment with immediate row and column checks after each row
- **Method:** For each row, `assign_cell/2` picks a value from the full domain for every empty cell. After filling an entire row, `all_diff/1` checks the row, then `check_col_partial/2` checks every column index for duplicates among already-filled cells.
- **Key Feature:** Column feasibility is only verified once a whole row is complete, backtracking happens at the row level, not the cell level.

### 2. Backtracking per Cell (`067:Backtracking_per_Cell.pl`)

- **Strategy:** Cell-by-cell assignment with immediate column check after each cell placement
- **Method:** `fill_row/3` computes the reduced domain per row by subtracting pre-filled values. `assign_cell/4` then picks values one cell at a time via `select/3` and immediately calls `check_col_partial/2` after each placement.
- **Key Optimization:** Column constraints are checked at the cell level rather than the row level, allowing earlier backtracking and pruning of invalid branches before a full row is built.

### 3. Backtracking per Cell + Domain Constraint (`067:Backtracking_per_Cell_DomainConstraint.pl`)

- **Strategy:** Cell-by-cell assignment with row and column domain restriction before each placement
- **Method:** Before assigning a value, `assign_cell_dc/4` extracts the already-filled values from the current column and subtracts them from the remaining row domain. The cell is then assigned from this reduced candidate set.
- **Key Optimization:** Column conflicts are ruled out before a value is chosen, eliminating the need for `check_col_partial/2`. The search tree is smaller because invalid candidates never enter the search space.

### 4. Constraint Logic Programming (`067:quasigroupCLP.pl`)

- **Strategy:** Declarative constraint solving using `library(clpfd)`
- **Method:** The matrix is flattened with `append/2` and all variables are constrained to `1..M`. `all_distinct/1` is applied to every row and (via `transpose/2`) every column. `label/1` then searches for a consistent assignment.
- **Key Feature:** Constraint propagation reduces variable domains before search begins, often eliminating large parts of the search space without explicit backtracking logic.

## How to Run

1. Start SWI-Prolog: `swipl`
2. Consult a file, e.g.: `?- ['067:quasigroupCLP.pl'].`
3. Run the solver: `?- quasigroup(Solution), maplist(writeln, Solution).`

To try a different approach, replace the filename with `067:Backtracking_per_Cell.pl`, `067:Backtracking_per_Cell_DomainConstraint.pl`, or `067:Backtracking_per_Line.pl`.

## Observations

Per-line backtracking is by far the slowest approach, requiring over **271 million inferences** on a 7×7 grid. It only detects column conflicts after an entire row is filled, meaning it explores a large number of invalid partial assignments before failing. CLP (~592x faster) already eliminates much of this through propagation, but still carries framework overhead from building and maintaining the constraint network.

Per-cell backtracking (~6,169x faster) dramatically reduces the search space by checking column constraints after every single cell placement rather than after a full row, pruning invalid branches much earlier. Adding a domain constraint (~7,670x faster) pushes this further: column-conflicting values are filtered out before a cell is assigned at all, so they never enter the search tree.

The difference between per-cell and per-cell with domain constraint is relatively small on this puzzle because the 15 pre-filled cells already constrain the grid enough that column conflicts are rare. The gap grows on sparser or larger grids where more candidates are available and column filtering eliminates a larger fraction of them upfront.
