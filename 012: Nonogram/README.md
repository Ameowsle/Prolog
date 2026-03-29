# Prolog Nonogram Solver
*(Source: CSPLib Problem [prob012](https://www.csplib.org/Problems/prob012/))*

**Nonograms** are logic puzzles where a grid matrix must be constructed with 1 for filled blocks and 0 for empty cells. Constraints for each row and column define the sequence of consecutive filled blocks (e.g., [3,1,2] = block of 3, gap, block of 1, gap, block of 2).

## Constraints

1. **Row Constraints:** Each row satisfies its sequence of block lengths
2. **Column Constraints:** Each column satisfies its sequence of block lengths
3. **Block Uniqueness:** No gaps within blocks, gaps separate blocks

## Performance Comparison (5×5 Grid)

The following metrics were recorded using the `time/1` predicate in SWI-Prolog:

| Approach | Logical Inferences | CPU Time | Wall Time | Speed vs. CLP |
| :--- | :--- | :--- | :--- | :--- |
| **Backtracking Optimized** | 60,061 | 0.002s | 0.002s | **11,772x faster** |
| **Backtracking with Interleaving** | 281,253 | 0.006s | 0.007s | **3,800x faster** |
| **CLP (Constraint Logic)** | 1,067,544,421 | 23.097s | 23.302s | Baseline |

## Approaches

### 1. Backtracking Optimized (012NonogramBacktrackOptimized.pl)
- **Strategy:** Row-by-row solving with early column pruning
- **Method:** Solves one row at a time, then immediately checks if columns are still feasible
- **Key Optimization:** `check_partial_line/2` provides early backtracking by detecting impossible column states
- **Performance:** ~4.7x faster than standard backtracking (60K vs. 281K inferences)

### 2. Backtracking with Interleaving (012NonogramBacktrack.pl)
- **Strategy:** Constraints are checked incrementally during search
- **Method:** `check_line/2` generates valid row patterns using `append/3` with immediate constraint checking
- **Custom Transpose:** Uses `my_transpose/2` without library dependencies
- **Key Insight:** Interleaving constraints during search dramatically prunes invalid branches

### 3. Constraint Logic Programming (012Nonogram.pl)
- **Strategy:** Uses `library(clpfd)` to define constraints
- **Method:** `label/1` generates combinations with constraint propagation
- **Trade-off:** More setup overhead, but designed for very large grids

## How to Run

```prolog
?- nonogram(Solution), maplist(writeln, Solution).
```

## Observations

The optimized backtracking approach dramatically outperforms all other strategies, achieving **11,772x speedup** over CLP through intelligent early pruning. The key insight is that checking partial column feasibility during row-by-row solving eliminates impossible branches before they expand the search space. The standard backtracking is already 3,800x faster than CLP, but adding row-by-row constraints with partial column validation provides an additional **4.7x speedup**, demonstrating that **intelligent pruning is more effective than global constraint propagation for line-based puzzles**.

### Note on the Cut (`!`)

The CLP version uses a cut (`!`) after `findsol/3` because `label/1` can find multiple solutions through backtracking. The cut stops the search after the first valid solution is found, which is typically what we want for Nonograms (they usually have only one solution). The Backtracking version doesn't need a cut because its constraint logic is deterministic, meaning it doesn't generate multiple solutions to backtrack through.
