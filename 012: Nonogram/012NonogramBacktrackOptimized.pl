% 1 for filled blocks, 0 for gaps
% Given constraints: for each row and column, a list of block lengths is stored. 
row_constraints([[1], [3], [5], [3], [1]]).
col_constraints([[1], [3], [5], [3], [1]]).

% ----------------------------------------------------------------------------
% MAIN SOLVER
% ----------------------------------------------------------------------------

nonogram(Solution):-
    row_constraints(RowCounts),
    col_constraints(ColCounts),
    length(RowCounts, NumRows),
    length(ColCounts, NumCols),
    length(Solution, NumRows), % Create a 2D solution matrix with empty variables
    maplist(flip_length(NumCols), Solution),
    findsol(RowCounts, ColCounts, Solution, []). % Solve row by row, [] = no rows set yet

% Solve row by row: fills one row with check_line, then checks if columns are
% still possible (early backtracking), then proceeds to the next row.
% Base case: no more constraints and no more lines to fill
findsol([], _, [], _).
findsol([RC|RCRest], ColCounts, [FirstLine|RestLines], DoneRows):- 
    check_line(RC, FirstLine),  % set current row via backtracking
    append(DoneRows, [FirstLine], NewDoneRows), % add completed row to done rows
    my_transpose(NewDoneRows, Transposed), % Transpose done rows
    maplist(check_partial_line, ColCounts, Transposed), % checks if columns are still possible -> early backtracking
    findsol(RCRest, ColCounts, RestLines, NewDoneRows). % recurse on remaining rows

% Helper: Check if a partial column is still feasible with current rows
% n% No cells left in partial column -> ok, we add a rows later for the other constraint
check_partial_line(_, []).
% No more constraints but next 0s -> ok
check_partial_line([], [0|Rest]) :-
    check_partial_line([], Rest).
% No more constraints but next a 1 -> impossible -> FAIL
check_partial_line([], [1|_]) :- fail.
% Current cell is 0 -> skip, continue with same constraints
check_partial_line(Bs, [0|Rest]) :-
    check_partial_line(Bs, Rest).
% Current cell is 1 -> consume block B until all 1 are gone
check_partial_line([B|Bs], [1|Rest]) :-
    consume_block(B, [1|Rest], After),
    check_partial_line(Bs, After).

% Consume a block of 1s: verify block length and separator
% Base case: block fully consumed
consume_block(0, Rest, Rest).

% Block not fully consumed but column ends -> ok, more rows will be added later
consume_block(_, [], []).

% Recursive case: consume one 1 from the block
consume_block(B, [1|Rest], After) :-
    B > 0, 
    B1 is B - 1, 
    consume_block(B1, Rest, After).

% Base case: if no constraints left, fill remaining cells with 0
check_line([], Line) :- 
    maplist(=(0), Line).

% Recursive case: check block of length B followed by remaining blocks
check_line([B|Bs], Line) :-
    % Optional leading gap (0 or more cells) filled with 0
    append(Gap, Rest, Line), % Gap +Rest =Line
    maplist(=(0), Gap),
    % Block of exactly B consecutive 1s
    length(Block, B),
    append(Block, After, Rest), % Gap (all 0) + Block (all 1) + After (with leading 0)=Line
    maplist(=(1), Block),
    check_after(Bs, After).  % After the block, check remaining blocks with required separation

% Base case: if no more blocks, fill remaining cells with 0
check_after([], After) :-
    maplist(=(0), After).

% Recursive case: at least one 0 gap required between blocks, then check remaining blocks
check_after(B, [0|After]) :- % After = 0+ After
    check_line(B, After).

% ----------------------------------------------------------------------------
% HELPER FUNCTIONS
% ----------------------------------------------------------------------------

flip_length(Length, List) :- length(List, Length).

% Custom transpose: convert rows to columns without library
% Base case: empty matrix or all rows empty
my_transpose([], []).

% Base case: all rows empty
my_transpose([[]|_], []).

% Recursive case: extract first element from each row and recurse
my_transpose(Rows, [Col|Cols]) :-
    maplist(nth0(0), Rows, Col),
    maplist(rest_of_list, Rows, RestRows), 
    my_transpose(RestRows, Cols).

% Helper: extract first element of a list
rest_of_list([_|T], T).