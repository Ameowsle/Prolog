```markdown
# Prolog Nonogram Solver
*(Source: CSPLib Problem [prob012](https://www.csplib.org/Problems/prob012/))*

**Nonograms** are logic puzzles where a grid matrix must be constructed with 1 for filled blocks and 0 for empty cells. Constraints for each row and column define the sequence of consecutive filled blocks (e.g., [3,1,2] = block of 3, gap, block of 1, gap, block of 2).

## Constraints

1. **Row Constraints:** Each row satisfies its sequence of block lengths
2. **Column Constraints:** Each column satisfies its sequence of block lengths
3. **Block Uniqueness:** No gaps within blocks, gaps separate blocks

## Performance Comparison (5×5 Grid)

The following metrics were recorded using the `time/1` predicate in SWI-Prolog:

| Approach | Logical Inferences | CPU Time | Wall Time | Status |
| :--- | :--- | :--- | :--- | :--- |
| **Backtracking with Interleaving** | 281,253 | 0.007s | 0.007s | Success |
| **CLP (Constraint Logic)** | 1,067,544,421 | 22.879s | 23.032s | Success |

## Approaches

### 1. Backtracking with Interleaving (012NonogramBacktrack.pl)
- **Strategy:** Constraints are checked incrementally during search
- **Method:** `check_line/2` generates valid row patterns using `append/3` with immediate constraint checking
- **Custom Transpose:** Uses `my_transpose/2` without library dependencies
- **Key Insight:** Interleaving constraints during search dramatically prunes invalid branches

### 2. Constraint Logic Programming (012Nonogram.pl)
- **Strategy:** Uses `library(clpfd)` to define constraints
- **Method:** `label/1` generates combinations with constraint propagation
- **Trade-off:** More setup overhead, but better scalability for very large grids

## How to Run

```prolog
?- nonogram(Solution), maplist(writeln, Solution).
```

## Observations

The Backtracking approach significantly outperforms CLP on this 5×5 puzzle, demonstrating that **interleaving constraints with search is more efficient than global constraint propagation for line-based puzzles**. The custom transpose function works correctly and eliminates library dependencies.

```
