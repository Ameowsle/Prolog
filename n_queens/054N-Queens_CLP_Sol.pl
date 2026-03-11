:- use_module(library(clpfd)). % Load the CLP library (Constraint Logic Programming)

% Solution is a list where the index is the column and the value is the row.

n_queens_clp(N, Solution) :-
    length(Solution, N),        % Create a list with N anonymous variables
    Solution ins 1..N,          % 1. Rule: Every number in the list must be between 1 and N (the rows).
    all_different(Solution),    % 2. Rule: No two queens can be in the same row.
    safe_diagonals(Solution),   % 2. Rule: No two queens can be on the same diagonal.
    
    % FINDING THE SOLUTION
    labeling([ff], Solution).  % 'ff' (First-Fail): Picks the queen with the fewest possible options left and sets her first.
% Rules for Diagonals
safe_diagonals(Solution) :-
    length(Solution, N),
    %creates list for the colums [1, 2, 3, ..., N]
    numlist(1, N, Columns),  

    % Calculates a unique ID for every diagonal (with the functions sum_index and diff_index).
    % maplist goes through the lists and stores the results in AscendingDiagonals and DescendingDiagonals.
    maplist(sum_index, Solution, Columns, AscendingDiagonals), %Sum from Solution and Columns is stored in AscendingDiagonals
    maplist(diff_index, Solution, Columns, DescendingDiagonals),
    
    % Rule: all Diagonals must be unique
    all_different(AscendingDiagonals),
    all_different(DescendingDiagonals).

% Helper functions for the math
% #= is the CLP version of 'is' or '=' (defines a mathematical rule)
sum_index(Row, Col, Sum)   :- Sum  #= Row + Col.  
diff_index(Row, Col, Diff) :- Diff #= Row - Col.  