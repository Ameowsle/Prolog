https://www.csplib.org/Problems/prob076/ 

## Costas Array (CSPLib prob076)

A Costas Array of size N is a permutation of 1..N where all displacement vectors between pairs of marked cells are distinct — equivalently, for each level L, all differences X(i+L)-X(i) are distinct.

---

## CLP Approach (`076CostasArrayCLP.pl`)

Uses CLP(FD) constraints. The permutation and distinctness conditions are posted as constraints upfront, and the solver propagates them to shrink the domain before labeling. This detects conflicts early, making it significantly faster than backtracking.

---

## Backtracking Approach (`076CostasArrayBacktracking.pl`)

Builds the permutation one value at a time using `select/3`. After each placement, `check_diffs` verifies that no new Level-Diff pair duplicates an already used one — if it does, Prolog backtracks and tries the next candidate. Values are prepended to `Placed` (O(1)) and reversed at the end, since appending to the back would cost O(n) per step.
