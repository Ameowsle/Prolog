# Problem 007: All-Interval Series
*(Source: CSPLib Problem [prob007](https://www.csplib.org/Problems/prob007/))*

Given N, find a permutation **S** of {0, 1, …, N-1} such that the N-1 consecutive absolute differences also form a permutation of {1, 2, …, N-1}.

Formally: if **V** = (|S₂−S₁|, |S₃−S₂|, …, |Sₙ−Sₙ₋₁|), then both **S** and **V** must be permutations of their respective ranges.

The problem originates from music theory: pitch-classes 0–11 represent the 12 semitones, and a valid series uses every interval from a minor second (1) to a major seventh (11) exactly once.

Example (N=8): `[0,7,1,6,2,5,3,4]` → differences `[7,6,5,4,3,2,1]` 

## Problem Constraints

1. **S** is a permutation of {0, 1, …, N-1} — each pitch-class appears exactly once
2. The interval vector **V** is a permutation of {1, 2, …, N-1} — each interval appears exactly once

## Approaches

### 1. Backtracking (`007AllIntervalBacktracking.pl`)

- **Strategy:** Builds the sequence left to right, selecting each value with `select/3` (guarantees uniqueness in S automatically).
- **Pruning:** After each placement, computes the absolute difference with the previous value and rejects it immediately if that interval has already been used. This prunes invalid branches without waiting for the full sequence to be built.

### 2. Constraint Logic Programming (`007AllIntervalCLP.pl`)

- **Strategy:** Declares all constraints upfront using `library(clpfd)`, then calls `label/1` to search.
- `all_distinct/1` enforces uniqueness for both **S** and the difference vector **V**.
- `consecutive_diffs/2` builds the difference vector using `D #= abs(B - A)` for each consecutive pair.
- Constraint propagation narrows domains before any search begins.

## How to Run

1. Start SWI-Prolog: `swipl`
2. Consult a file, e.g.: `?- ['007AllIntervalBacktracking.pl'].`

**Backtracking:**
```prolog
?- all_interval(8, S).
?- time(all_interval(12, S)).
```

**CLP:**
```prolog
?- ['007AllIntervalCLP.pl'].
?- all_interval(8, S).
?- time(all_interval(12, S)).
```

To print the difference vector alongside the solution:
```prolog
?- all_interval(8, S),
   maplist([A,B,D]>>(D is abs(B-A)), S, [_|S], Diffs),
   write(S), nl, write(Diffs), nl.
```
