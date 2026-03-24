# Constraint Satisfaction Problems (CSP) in Prolog

Collection of various CSP problems from [CSPLib](https://www.csplib.org/) implemented in Prolog with focus on efficient declarative solutions.

## Problems

### [N-Queens Problem](https://www.csplib.org/Problems/prob054/)
Place N queens on an NxN chessboard so that no two queens threaten each other.
* **Approaches:** Naive (Generate & Test), Optimized (Backtracking with Interleaving), CLP
* **Performance (N=15):** ~3B inferences (Naive) vs. 190K (Optimized) vs. 81K (CLP)
* **Key Insight:** Interleaving constraints during search dramatically reduces search space

### [Magic Squares](https://www.csplib.org/Problems/prob019/)
Find NxN matrices containing numbers 1 to N² where all rows, columns, and diagonals sum to the magic constant.
* **Approach:** Constraint Logic Programming (CLP)
* **Method:** Domain setting, uniqueness constraints, sum constraints, labeling

### Sudoku
Solve 9x9 Sudoku puzzles using backtracking and constraint satisfaction techniques. 

### Killer Sudoku (https://www.csplib.org/Problems/prob057/)
Extended Sudoku variant with additional sum cage constraints.

