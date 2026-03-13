# Prolog N-Queens Solver
*(Source: CSPLib Problem [prob054](https://www.csplib.org/Problems/prob054/))*


This repository contains three different approaches to solving the classic **N-Queens Problem** in Prolog. It demonstrates the massive performance difference between a "Generate and Test" strategy, an optimized "Backtracking with Interleaving" approach and a solution using Constraint Logic Programming (CLP).

## Performance Comparison (N=15)

The following metrics were recorded using the `time/1` predicate in SWI-Prolog:

| Approach | Logical Inferences | CPU Time | Status |
| :--- | :--- | :--- | :--- |
| **Naive (Generate & Test)** | ~3,000,000,000s | 130s | Abort |
| **Optimized (Interleaving)** | 190,310 | 0.030s| Success |
| **CLP (Constraint Logic)** | 81,575 | 0.006s | Success |
---

##  Approaches

### 1. Naive Approach: Generate and Test
The `n_queens/2` predicate uses a "blind" search strategy. It first generates a full permutation of the board and only then checks if it is valid.
* **Complexity:** Generates $N!$ permutations. For $N=15$, there are over 1.3 trillion possibilities.

### 2. Optimized Approach: Backtracking with Interleaving
The `n_queens2/2` predicate uses "Interleaving". It checks for safety **immediately** after placing a single queen.
* **Strategy:** If a queen is attacked, Prolog performs **Backtracking** immediately, pruning the entire search tree branch and saving billions of unnecessary checks.

### 3. Advanced Approach: Constraint Logic Programming (CLP)
The `n_queens_clp/2` using the clpfd library, defines logical constraints (rules) instead of manual checks. The programm tries to find a solution according to the rules. It eliminates the impossible solutions (i.e. two queens on the same diagonal or horizontal) before attempting to place the queens. 

* **Scalability:** While Backtracking is fast for small N, CLP is the only approach that remains efficient for very large boards (e.g., N=100).



### Description (from Clib: https://www.csplib.org/Problems/prob054/)

Can n queens (of the same colour) be placed on a n×n chessboard so that none of the queens can attack each other?

In chess a queen attacks other squares on the same row, column, or either diagonal as itself. So the n-queens problem is to find a set of n locations on a chessboard, no two of which are on the same row, column or diagonal.


A simple arithmetical observation may be helpful in understanding models. Suppose a queen is represented by an ordered pair (α,β), the value α represents the queen’s column, and β its row on the chessboard. Then two queens do not attack each other iff they have different values of all of α, β, α-β, and α+β. It may not be intuitively obvious that chessboard diagonals correspond to sums and differences, but consider moving one square along the two orthogonal diagonals: in one direction the sum of the coordinates does not change, while in the other direction the difference does not change. (We do not suggest that pairs (α,β) is a good representation for solving.)

The problem has inherent symmetry. That is, for any solution we obtain another solution by any of the 8 symmetries of the chessboard (including the identity) obtained by combinations of rotations by 90 degrees and reflections.

The problem is extremely well studied in the mathematical literature. An outstanding survey from 2009 is by Bell & Stevens [Bell20091].

See below for discussions of complexity problems with n-Queens. For closely related variants without these problems see n-Queens Completion Problem and Excluded Diagonals n-Queens Problem, [prob079], and Blocked n-Queens Problem, [prob080].

Complexity
Some care has to be taken when using the n-queens problem as a benchmark. Here are some points to bear in mind:

- The n-queens problem is solvable for n=1 and n≥4. So the decision problem is solvable in constant time.
- A solution to the n-queens problem for any n≠2,3 was given in 1874 by Pauls and can be found in Bell & Stevens’ survey [Bell20091]. It can be constructed in time O(n) (assuming arithemetical operations on size n are O(1).)
- Note that the parameter n for n-queens only needs log(n) bits to specify, so actually O(n) is exponential in the input size. I.e. it’s not trivial to provide a witness of poly size in the input.
- While the decision problem is easy, counting the number of solutions for given n is not. Indeed Bell & Stevens [Bell20091] report that there is no closed form expression for it and that it is “beyond #P-Complete”, citing [Hsiang200487]. (Oddly [chaiken_queens] report a closed form solution for the number of solutions to n-queens: it’s unclear if this contradicts the earlier result, but more importantly it’s not clear that this has better complexity than simply enumerating solutions.)

## How to Run
1. Start SWI-Prolog: `swipl`
2. Consult the file: `?- [filename].`
3. Run the CLP version: `?- n_queens_clp(12, L).`
