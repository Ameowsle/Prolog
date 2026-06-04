# Problem 006: Golomb Ruler
*(Source: CSPLib Problem [prob006](https://www.csplib.org/Problems/prob006/))*

A Golomb ruler with N marks is a set of N integers `0 = a1 < a2 < ... < aN` such that all N(N-1)/2 pairwise differences `aj - ai` are distinct.

Example (N=4): `[0, 1, 3, 7]` has differences `{1, 2, 3, 4, 6, 7}`, all distinct.

## Problem Constraints

1. First mark is always 0
2. Marks are strictly increasing
3. All pairwise differences are distinct

## Approaches

### 1. Backtracking (`006GolombRulerBacktracking.pl`)

- Builds marks left to right using generate and test. Rejects a candidate immediately if any of its distances to existing marks was already used.
- Does not support prefilled marks.

### 2. Constraint Logic Programming (`006GolombRulerCLP.pl`)

- `chain(Marks, #<)` enforces strictly increasing order.
- `pairwise_diffs/2` builds all N(N-1)/2 differences using `D #= B - A`.
- `all_distinct/1` ensures all differences are unique.

## Performance Comparison

Both solvers search the same space (marks in `0..N*N`, first mark 0) and
enumerate the identical set of rulers, which is how the two models are
cross-checked: for N=4,5,6 they return 354, 4618 and 60010 solutions
respectively. The table below enumerates all of them. Logical inferences are
the reproducible metric; CPU times are indicative.

| N | Solutions | Backtracking Inferences | Backtracking CPU | CLP Inferences | CLP CPU |
| :--- | :--- | :--- | :--- | :--- | :--- |
| 4 | 354    | 66,639      | 0.006s  | 1,052,555   | 0.034s  |
| 5 | 4,618  | 1,010,909   | 0.046s  | 21,433,982  | 0.613s  |
| 6 | 60,010 | 19,753,957  | 0.811s  | 418,528,170 | 11.717s |

Backtracking is roughly 20x faster here. It prunes a candidate with cheap
arithmetic the moment one of its new distances repeats an earlier one, while the
CLP model pays for `all_distinct/1` propagation plus labeling across the whole
solution set. For finding only the first ruler both are sub-0.04s even at N=10,
because the increasing search reaches `[0,1,3,7,...]` immediately.

## How to Run

1. Start SWI-Prolog: `swipl`
2. Consult a file, e.g.: `?- ['006GolombRulerBacktracking.pl'].`

**Backtracking:**
```prolog
?- golomb(4, Marks).
?- time(golomb(5, Marks)).
```

**CLP:**
```prolog
?- ['006GolombRulerCLP.pl'].
?- golomb(4, Marks).
?- time(golomb(5, Marks)).
```
