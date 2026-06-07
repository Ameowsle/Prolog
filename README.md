# Constraint Satisfaction Problems (CSP) in Prolog

Collection of various CSP problems from [CSPLib](https://www.csplib.org/Problems/) implemented in Prolog with focus on efficient declarative solutions.

## Problems

### [Golomb Ruler](https://www.csplib.org/Problems/prob006/)
Find N marks on a ruler where all pairwise differences are distinct.
- **Approaches:** Backtracking, CLP
- **Key Insight:** Rejecting a candidate mark as soon as one of its distances repeats prunes the search early.

### [All-Interval Series](https://www.csplib.org/Problems/prob007/)
Find a permutation of {0,…,N-1} whose N-1 consecutive absolute differences are themselves a permutation of {1,…,N-1}.
- **Approaches:** Backtracking, CLP
- **Key Insight:** Building left to right with `select/3` keeps the series unique automatically; intervals are checked on placement.

### [Nonogram](https://www.csplib.org/Problems/prob012/)
Logic puzzle where grid cells must be filled (1) or empty (0) based on row and column constraints. Three different approaches: Row-by-Row with Early Pruning, All-at-Once Constraint Check, and CLP.

### [Schur's Lemma](https://www.csplib.org/Problems/prob015/)
Colour the integers 1 to N with C colours so that no colour class contains x, y, z with x + y = z. The largest N solvable with C colours is the Schur number S(C): S(2)=4, S(3)=13.
- **Approaches:** Backtracking (integers coloured ascending, sum-free check on placement), CLP (one colour variable per integer, a reified constraint per x+y=z triple)
- **Key Insight:** Colouring ascending means each new integer only needs checking as the *sum* of two already-coloured ones.

### [Magic Squares](https://www.csplib.org/Problems/prob019/)
Find NxN matrices containing numbers 1 to N² where all rows, columns, and diagonals sum to the magic constant.
- **Approach:** Constraint Logic Programming (CLP)
- **Method:** Domain setting, uniqueness constraints, sum constraints, labeling

### [Langford's Number Problem](https://www.csplib.org/Problems/prob024/)
Place two copies of each number 1..N in a sequence of length 2N so that the two copies of K have exactly K numbers between them.
- **Approaches:** Backtracking (largest number first), CLP (position variables linked via `element/3`)
- **Key Insight:** A solution exists only when N mod 4 is 0 or 3.

### [Balanced Incomplete Block Design (BIBD)](https://www.csplib.org/Problems/prob028/)
Build the V×B incidence matrix of a (V,B,R,K,L) design: fixed row sums, column sums, and pairwise row overlaps.
- **Approaches:** Backtracking (row-by-row), CLP (with `lex_chain` symmetry breaking)
- **Key Insight:** Lexicographic ordering of rows and columns prunes the design's large symmetry group.

### [Sudoku](https://www.csplib.org/Problems/prob040/)
Solve 9x9 Sudoku puzzles using backtracking and constraint satisfaction techniques.

### [Number Partitioning](https://www.csplib.org/Problems/prob049/)
Split the numbers 1 to N into two sets of equal size, equal sum, and equal sum of squares.
- **Approaches:** Backtracking (with overshoot pruning), CLP
- **Key Insight:** Only one set needs tracking, the fixed grand totals force the other.

### [N-Queens Problem](https://www.csplib.org/Problems/prob054/)
Place N queens on an NxN chessboard so that no two queens threaten each other.
- **Approaches:** Naive (Generate & Test), Optimized (Backtracking with Interleaving), CLP
- **Performance (N=15):** ~3B inferences (Naive) vs. 190K (Optimized) vs. 81K (CLP)
- **Key Insight:** Interleaving constraints during search dramatically reduces search space

### [Killer Sudoku](https://www.csplib.org/Problems/prob057/)
Extended Sudoku variant with additional sum cage constraints. Cells grouped into "cages" must sum to specified totals.

### [Quasigroup Completion](https://www.csplib.org/Problems/prob067/)
Complete a partially filled Latin square so that each value appears once per row and per column.
- **Approaches:** Backtracking per Line, Backtracking per Cell, Backtracking per Cell + Domain Constraint, CLP
- **Performance (7×7, 15 pre-filled):** 271M inferences (per Line) vs. 459K (CLP) vs. 35K (per Cell + Domain Constraint)
- **Key Insight:** Checking column constraints per cell instead of per line prunes invalid branches far earlier.

### [Costas Array](https://www.csplib.org/Problems/prob076/)
Find a permutation of 1..N whose displacement vectors between all pairs of marks are distinct.
- **Approaches:** Backtracking (with per-level difference buckets), CLP
- **Key Insight:** Verifying that each new mark introduces no repeated difference at any level rejects bad branches immediately.
