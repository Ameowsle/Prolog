# Problem 057: Killer Sudoku

*(Source: CSPLib Problem [prob057](https://www.csplib.org/Problems/prob057/))*

Killer Sudoku combines classical Sudoku with the cage sums of Kakuro. On a 9x9
grid the cells are partitioned into cages, each with a target total. The grid
must satisfy the usual Sudoku rules and, in addition, the numbers in every cage
must add up to its target without repeating. CSPLib also defines a straightforward
generalisation to NxN grids where N has an integer square root (boxes are then
sqrt(N) x sqrt(N)); the generalised solvers below cover that case.

Example (first row of the unique solution to the Wikipedia "Killersudoku_color"
instance): `2 1 5 6 4 7 3 9 8`.

## Problem Constraints

1. Each row contains each value 1..N exactly once
2. Each column contains each value 1..N exactly once
3. Each sqrt(N) x sqrt(N) block contains each value 1..N exactly once (3x3 for the standard 9x9 grid)
4. The cells of every cage sum to the cage's target total
5. No value repeats within a cage

## Approaches

### 1. Backtracking with Domain Constraint (`057KillerSudokuBacktrackingDomainConstraint.pl`)

Solves the standard 9x9 grid by constrain-then-generate: before any value is
placed, `candidates/4` computes the legal values for a cell as the intersection
of two restricted domains.

- Row / column / block: a value is excluded if it already appears in the same
  row, column, or 3x3 block. These give a fixed set of used values that is
  subtracted from `1..9`.
- Cage: a value is excluded if it already appears in the cage (distinctness), or
  if it would make the remaining cage sum unreachable. The reachability test uses
  the Gauss bound on what the still empty cells can sum to. The result is
  intersected with the row/column/block domain.

Because each cell is only ever tried with values that can still lead to a
solution, the search prunes early rather than testing a full assignment at the end.

### 2. CLP (`057KillerSudokuCLP.pl`)

Solves the standard 9x9 grid with `library(clpfd)`. Every cell is a variable in
`1..9`; `all_distinct/1` is posted on each row, column, and 3x3 block, and each
cage gets `all_distinct/1` plus `sum(Cells, #=, Target)`. The constraints
propagate across the whole grid before `label/1` searches for values.

Note: both MiniZinc reference models post only the cage sum, not `all_distinct`
per cage. The model here is the more complete reading of the rules ("no value
repeats within a cage").

### 3. Generalised Backtracking with Domain Constraint (`057KillerSudokuGeneralisationBacktrackingDomainConstraint.pl`)

The same domain-constraint backtracking, but for any NxN grid where N has an
integer square root. The block size sqrt(N) is computed from the grid, so the
solver is not tied to 9x9.

### 4. Generalised CLP (`057KillerSudokuGeneralisationCLP.pl`)

The same CLP model generalised to any NxN grid: the domain becomes `1..N` and the
blocks are sqrt(N) x sqrt(N), derived from the grid size.

## Performance Comparison

The instance has exactly one solution; both the CLP and the domain-constraint
backtracking solvers find it and confirm uniqueness. This was cross-checked
against the MiniZinc reference (`killer_sudoku.mzn`, Gecode), which returns the
same grid and reports no further solution. The figures below are for finding the
solution on the 9x9 instance. Logical inferences are the reproducible metric; CPU
times are indicative.

| Approach | Logical Inferences | CPU Time |
| :--- | :--- | :--- |
| Backtracking with Domain Constraint (9x9) | 921,175 | 0.031s |
| CLP (9x9) | 1,055,665 | 0.035s |
| Generalised Backtracking with Domain Constraint | 1,013,853 | 0.039s |
| Generalised CLP | 1,056,447 | 0.031s |

The 9x9 and generalised variants run the same instance and so land within
measurement noise of one another. At this grid size the comparison is not a
meaningful benchmark; it only confirms the solvers agree and run instantly.

## How to Run

1. Start SWI-Prolog: `swipl`
2. Consult a file, e.g.: `?- ['057KillerSudokuCLP.pl'].`
3. Run the solver: `?- sudoku(Solution).`
