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
% Solve in place (Solution = Puzzle): fill a whole row from the domain, then
% check the row and all columns. Column conflicts are only seen once the row is
% complete, so this backtracks at the row level (slow, kept as a baseline).
quasigroup(Puzzle, Solution):-
    Solution = Puzzle,
    length(Solution, M),
    numlist(1, M, Domain),
    maplist(assign_and_check_row(Domain, Solution), Solution).

% assign_and_check_row(+Domain, +Solution, +Row)
% Assign every empty cell of Row from Domain, then verify the row and every
% column. Domain (1..M) doubles as the list of column indices for the check.
assign_and_check_row(Domain, Solution, Row) :-
    maplist(assign_cell(Domain), Row),  % assign a value from the domain to every empty cell
    all_diff(Row), % check the completed row immediately
    maplist(check_col_partial(Solution), Domain). % check every column index for duplicates

% assign_cell(+Domain, ?Cell)
% Leave a pre-filled cell untouched, otherwise pick a value from the domain.
assign_cell(_Domain, Cell) :- nonvar(Cell). % cell pre-filled
assign_cell(Domain, Cell) :- member(Cell, Domain). % cell empty -> assign a member from domain

% check_col_partial(+Solution, +Index)
% Check that column Index has no duplicate among its filled cells.
check_col_partial(Solution, Index):-
    maplist(nth1(Index), Solution, Col), % extract the column for the given index
    all_diff(Col).

% all_diff(+List)
% True if the filled cells of List contain no duplicate (ignores unbound cells).
all_diff(List) :-
    include(nonvar, List, OnlyNums), % only keep filled cells
    sort(OnlyNums, Sorted),
    length(OnlyNums, N),
    length(Sorted, N). % if no duplicates, the sorted set has the same length
