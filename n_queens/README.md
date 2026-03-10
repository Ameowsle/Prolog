# Prolog N-Queens Solver

This repository contains two different approaches to solving the classic **N-Queens Problem** in Prolog. It demonstrates the massive performance difference between a "Generate and Test" strategy and an optimized "Backtracking with Interleaving" approach.

## Performance Comparison (N=12)

The following metrics were recorded using the `time/1` predicate in SWI-Prolog:

| Approach | Logical Inferences | CPU Time | 
| :--- | :--- | :--- | :--- |
| **Naive (Generate & Test)** | ~89,400,000 | 4.891s | 
| **Optimized (Interleaving)** | **~25,800** | **0.005s** | 

---

##  Approaches

### 1. Naive Approach: Generate and Test
The `n_queens/2` predicate uses a "blind" search strategy. It first generates a full permutation of the board and only then checks if it is valid.
* **Complexity:** Generates $N!$ permutations. For $N=12$, that is 479,001,600 possible boards to check.

### 2. Optimized Approach: Backtracking with Interleaving
The `n_queens2/2` predicate uses "Interleaving". It checks for safety **immediately** after placing a single queen.
* **Strategy:** If a queen is attacked, Prolog performs **Backtracking** immediately, pruning the entire search tree branch.

---

## How to Run
1. Start SWI-Prolog: `swipl`
2. Consult the file: `?- [filename].`
3. Run the optimized version: `?- n_queens2(12, L).`
