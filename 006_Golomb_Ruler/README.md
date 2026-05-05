# Problem 006: Golomb Ruler
*(Source: CSPLib Problem [prob006](https://www.csplib.org/Problems/prob006/))*

A Golomb ruler with N marks is a set of N integers `0 = a₁ < a₂ < … < aₙ` such that all N(N-1)/2 pairwise differences `aⱼ - aᵢ` are distinct.

Example (N=4): `[0, 1, 3, 7]` → differences `{1, 2, 3, 4, 6, 7}` all distinct ✓

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
