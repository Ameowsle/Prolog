https://www.csplib.org/Problems/prob076/ 

## Costas Array (CSPLib prob076)

A Costas Array of size N is a permutation of 1..N where all displacement vectors between pairs of marked cells are distinct — equivalently, for each level L, all differences X(i+L)-X(i) are distinct.

---

## CLP Approach (`076CostasArrayCLP.pl`)

Uses CLP(FD) constraints. The permutation and distinctness conditions are posted as constraints upfront, and the solver propagates them before labeling.

---

## Backtracking Approach (`076CostasArrayBacktracking.pl`)

Builds the permutation one value at a time using `select/3`. After each placement, `check_diffs` verifies that no new difference duplicates an already used one at the same level — if it does, Prolog backtracks and tries the next candidate. Values are prepended to `Placed` (O(1)) and reversed at the end, since appending to the back would cost O(n) per step. Used differences are kept in one bucket per level, so each check scans only that level's O(n) diffs rather than all O(n²) pairs.

---

## Performance

Measured wall time to the first solution (SWI-Prolog):

| N  | CLP        | Backtracking |
|----|-----------:|-------------:|
| 12 | 159 ms     | 5 ms         |
| 13 | 1.2 s      | 41 ms        |
| 14 | 20 s       | 152 ms       |
| 15 | timeout    | 1.6 s        |
| 16 | —          | 5.9 s        |

Both approaches explore the same search tree in the same order, so they return the same first solution. Backtracking is far faster here: it does the equivalent of forward checking with a tight per-level check, while CLP pays the propagation overhead of `clpfd` at every node without pruning any extra branches.
