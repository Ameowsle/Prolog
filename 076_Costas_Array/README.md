# Problem 076: Costas Array
*(Source: CSPLib Problem [prob076](https://www.csplib.org/Problems/prob076/))*

A Costas Array of size N is a permutation of `1..N` where all displacement
vectors between pairs of marks are distinct. Equivalently, for each level L the
differences `X(i+L) - X(i)` are all distinct, where level L is one row of the
difference triangle.

Example (N=5): `[1, 3, 4, 2, 5]` is a Costas Array.

## Problem Constraints

1. The marks form a permutation of `1..N` (one mark per row and column)
2. For every level L in `1..N-1`, the differences `X(i+L) - X(i)` are distinct

## Approaches

### 1. Backtracking (`076CostasArrayBacktracking.pl`)

- Builds the permutation one value at a time using `select/3`. After each
  placement, `check_diffs` verifies that no new difference duplicates one
  already used at the same level. If it does, Prolog backtracks and tries the
  next candidate.
- Values are prepended to `Placed` (O(1)) and reversed at the end, since
  appending to the back would cost O(n) per step.
- Used differences are kept in one bucket per level, so each check scans only
  that level's O(n) diffs rather than all O(n^2) pairs.

### 2. Constraint Logic Programming (`076CostasArrayCLP.pl`)

- `Xs ins 1..N` plus `all_distinct(Xs)` posts the permutation.
- `level_diffs/3` builds the differences of each level of the difference
  triangle, and `all_distinct/1` is posted on every level.
- The constraints propagate before `label/1` enumerates the solutions.

## Performance Comparison

Both solvers explore the same search space and enumerate the identical set of
arrays, which is how the two models are cross-checked: the counts match OEIS
A008404 (and an independent MiniZinc/Gecode model) exactly. The table below
enumerates all solutions. Logical inferences are the reproducible metric; CPU
times are indicative.

| n | Solutions | Backtracking Inferences | Backtracking CPU | CLP Inferences | CLP CPU |
| :--- | :--- | :--- | :--- | :--- | :--- |
| 7 | 200 | 125,603   | 0.008s | 14,558,402  | 0.434s  |
| 8 | 444 | 546,516   | 0.025s | 78,452,645  | 2.358s  |
| 9 | 760 | 2,759,597 | 0.112s | 430,398,886 | 12.966s |

Backtracking is far faster here. It prunes a candidate with a cheap per-level
membership check the moment one of its new differences repeats an earlier one,
while the CLP model pays for `all_distinct/1` propagation plus default labeling
across the whole solution set. Backtracking stays practical to around n=12,
whereas CLP becomes slow beyond n=9.

## How to Run

1. Start SWI-Prolog: `swipl`
2. Consult a file, e.g.: `?- ['076CostasArrayBacktracking.pl'].`

**Backtracking:**
```prolog
?- costas(7, Xs).
?- time(costas(9, Xs)).
```

**CLP:**
```prolog
?- ['076CostasArrayCLP.pl'].
?- costas(7, Xs).
?- time(costas(8, Xs)).
```
