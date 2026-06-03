# Problem 030: Balanced Incomplete Block Design (BIBD)
*(Source: CSPLib Problem [prob030](https://www.csplib.org/Problems/prob030/))*

A BIBD with parameters `(V, B, R, K, L)` arranges `V` objects into `B` blocks such that every block holds `K` distinct objects, every object appears in `R` blocks, and every pair of objects occurs together in exactly `L` blocks.

It is represented as a `V × B` binary **incidence matrix**: row `i`, column `j` is `1` iff object `i` is in block `j`.

Example: the Fano plane `(7, 7, 3, 3, 1)`: 7 points, 7 lines, each point on 3 lines, each line through 3 points, each pair of points on exactly 1 line.

## Problem Constraints

1. Each **row** sums to `R` (each object in `R` blocks)
2. Each **column** sums to `K` (each block holds `K` objects)
3. The scalar product of **any two rows** equals `L` (each pair shares `L` blocks)

The parameters are not independent: `B·K = V·R` and `L·(V-1) = R·(K-1)`.

## Approaches

### 1. Backtracking (`030BIBDBacktracking.pl`)

- Builds the matrix one row at a time; each row is generated as a 0/1 list with exactly `R` ones.
- Maintains running column totals, a branch is rejected if a column exceeds `K` or can no longer reach `K` with the rows that remain.
- Rejects a row immediately if it shares more than `L` ones with any placed row; the exact `= L` overlap is verified once all rows are down.

### 2. Constraint Logic Programming (`030BIBDCLP.pl`)

- The whole `V × B` matrix is created as 0/1 variables up front.
- `sum/3` posts the row and column sum constraints; `pairwise_overlap/2` posts the scalar-product constraint for every pair of rows.
- `lex_chain/1` orders rows and columns lexicographically, a symmetry break that prunes the design's large symmetry group.

---

## Performance

Inferences to the first solution (SWI-Prolog).

| Instance         |   CLP | Backtracking |
|------------------|------:|-------------:|
| (7,7,3,3,1) Fano |  207K |           8K |
| (9,12,4,3,1)     |  850K |         157K |
| (13,13,4,4,1)    | 2.07M |         349K |

Backtracking is faster for the first solution: it generates each row directly as a combination with exactly `R` ones and rejects it with cheap arithmetic checks, avoiding the per-cell labeling and propagation that the CLP model pays for. The `lex_chain` symmetry break is not the bottleneck; dropping it makes the CLP search slower (3.57M inferences instead of 2.07M on `(13,13,4,4,1)`), because it also prunes symmetric branches on the way to the first solution. Its larger pay-off is when enumerating all designs, where the backtracking solver, which has no symmetry break, would walk every symmetric copy.

## How to Run

1. Start SWI-Prolog: `swipl`
2. Consult a file, e.g.: `?- ['030BIBDCLP.pl'].`

**CLP:**
```prolog
?- ['030BIBDCLP.pl'].
?- bibd(7, 7, 3, 3, 1, Rows).
?- time(bibd(6, 10, 5, 3, 2, Rows)).
```

**Backtracking:**
```prolog
?- ['030BIBDBacktracking.pl'].
?- bibd(7, 7, 3, 3, 1, Rows).
```
