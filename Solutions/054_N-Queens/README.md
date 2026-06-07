# Problem 054: N-Queens
*(Source: CSPLib Problem [prob054](https://www.csplib.org/Problems/prob054/))*

Place N queens on an N x N chessboard so that no two attack each other. In chess
a queen attacks along its row, column and both diagonals, so no two queens may
share a row, a column or a diagonal.

A queen at column C and row R can be described by the pair (C, R). Two queens do
not attack each other iff they differ in all of C, R, C - R and C + R. The
diagonals correspond to the sum and the difference of the coordinates: moving one
square along one diagonal leaves the sum unchanged, along the other leaves the
difference unchanged.

The board is modelled as a list of length N where the position is the column and
the value is the row. A list already forces one queen per column, so only the
row, the ascending diagonal (Row + Col) and the descending diagonal (Row - Col)
need to be kept distinct.

## Problem Constraints

1. Exactly one queen per column (implicit in the list representation)
2. All rows are distinct (no two queens on the same row)
3. All ascending diagonals (Row + Col) are distinct
4. All descending diagonals (Row - Col) are distinct

## Approaches

### 1. Backtracking (`054NQueensBacktracking.pl`)

- `n_queens2/2` places one queen per column, choosing a row with `select/3` from
  the rows still free. This already guarantees distinct rows.
- It checks the diagonals immediately after placing each queen
  (`check_position/3`), so an attacked placement is rejected at once and the rest
  of that branch is pruned (constrain then generate, not generate then test).

### 2. Constraint Logic Programming (`054NQueensCLP.pl`)

- One finite-domain variable per column, `Solution ins 1..N`.
- `all_different/1` keeps the rows distinct.
- `safe_diagonals/2` builds the ascending ids (`Row + Col`) and descending ids
  (`Row - Col`) and posts `all_distinct/1` on each, so the diagonal constraints
  propagate before search.
- `labeling([ff])` searches with the first-fail variable order.

## Performance Comparison

Both solvers search the same space (no symmetry breaking) and enumerate the
identical set of solutions, which is how the two models are cross-checked: for
N=8,9,10 they each return 92, 352 and 724 solutions, matching OEIS A000170.
The table below enumerates all of them. Logical inferences are the reproducible
metric; CPU times are indicative.

| N | Solutions | Backtracking Inferences | Backtracking CPU | CLP Inferences | CLP CPU |
| :--- | :--- | :--- | :--- | :--- | :--- |
| 8  | 92  | 119,331    | 0.013s | 3,000,500  | 0.092s |
| 9  | 352 | 482,431    | 0.044s | 12,781,026 | 0.362s |
| 10 | 724 | 2,313,923  | 0.212s | 52,339,873 | 1.484s |

For enumerating all solutions the backtracking solver is roughly 25x faster: it
rejects an attacked placement with cheap arithmetic, while the CLP model pays for
`all_distinct/1` propagation plus labeling across the whole solution set.

For finding only the first solution the picture reverses. The CLP model with
first-fail labeling scales to large boards (N=50 in about 0.13s), while the plain
backtracking solver uses a static row order and degrades quickly: it solves N=12
in milliseconds but already takes well over a minute on some larger boards. A
value-ordering heuristic would be needed to match the documented scaling of CLP
to several hundred queens.

## How to Run

1. Start SWI-Prolog: `swipl`
2. Consult a file, e.g.: `?- ['054NQueensCLP.pl'].`

**Backtracking:**
```prolog
?- ['054NQueensBacktracking.pl'].
?- n_queens2(8, Solution).
?- time(aggregate_all(count, n_queens2(8, _), Count)).
```

**CLP:**
```prolog
?- ['054NQueensCLP.pl'].
?- n_queens_clp(8, Solution).
?- time(once(n_queens_clp(50, Solution))).
```
