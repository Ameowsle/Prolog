# Prolog Magic Square Solver
*(Source: CSPLib Problem [prob019](https://www.csplib.org/Problems/prob019/))*

This repository contains a declarative solution to the **Magic Square Problem** using Prolog with **Constraint Logic Programming (CLP)** to efficiently find $N \times N$ matrices where every row, column, and both main diagonals sum up to the same magic constant.


---

## Approach: Constraint Logic Programming (CLP)

The `magic_square/2` predicate follows a strict declarative structure:

1.  **Matrix Setup:** Initializes an $N \times N$ grid of variables.
2.  **Domain & Uniqueness:** Sets the domain for all cells from $1$ to $N^2$ and ensures no number is repeated using `all_different/1`.
3.  **Sum Constraints:** * Calculates the magic sum using the formula: $Sum = \frac{N(N^2 + 1)}{2}$.
    * Enforces this sum for all **Rows**.
    * Transposes the matrix to enforce the same sum for all **Columns**.
    * Uses helper predicates (`diag1_cell`, `diag2_cell`) to calculate and enforce the **Diagonal** sums.
4.  **Labeling:** Once the logical rules are defined, `label/1` performs the actual search for numbers that satisfy all conditions.

---

## Description (from CSPLib: [prob019](https://www.csplib.org/Problems/prob019/))


An order n magic square is a n by n matrix containing the numbers 1 to n2, with each row, column and main diagonal equal the same sum. As well as finding magic squares, we are interested in the number of a given size that exist. There are several interesting variations. For example, we may insist on certain values in certain squares (like in quasigroup completion) and ask if the magic square can be completed. In a heterosquare, each row, column and diagonal sums to a different value. In an anti-magic square, the row, column and diagonal sums form a sequence of consecutive integers.

A magic sequence of length n is a sequence of integers x0…xn−1 between 0 and n−1, such that for all i in 0 to n−1, the number i occurs exactly xi times in the sequence. For instance, 6,2,1,0,0,0,1,0,0,0 is a magic sequence since 0 occurs 6 times in it, 1 occurs twice, etc.



### Problem Constraints:
* Each number from $\{1, \dots, n^2\}$ must appear exactly once.
* The sum of each row, column, and the two main diagonals must be equal to the magic constant.

### Complexity:
While a $3 \times 3$ square (the Lo Shu Square) is trivial, the number of magic squares increases rapidly with $