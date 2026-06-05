# Problem 012: Nonogram
*(Source: CSPLib Problem [prob012](https://www.csplib.org/Problems/prob012/))*

A Nonogram is a logic puzzle on a grid where each cell is filled (1) or empty
(0). Each row and column carries a clue: a list of block lengths giving the
sizes of the consecutive runs of filled cells, in order, separated by at least
one empty cell (e.g. `[3,1,2]` means a run of 3, a gap, a run of 1, a gap, a
run of 2). The goal is to fill the grid so that every row and column matches its
clue.

The instance used here is a 5x5 plus sign:
`row_constraints([[1],[3],[5],[3],[1]])`, columns identical.

## Problem Constraints

1. Every row matches its clue: the runs of 1s have exactly the given lengths,
   in order.
2. Every column matches its clue under the same rule.
3. Runs are separated by at least one empty cell; there are no gaps inside a run.

## Approaches

The instance is supplied as the `row_constraints/1` and `col_constraints/1`
facts, but each solver takes the clues as arguments
(`nonogram(RowCounts, ColCounts, Solution)`), so the same relation solves any
instance.

### 1. Row-by-Row with Early Pruning (`012NonogramRowByRow.pl`)

- Fills one row at a time with `check_line/2`, then transposes the rows done so
  far and calls `check_partial_line/2` on each partial column. A column whose
  filled cells already cannot match its clue fails immediately, so the search
  backtracks before wasting effort on the remaining rows.
- This early column check is the key optimisation: it prunes impossible grids
  long before they are complete.

### 2. All-at-Once Constraint Check (`012NonogramAllAtOnce.pl`)

- Plain backtracking: `check_line/2` generates a candidate for every row, then
  the grid is transposed and each column is checked against its clue.
- There is no partial-column pruning, so it explores more of the search space
  than the row-by-row solver. Kept as a simple reference variant.

### 3. Constraint Logic Programming (`012NonogramCLP.pl`)

- Each clue is compiled into a small DFA whose accepted words are exactly the
  0/1 sequences matching that clue (`line_dfa/4`), and posted as a regular
  constraint with `automaton/3`, once per row and once per column.
- Because the automaton constraints propagate before and during `label/1`, the
  solver prunes invalid grids as it goes instead of generating then testing.
  This is the idiomatic CLP(FD) model and the same regular/automaton encoding
  used by the standard MiniZinc, ECLiPSe and SICStus solutions for this problem.

## Performance Comparison (5x5 plus instance)

All three solvers find the same unique solution. Logical inferences are the
reproducible metric (first solution, `time/1`); CPU times are indicative.

| Approach | Logical Inferences | CPU Time |
| :--- | :--- | :--- |
| Row-by-Row with Early Pruning | 6,997  | < 0.001s |
| All-at-Once                   | 34,973 | < 0.001s |
| CLP (automaton)               | 27,215 | < 0.001s |

On this small instance all three are effectively instant. The row-by-row solver
does least work because partial-column pruning rejects dead grids early. The CLP
model is the one built to scale: its `automaton/3` constraints propagate the
clues during search, so it stays practical on large grids where the plain
backtracking search space would explode.

## How to Run

1. Start SWI-Prolog: `swipl`
2. Consult a file, e.g.: `?- ['012NonogramRowByRow.pl'].`
3. Solve the example instance and print the grid:

```prolog
?- row_constraints(R), col_constraints(C), nonogram(R, C, Solution),
   maplist(writeln, Solution).
```

The same query works for `012NonogramAllAtOnce.pl` and `012NonogramCLP.pl`.
To solve a different puzzle, pass its clues directly, e.g.:

```prolog
?- nonogram([[2],[1,1],[2]], [[2],[1,1],[2]], Solution), maplist(writeln, Solution).
```
