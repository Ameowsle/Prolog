# Sudoku Solver

A **Sudoku** is a 9×9 grid puzzle where each row, column, and 3×3 block must contain the digits 1-9 exactly once. Some cells are pre-filled. The task is to fill in the rest.

## Constraints

1. **Row constraint:** Each row must contain each value 1-9 exactly once
2. **Column constraint:** Each column must contain each value 1-9 exactly once
3. **Block constraint:** Each 3×3 block must contain each value 1-9 exactly once

## Performance Comparison (9×9 Grid)

| Approach | Logical Inferences | CPU Time | Speed vs. Backtracking |
| :--- | :--- | :--- | :--- |
| **CLP (Constraint Logic)** | 69,130 | 0.006s | ~116x faster |
| **Backtracking with Domain Constraint** | 520,030 | 0.027s | ~15x faster |
| **Naive Backtracking** | 8,053,719 | 0.218s | Baseline |

## Approaches

### 1. Naive Backtracking (`9x9sudoku_Backtracking.pl`)
All rows are flattened into a single list with `append/2`, then each cell is filled one by one. For every empty cell, `member/2` tries all values from the full domain `[1..9]`, the domain never shrinks, so each cell always has 9 possible values regardless of what its neighbours already contain. After every single assignment, `check_position/1` validates all 9 rows, all 9 columns, and all 9 blocks, even those that have not changed. Invalid values are only detected after being assigned, not before.

### 2. Backtracking with Domain Constraint per Cell (`9x9sudoku_DomainConstraint.pl`)
This strategy assigns values for each line from left to right. Before trying any value, `candidates/4` computes which values are still allowed for a cell by subtracting used values in the same row, column, and block from `[1..9]`. Only valid candidates are passed to `member/2`, so invalid values are never tried in the first place. No separate `check_position` is needed.

### 3. CLP (`9x9sudoku.pl`)
This approach uses `library(clpfd)`. The constraints, listed above, are applied to every row, column and block. Domains are automatically adjusted across the entire grid after every assignment, eliminating large parts of the search space.

## How to Run

1. Start SWI-Prolog: `swipl`
2. Consult a file: `?- ['9x9sudoku.pl'].`
3. Run: `?- sudoku(Solution), maplist(writeln, Solution).`