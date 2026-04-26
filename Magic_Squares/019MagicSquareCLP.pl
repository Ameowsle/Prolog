:- use_module(library(clpfd)).

magic_square(N, Square) :-
    %  Matrix (Square)
    length(Square, N), % Square has the length of N
    maplist(length_(N), Square), % each row is a list of N variables

    % STEP 2: Collect all cells, set domain and uniqueness
    append(Square, Vars),% creates a list from the matrix
    Max is N * N, % calculate highest value
    Vars ins 1..Max,% every cell must be between 1 and Max (n squared)
    all_distinct(Vars),% every value must appear exactly once

    %Compute magic sum 
    Sum is N * (N * N + 1) // 2, 

    % Enforce row sums
    maplist(row_sum(Sum), Square), % each row must add up to Sum: maplist calls row_sum for every row in Square

    % Enforce column sums
    transpose(Square, Columns), %first transpose the matrix
    maplist(row_sum(Sum), Columns), % now check column sums like row sums

    % Enforce main diagonal sums
    Last is N - 1,
    numlist(0, Last, Indices),% creates a list [0,1,2,...,N-1]
    maplist(diag1_cell(Square), Indices, Diag1),  % Calls diag1_cell for every Index and stores them in Diag1
    row_sum(Sum, Diag1), % diagonal must add up to Sum

    % Enforce anti-diagonal 
    maplist(diag2_cell(Square, N), Indices, Diag2), % calls diag2_cell for every index in didices and stores them in diag2
    row_sum(Sum, Diag2), % diagonal must add up to Sum

    %Search for concrete values satisfying all constraints and stores them in Vars
    label(Vars).% assign actual numbers to all variables

%----------------
%HELPERFUNCTIONS
% Swap the parameters for the maplist function. 
length_(N, List) :- length(List, N).

% Enforce that a list sums to Sum
row_sum(Sum, Row) :- sum(Row, #=, Sum).

% gets cells with index (I,I)
% nth0 gives us the element at position I
diag1_cell(Square, I, Cell) :-
    nth0(I, Square, Row), % get row number I
    nth0(I, Row, Cell). % get element number I from that row

% Get cell (I, N-1-I) for anti-diagonal
diag2_cell(Square, N, I, Cell) :-
    nth0(I, Square, Row), % get row number I
    J is N - 1 - I,  % column index 
    nth0(J, Row, Cell). % get element number J from that row