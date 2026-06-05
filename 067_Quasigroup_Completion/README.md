# Problem 067: Quasigroup Completion
*(Source: CSPLib Problem [prob067](https://www.csplib.org/Problems/prob067/))*

A quasigroup is a Latin square of size `m x m`: an `m x m` table where each
value `1..m` occurs exactly once in every row and every column. The Quasigroup
Completion problem starts from a partially filled table and asks to fill in the
remaining cells so that the row and column property holds.

Example, a partial 4x4 quasigroup (`_` is an empty cell):
```
1  _  _  4
_  _  2  _
3  _  _  _
_  3  _  _
```
One completion:
```
1  2  3  4
4  1  2  3
3  4  1  2
2  3  4  1
```

## Problem Constraints

1. Each row contains each value `1..m` exactly once
2. Each column contains each value `1..m` exactly once
3. The pre-filled cells keep their given values

In all four solvers the puzzle is passed as an argument (`quasigroup(Puzzle,
Solution)`), so the same relation solves any instance. The board stored in
`partially_quasigroup/1` is only an example instance; empty cells are unbound
variables that the solver fills in place.

## Approaches

### 1. Backtracking per Line (`067QuasigroupCompletionBacktrackingPerLine.pl`)

- Strategy: assign a whole row from the domain, then check the row and all
  columns.
- Method: `assign_and_check_row/3` fills every empty cell of a row with a value
  from `1..M`, calls `all_diff/1` on the row, then checks every column with
  `check_col_partial/2`.
- Column conflicts are only detected once a full row is complete, so
  backtracking happens at the row level. This is the slowest variant and is kept
  as a baseline.

### 2. Backtracking per Cell (`067QuasigroupCompletionBacktrackingPerCell.pl`)

- Strategy: cell-by-cell assignment with an immediate column check after each
  placement.
- Method: `fill_row/3` reduces the row domain by the pre-filled values.
  `assign_cell/4` then picks values one cell at a time via `select/3` and calls
  `check_col_partial/2` after each placement.
- Checking columns at the cell level (rather than after a full row) lets the
  search backtrack earlier and prune invalid branches sooner.

### 3. Backtracking per Cell + Domain Constraint (`067QuasigroupCompletionBacktrackingPerCellDomainConstraint.pl`)

- Strategy: cell-by-cell assignment with row and column domain restriction
  before each placement.
- Method: before assigning a cell, `assign_cell_dc/4` subtracts the values
  already used in the current column from the remaining row domain and assigns
  from that candidate set.
- Column conflicts are ruled out before a value is chosen, so `check_col_partial/2`
  is not needed and conflicting candidates never enter the search tree. This is
  the fastest variant.

### 4. Constraint Logic Programming (`067QuasigroupCompletionCLP.pl`)

- Strategy: declarative constraint solving with `library(clpfd)`.
- Method: the matrix is flattened with `append/2`, every cell is constrained to
  `1..M`, and `all_distinct/1` is posted on every row and (via `transpose/2`)
  every column. `label/1` then searches.
- Constraint propagation shrinks the domains before search, eliminating large
  parts of the search space without explicit backtracking logic.

## Performance Comparison

Measured with `time/1` in SWI-Prolog on the example 7x7 instance with 15
pre-filled cells (`partially_quasigroup/1`), first solution. All four solvers
and both MiniZinc reference models agree on 42 total completions for this
instance. Logical inferences are the reproducible metric; CPU times are
indicative.

| Approach | Logical Inferences | CPU Time |
| :--- | ---: | ---: |
| Backtracking per Cell + Domain Constraint | 35,343 | 0.002s |
| Backtracking per Cell | 43,947 | 0.002s |
| CLP (Constraint Logic) | 159,998 | 0.005s |
| Backtracking per Line | 271,419,174 | 6.562s |

Per-line backtracking is by far the slowest: it only detects column conflicts
after an entire row is filled, so it explores many invalid partial assignments.
Per-cell backtracking checks columns after every single placement and prunes
much earlier. Adding the domain constraint pushes this a step further by
filtering column-conflicting values before a cell is assigned at all. The CLP
model is the most concise and propagates constraints before search, but carries
the overhead of building and maintaining the constraint network.

## How to Run

1. Start SWI-Prolog: `swipl`
2. Consult a file, e.g.: `?- ['067QuasigroupCompletionCLP.pl'].`
3. Solve the example instance:
```prolog
?- partially_quasigroup(P), quasigroup(P, S), maplist(writeln, S).
```
4. Count all completions of the example instance:
```prolog
?- aggregate_all(count, (partially_quasigroup(P), quasigroup(P, _)), N).
```

To try another approach, consult `067QuasigroupCompletionBacktrackingPerCell.pl`,
`067QuasigroupCompletionBacktrackingPerCellDomainConstraint.pl`, or
`067QuasigroupCompletionBacktrackingPerLine.pl` instead. To solve a different
puzzle, pass your own board to `quasigroup/2` (filled cells as values `1..M`,
empty cells as unbound variables).
