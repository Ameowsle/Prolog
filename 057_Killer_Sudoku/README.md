# Prolog Killer Sudoku Solver
*(Source: CSPLib Problem [prob057](https://www.csplib.org/Problems/prob057/))*

**Killer Sudoku** extends classical Sudoku with additional sum constraints. Solve 9×9 grids where cells are grouped into "cages" that must sum to specified totals while maintaining standard Sudoku rules.

## Constraints

1. **Row constraint:** Each row must contain each value 1-9 exactly once                       
2. **Column constraint:** Each column must contain each value 1-9 exactly once
3. **Block constraint:** Each 3×3 block must contain each value 1-9 exactly once               
4. **Cage sum:** All cells in a cage must sum to the specified total                           
5. **Cage uniqueness:** No value may repeat within a cage

## Performance Comparison (9×9 Grid)                                                           
   
| Approach | Logical Inferences | CPU Time | Speed vs. Backtracking |                          
| :--- | :--- | :--- | :--- |           
| **Backtracking with Domain Constraint** | 925,388 | 0.049s | **~18x faster** |               
| **CLP (Constraint Logic)** | 1,056,038 | 0.052s | **~16x faster** |                          
| **Naive Backtracking** | 16,645,390 | 0.411s | Baseline |

## Approaches

### 1. Naive Backtracking (`057KillerSodokuBacktr.pl`)
All rows are flattened into a single list via `append/2`, then filled cell by cell. For every empty cell, `member/2` tries all values from `[1..9]` without any domain restriction. After each assignment, all rows, columns, blocks, and cages are checked including those that have not changed. Invalid values are only detected after being assigned.    

### 2. Backtracking with Domain Constraint per Cell (`057KillerSudokuBacktracking_per_Cell.pl`)
Before trying any value, `candidates/4` computes valid values as the **intersection** of two restricted domains:

**Row / Column / Block:** a value is invalid if it already appears in the same row, column, or 3×3 block. These produce a fixed list of used values that is subtracted from `[1..9]`.

**Cage:** a value is invalid if it already appears in the cage (distinctness), or if it would make the remaining cage sum unreachable. The second condition cannot be expressed as a simple subtraction, it depends on how many cells are still empty and what sum they still need to reach. Instead, `cage_candidates` computes which values are still valid using the Gauss formula to bound the achievable sum, and the result is intersected with the row/col/block domain.

### 3. CLP (`057KillerSudokuCLP.pl`)
Uses `library(clpfd)`. All Sudoku and cage constraints are declared directly. Domains are automatically propagated across the entire grid after every assignment.

### 4. Generalised Backtracking (`057:GeneralisationBacktr.pl`)
Same approach as naive backtracking but works for any N×N grid, not just 9×9. Block size is computed dynamically.

### 5. Generalised CLP (`057:GeneralisationCLP.pl`)
Same as the CLP approach but generalised for any N×N grid.

## How to Run

1. Start SWI-Prolog: `swipl`
2. Consult the file: `?- ['057KillerSudoku.pl'].`
3. Run the CLP version: `?- sudoku(Solution).`
