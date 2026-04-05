# Problem 067: Quasigroup Completion

*(Source: CSPLib Problem [prob067](https://github.com/csplib/csplib/tree/main/Problems/prob067))*

## Problem Description

A **quasigroup** is a Latin square of size $m \times m$. That is, an $m \times m$ multiplication table where each element (typically values from 1 to $m$) occurs exactly once in every row and every column.

The **Quasigroup Completion problem** asks to complete a partially specified quasigroup. Given some entries of the table already filled in, the task is to fill in the remaining entries such that each row and column contains each value exactly once.

### Example

A complete 4×4 quasigroup:
```
1  2  3  4
4  1  2  3
3  4  1  2
2  3  4  1
```

A partial quasigroup to be completed:
```
1           4
       2       
3           1        
       3       
```

Could be completed as the full quasigroup shown above.

## Constraints

1. **Row constraint:** Each row must contain each value 1 to $m$ exactly once
2. **Column constraint:** Each column must contain each value 1 to $m$ exactly once
3. **Initial values:** Certain cells are pre-filled and must be respected

## Approaches

### Approach 1: Constraint Logic Programming (CLP(FD))

- **Strategy:** Define domain constraints using `library(clpfd)` with `ins`, `all_distinct`, `transpose`, and `label`
- **Key Features:** Flatten matrix into variable list (with append/2), enforce row and column distinctness, search with constraint propagation




## How to Run

1. Start SWI-Prolog: `swipl`
2. Consult the file: `?- ['068:quasigroupCLP.pl'].`
3. Run the solver: `?- quasigroup(Solution).`
3. Run the CLP version: `?- quasigroup(Solution).`



