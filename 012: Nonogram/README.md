```markdown
# Prolog Nonogram Solver
*(Source: CSPLib Problem [prob012](https://www.csplib.org/Problems/prob012/))*

**Nonograms** are logic puzzles where a grid matrix must be constructed with 1 for filled blocks and 0 for empty cells. Constraints for each row and column define the sequence of consecutive filled blocks (e.g., [3,1,2] = block of 3, gap, block of 1, gap, block of 2).

## Constraints

1. **Row Constraints:** Each row satisfies its sequence of block lengths
2. **Column Constraints:** Each column satisfies its sequence of block lengths
3. **Block Uniqueness:** No gaps within blocks, gaps separate blocks

## Current Approach

### Generate and Test
- **Strategy:** `label/1` generates all possible 0/1 combinations (brute force)
- **Validation:** `findsol/3` tests if combination satisfies all row and column constraints
- **Efficiency:** Not efficient for large grids (2^N combinations), but works correctly for small puzzles
- **Optimization:** `once/1` stops after finding the first valid solution

## How to Run

```prolog
?- once(nanogram(Solution)), maplist(writeln, Solution).
```

## Future Extensions

Additional solving approaches planned for optimization (constraint propagation, specialized line solvers).

```
