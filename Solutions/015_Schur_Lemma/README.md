# Problem 015: Schur's Lemma
*(Source: CSPLib Problem [prob015](https://www.csplib.org/Problems/prob015/))*

Colour the integers `1..N` with `C` colours so that **no colour class is "spoiled"**, i.e. no colour class contains three integers `x`, `y`, `z` (not necessarily distinct) with `x + y = z`.

Example (N=4, C=2): `[1, 2, 2, 1]` gives colour 1 = {1, 4}, colour 2 = {2, 3}.
Neither class contains a triple with `x + y = z`.

The largest N solvable with `C` colours is the **Schur number** `S(C)`: `S(2)=4`, `S(3)=13`, `S(4)=44`. So `schur(13, 3, _)` succeeds but `schur(14, 3, _)` fails.

## Problem Constraints

1. Each integer `1..N` gets exactly one colour from `1..C`
2. No colour class contains `x`, `y`, `z` (x and y may be equal) with `x + y = z`

## Approaches

### 1. Backtracking (`015SchurLemmaBacktracking.pl`)

- Colours the integers `1, 2, ..., N` in order, trying each colour in turn.
- Because integers are coloured ascending, a new integer `I` can only be the *sum* of two already-coloured integers, so only triples `x + y = I` need checking.
- Symmetry break: integer 1 is fixed to colour 1.

### 2. Constraint Logic Programming (`015SchurLemmaCLP.pl`)

- One colour variable per integer, domain `1..C`.
- `triples/2` enumerates every `x + y = z` triple once; each posts a reified constraint that the three integers are not all the same colour.
- Symmetry break: integer 1 is fixed to colour 1.

---

## Performance Comparison (N=13, C=3)

Measured with `time/1` in SWI-Prolog (first solution). The "Speed vs. CLP" column is the ratio of logical inferences; both approaches finish in about 2 ms, too small for a reliable time-based ratio.

| Approach         | Logical Inferences | CPU Time | Wall Time | Speed vs. CLP |
| :---             | :---               | :---     | :---      | :---          |
| **Backtracking** | 34,726             | 0.002s   | 0.003s    | **2.1x**      |
| **CLP**          | 73,356             | 0.002s   | 0.002s    | Baseline      |

Backtracking does fewer inferences because, colouring the integers ascending, it only checks triples whose sum is the integer just placed, whereas the CLP version posts a reified constraint for every triple up front. The unsatisfiable instance `N=14, C=3` is proved the same way, in 76K (backtracking) vs 294K (CLP) inferences.

## How to Run

1. Start SWI-Prolog: `swipl`
2. Consult a file, e.g.: `?- ['015SchurLemmaBacktracking.pl'].`

**Backtracking:**
```prolog
?- schur(4, 2, Colours).
?- time(schur(13, 3, Colours)).
?- schur(14, 3, Colours).   % fails: exceeds S(3)
```

**CLP:**
```prolog
?- ['015SchurLemmaCLP.pl'].
?- schur(4, 2, Colours).
?- time(schur(13, 3, Colours)).
```
