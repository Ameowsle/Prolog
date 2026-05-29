# Problem 049: Number Partitioning
*(Source: CSPLib Problem [prob049](https://www.csplib.org/Problems/prob049/))*

Split the numbers `1..N` into two sets A and B that have **equal size**, **equal sum**, and **equal sum of squares**.

Example (N=8): `A = [1, 4, 6, 7]`, `B = [2, 3, 5, 8]`
→ both sets have 4 elements, sum 18, and sum of squares 102 ✓

N=8 is the smallest size with a solution. For N = 2, 4, 6 none exists.

## Problem Constraints

1. `|A| = |B|` (so N must be even)
2. `sum(A) = sum(B)`
3. sum of squares of A = sum of squares of B

## Approaches

### 1. Backtracking (`049NumberPartitioningBacktracking.pl`)

- Decides for each number whether it joins set A, accumulating A's running size, sum and sum of squares.
- Prunes a branch the moment any of the three totals overshoots its target.
- Only set A is tracked. Once A reaches every target, B is forced to match because the grand totals are fixed.
- Symmetry break: the largest number N is placed in A up front.

### 2. Constraint Logic Programming (`049NumberPartitioningCLP.pl`)

- One 0/1 indicator variable per number (`1` = set A, `0` = set B).
- `sum/3` fixes the set size; `scalar_product/4` fixes the sum and the sum of squares.
- Symmetry break: number 1 is fixed to set A.

## How to Run

1. Start SWI-Prolog: `swipl`
2. Consult a file, e.g.: `?- ['049NumberPartitioningBacktracking.pl'].`

**Backtracking:**
```prolog
?- partition(8, A, B).
?- time(partition(12, A, B)).
```

**CLP:**
```prolog
?- ['049NumberPartitioningCLP.pl'].
?- partition(8, A, B).
?- time(partition(12, A, B)).
```
