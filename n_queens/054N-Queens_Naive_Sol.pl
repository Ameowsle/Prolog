n_queens(N, Solution) :- 
    numlist(1, N, AllRows), 
    numlist(1, N, AllCols),
    % 1. Generate a full permutation of rows 
    permutation(AllRows, Solution), 
    % 2. Check for every permution if it could be a solution 
    check_board(AllCols, Solution).

% Base case for checking the board
check_board([], []). 
check_board([Col|RestCols], [Row|RestRows]) :- 
    check_against_rest(Col, Row, RestCols, RestRows),
    check_board(RestCols, RestRows).

% Compare one queen against all subsequent queens
check_against_rest(_, _, [], []).
check_against_rest(C1, R1, [C2|RestCols], [R2|RestRows]) :- 
    diagonal_desc(C1, R1, C2, R2), 
    diagonal_asc(C1, R1, C2, R2), 
    check_against_rest(C1, R1, RestCols, RestRows). 

% Diagonal check functions
diagonal_desc(C1, R1, C2, R2) :- C1 - R1 =\= C2 - R2.
diagonal_asc(C1, R1, C2, R2) :- C1 + R1 =\= C2 + R2.