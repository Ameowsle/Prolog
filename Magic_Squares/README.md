# Problem 019: Magic Square
*(Source: CSPLib Problem [prob019](https://www.csplib.org/Problems/prob019/))*

An order n magic square is an n×n matrix containing the numbers 1 to n², where every row, column, and both main diagonals sum to the same value — the **magic sum**.

> Note: CSPLib prob019 also describes magic sequences, which is a separate problem and is not solved here.

## Problem Constraints

1. Each number from 1 to n² appears exactly once
2. Every row sums to the magic sum
3. Every column sums to the magic sum
4. Both main diagonals sum to the magic sum

The magic sum is always: $S = \frac{n(n^2 + 1)}{2}$

For example, a 3×3 magic square has sum $S = \frac{3 \cdot 10}{2} = 15$.

## Approaches

### 1. Backtracking (`019MagicSquareBacktracking.pl`)

- **Strategy:** Fills cells one by one using `select/3`, which picks an unused value from the remaining domain and thereby guarantees uniqueness automatically.
- **Partial sum check:** After every cell assignment, each row, column, and diagonal is checked:
  - If the line is incomplete: partial sum must not yet exceed S
  - If the line is complete: sum must equal S exactly
- This prunes invalid branches early without waiting for the full grid to be filled.

### 2. Constraint Logic Programming (`019MagicSquareCLP.pl`)

- **Strategy:** Declares all constraints upfront using `library(clpfd)`, then calls `label/1` to search.
- `all_distinct/1` enforces uniqueness, `sum/3` enforces the row/column/diagonal sums.
- Constraint propagation reduces variable domains before any search begins.

## How to Run

The only parameter you need to provide is **N** (the grid size). The magic sum is computed automatically inside both solvers.

1. Start SWI-Prolog: `swipl`
2. Consult a file, e.g.: `?- ['019MagicSquareBacktracking.pl'].`

**Backtracking:**
```prolog
?- magic_square_bt(3, Square).
?- time(magic_square_bt(3, Square)).
```

**CLP:**
```prolog
?- magic_square(3, Square).
?- time(magic_square(3, Square)).
```

To print the result row by row:
```prolog
?- magic_square_bt(3, Square), maplist(writeln, Square).
```
