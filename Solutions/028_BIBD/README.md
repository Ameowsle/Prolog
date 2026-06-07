# Problem 028: Balanced Incomplete Block Design (BIBD)
*(Source: CSPLib Problem [prob028](https://www.csplib.org/Problems/prob028/))*

A BIBD with parameters `(V, B, R, K, L)` arranges `V` objects into `B` blocks such that every block holds `K` distinct objects, every object appears in `R` blocks, and every pair of objects occurs together in exactly `L` blocks.

It is represented as a `V x B` binary **incidence matrix**: row `i`, column `j` is `1` iff object `i` is in block `j`.

Example: the Fano plane `(7, 7, 3, 3, 1)`: 7 points, 7 lines, each point on 3 lines, each line through 3 points, each pair of points on exactly 1 line.

## Problem Constraints

1. Each **row** sums to `R` (each object in `R` blocks)
2. Each **column** sums to `K` (each block holds `K` objects)
3. The scalar product of **any two rows** equals `L` (each pair shares `L` blocks)

The parameters are not independent: `B*K = V*R` and `L*(V-1) = R*(K-1)`.

## Approaches

### 1. Backtracking (`028BIBDBacktracking.pl`)

- Builds the matrix one row at a time; each row is generated as a 0/1 list with exactly `R` ones.
- Maintains running column totals, a branch is rejected if a column exceeds `K` or can no longer reach `K` with the rows that remain.
- Rejects a row immediately if it shares more than `L` ones with any placed row; the exact `= L` overlap is verified once all rows are down.

### 2. Constraint Logic Programming (`028BIBDCLP.pl`)

- The whole `V x B` matrix is created as 0/1 variables up front.
- `sum/3` posts the row and column sum constraints; `pairwise_overlap/2` posts the scalar-product constraint for every pair of rows.
- `lex_chain/1` orders rows and columns lexicographically, a symmetry break that prunes the design's large symmetry group.

---

## Counting Solutions

The two solvers report different solution counts because they count different
things, not because either is wrong. On the Fano plane `(7,7,3,3,1)`:

| Solver        | Count   | What it counts                                       |
| :---          | :---    | :---                                                 |
| CLP           | 1       | one lex-canonical representative per design          |
| Backtracking  | 151200  | every labeled incidence matrix meeting the constraints |

The CLP model posts `lex_chain` on both rows and columns, so out of all the
matrices that satisfy the design constraints it keeps only the single
lexicographically smallest one per symmetry class. For the Fano plane (a unique
design up to isomorphism) that leaves exactly `1`.

The backtracking solver applies no symmetry break: it enumerates every labeled
matrix whose rows sum to `R`, whose columns sum to `K`, and whose row pairs
overlap in `L`. For the Fano plane that is `151200`, which factors as the `30`
labeled `(7,3,1)` designs times the `7! = 5040` orderings of the blocks
(columns). This figure was cross-checked against `bibd.mzn` with its two
`lex_lesseq` constraints removed, which also enumerates `151200`.

So both solvers find the same designs; they differ only in how many symmetric
copies of each they report. Counting all designs is therefore the job of the
CLP model, the backtracking enumeration is practical only for the smallest
instance.

## Performance Comparison ((13,13,4,4,1) projective plane)

Measured with `time/1` in SWI-Prolog (first solution). The "Speed vs. CLP" column is the ratio of logical inferences, the most reproducible metric at these sub-second times; the CPU and wall columns show the actual, much smaller time gap.

| Approach         | Logical Inferences | CPU Time | Wall Time | Speed vs. CLP |
| :---             | :---               | :---     | :---      | :---          |
| **Backtracking** | 348,688            | 0.018s   | 0.026s    | **5.9x**      |
| **CLP**          | 2,066,191          | 0.064s   | 0.065s    | Baseline      |

The same ordering holds on the smaller instances (e.g. `(7,7,3,3,1)`: 8K vs 207K inferences).

Backtracking is faster for the first solution: it generates each row directly as a combination with exactly `R` ones and rejects it with cheap arithmetic checks, avoiding the per-cell labeling and propagation that the CLP model pays for. The `lex_chain` symmetry break is not the bottleneck; dropping it makes the CLP search slower (3.57M inferences instead of 2.07M on `(13,13,4,4,1)`), because it also prunes symmetric branches on the way to the first solution. Its larger pay-off is when enumerating all designs, where the backtracking solver, which has no symmetry break, would walk every symmetric copy.

## How to Run

1. Start SWI-Prolog: `swipl`
2. Consult a file, e.g.: `?- ['028BIBDCLP.pl'].`

**CLP:**
```prolog
?- ['028BIBDCLP.pl'].
?- bibd(7, 7, 3, 3, 1, Rows).
?- time(bibd(6, 10, 5, 3, 2, Rows)).
```

**Backtracking:**
```prolog
?- ['028BIBDBacktracking.pl'].
?- bibd(7, 7, 3, 3, 1, Rows).
```
