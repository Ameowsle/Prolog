% 1 for filled blocks, 0 for gaps
% Given constraints: for each row and column, a list of block lengths is stored. 
row_constraints([[1], [3], [5], [3], [1]]).
col_constraints([[1], [3], [5], [3], [1]]).


nonogram(Solution):-
    row_constraints(RowCounts),
    col_constraints(ColCounts),
    length(RowCounts, NumRows),
    length(ColCounts, NumCols),
    % Create a 2D solution matrix with empty variables
    length(Solution, NumRows),
    maplist(flip_length(NumCols), Solution),
    % Test if combination satisfies all constraints
    findsol(RowCounts, ColCounts, Solution).
    

findsol(RowCounts, ColCounts, Solution):- 
    % Check if all rows satisfy their constraints
    apply_constraints(RowCounts, Solution),
    % Transpose matrix to check columns as rows
    my_transpose(Solution, Transposed),
    % Check if all columns (now rows) satisfy their constraints
    apply_constraints(ColCounts, Transposed).

flip_length(Length, List) :- length(List, Length).

% Custom transpose: convert rows to columns without library
% Base case: empty matrix or all rows empty
my_transpose([], []).
my_transpose([[]|_], []).

% Recursive case: extract first element from each row and recurse
my_transpose(Rows, [Col|Cols]) :-
    maplist(nth0(0), Rows, Col),
    maplist(rest_of_list, Rows, RestRows), 
    my_transpose(RestRows, Cols).

% extract first element of a list
rest_of_list([_|T], T).

% Base case: no constraints left
apply_constraints([], _).
% Recursive case: check each constraint against corresponding line
apply_constraints([FirstC|RestC], [FirstL|RestL]):-
    check_line(FirstC, FirstL),
    apply_constraints(RestC, RestL).

%Basecase: if no constraints left, the line is filled with 0
check_line([], Line) :- maplist(=(0), Line).

% Recursive case: check block of length B followed by remaining blocks
check_line([B|Bs], Line) :-
    % Optional leading gap (0 or more cells) filled with 0
    append(Gap, Rest, Line), % Gap +Rest =Line
    maplist(=(0), Gap),
    % Block of exactly B consecutive 1s
    length(Block, B),
    append(Block, After, Rest), % Gap (all 0) + Block (all 1) + After (with leading 0)=Line
    maplist(=(1), Block),
    % After the block, check remaining blocks with required separation
    check_after(Bs, After). 

% Base case: if no more blocks, fill remaining cells with 0
check_after([], After) :-
    maplist(=(0), After).

% Recursive case: at least one 0 gap required between blocks, then check remaining blocks
check_after(B, [0|After]) :- % After = 0+ After
    check_line(B, After).

