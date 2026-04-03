# Prolog Killer Sudoku Solver
*(Source: CSPLib Problem [prob057](https://www.csplib.org/Problems/prob057/))*

**Killer Sudoku** extends classical Sudoku with additional sum constraints. Solve 9×9 grids where cells are grouped into "cages" that must sum to specified totals while maintaining standard Sudoku rules.

## Constraints

1. **Sudoku Rules:** Each row, column, and 3×3 box contains digits 1–9 exactly once
2. **Cage Constraints:** Cells in each cage sum to the specified total
3. **Uniqueness in Cages:** No digit repeats within a cage

## Approaches

- **Backtracking (057KillerSodokuBacktr.pl):** Manual backtracking with constraint checking
- **CLP (057KillerSudoku.pl):** Constraint Logic Programming using `clpfd` library for efficient constraint propagation

## How to Run

1. Start SWI-Prolog: `swipl`
2. Consult the file: `?- ['057KillerSudoku.pl'].`
3. Run the CLP version: `?- sudoku(Solution).`
