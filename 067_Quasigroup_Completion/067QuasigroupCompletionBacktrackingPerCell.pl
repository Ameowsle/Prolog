% Example instance: a partially pre-filled 7x7 quasigroup. Filled cells hold a
% value in 1..M, empty cells are unbound. This is only example data; the solver
% takes the puzzle as an argument (see quasigroup/2), so the same relation
% solves any instance.
partially_quasigroup([
    [1, _, _, 4, _, _, _],
    [_, 3, _, _, _, 7, _],
    [_, _, 5, _, _, _, 2],
    [4, _, _, 7, _, _, _],
    [_, 6, _, _, 2, _, _],
    [_, _, 1, _, _, 4, _],
    [7, _, _, 3, _, _, 6]
]).

% quasigroup(+Puzzle, -Solution)
% Solve in place (Solution = Puzzle): fill the empty cells of each row one cell
% at a time, checking the affected column after every placement so a conflict is
% caught as early as possible.
quasigroup(Puzzle, Solution):-
    Solution = Puzzle,
    length(Solution, M),
    numlist(1, M, Domain),
    maplist(fill_row(Domain, Solution), Solution).

% fill_row(+Domain, +Solution, +Row)
% Reduce the full Domain by the values already pre-filled in Row, then assign
% the empty cells of Row from what remains. Solution is the whole board, needed
% so assign_cell/4 can check columns.
fill_row(Domain, Solution, Row):-
    include(nonvar, Row, Prefilled), % collect prefilled values
    subtract(Domain, Prefilled, Reduced),  % remove prefilled from domain
    assign_cell(Row, Reduced, 1, Solution).

% assign_cell(+Row, +Remaining, +Index, +Solution)
% Walk the row left to right. Index is the 1-based column of the current cell.
% Remaining is the set of row values not yet placed.
assign_cell([], _Remaining, _Index, _Solution).
assign_cell([Cell|Rest], Remaining, Index, Solution):-
    nonvar(Cell), % cell pre-filled, skip it (its value is not in Remaining)
    NextIndex is Index + 1,
    assign_cell(Rest, Remaining, NextIndex, Solution).
assign_cell([Cell|Rest], Remaining, Index, Solution) :-
    var(Cell),
    select(Cell, Remaining, NewRemaining), % cell empty -> pick a value from the row domain
    check_col_partial(Solution, Index),    % reject immediately if it clashes in its column
    NextIndex is Index + 1,
    assign_cell(Rest, NewRemaining, NextIndex, Solution).

% all_diff(+List)
% True if the filled cells of List contain no duplicate (ignores unbound cells).
all_diff(List) :-
    include(nonvar, List, OnlyNums), % only keep filled cells
    sort(OnlyNums, Sorted),
    length(OnlyNums, N),
    length(Sorted, N). % if no duplicates, the sorted set has the same length

% check_col_partial(+Solution, +Index)
% Check that column Index has no duplicate among its filled cells.
check_col_partial(Solution, Index):-
    maplist(nth1(Index), Solution, Col), % extract the column for the given index
    all_diff(Col).
