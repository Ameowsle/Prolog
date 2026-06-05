# Problem 024: Langford's Number Problem
*(Source: CSPLib Problem [prob024](https://www.csplib.org/Problems/prob024/))*

Place two copies of each number 1..N into a sequence of length 2N such that the two copies of each number K have exactly K numbers between them.

Example (N=3): `[3, 1, 2, 1, 3, 2]`
- The two 1s are at positions 2 and 4, 1 number between them
- The two 2s are at positions 3 and 6, 2 numbers between them
- The two 3s are at positions 1 and 5, 3 numbers between them

> Note: A solution only exists when N mod 4 = 0 or N mod 4 = 3 (e.g. N = 3, 4, 7, 8, ...).

## Problem Constraints

1. Each number K appears exactly twice in the sequence
2. The two occurrences of K are at positions I and I + K + 1

## Approaches

### 1. Backtracking (`024LangfordBacktracking.pl`)

- **Strategy:** Starts with a 2N list of unbound variables and places numbers from N down to 1 (largest first, as they have fewer valid positions).
- **Placement:** For each K, `between/3` tries each starting position I. `nth1/3` unifies position I and position I+K+1 with K. If either is already taken by a different number, it fails and backtracks automatically.

### 2. Constraint Logic Programming (`024LangfordCLP.pl`)

- **Strategy:** For each K, introduces two position variables P1 and P2 = P1+K+1 and uses `element/3` to link them to the sequence S.
- `all_distinct/1` on all 2N position variables ensures no two numbers share a slot.
- Labeling the position variables propagates directly into S via the element constraints.

## How to Run

1. Start SWI-Prolog: `swipl`
2. Consult a file, e.g.: `?- ['024LangfordBacktracking.pl'].`

**Backtracking:**
```prolog
?- langford(3, S).
?- langford(4, S).
?- solve(S).
```

**CLP:**
```prolog
?- ['024LangfordCLP.pl'].
?- langford(3, S).
?- langford(4, S).
?- solve(S).
```
