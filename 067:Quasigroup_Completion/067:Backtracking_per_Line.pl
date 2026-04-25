% Problem: Partially pre-filled quasigroup with size m. 
partially_quasigroup([
    [1, _, _, 4, _, _, _],
    [_, 3, _, _, _, 7, _],
    [_, _, 5, _, _, _, 2],
    [4, _, _, 7, _, _, _],
    [_, 6, _, _, 2, _, _],
    [_, _, 1, _, _, 4, _],
    [7, _, _, 3, _, _, 6]
]).

quasigroup(Solution):-
    partially_quasigroup(Solution), % stores partially pre-filled quasigroup in Solution
    length(Solution, M),
    numlist(1, M, Domain),
    maplist(assign_and_check_row(Domain, Solution), Solution).  % assigns values from Domain to each row and checks constraints

check_col_partial(Solution, Index):-
    maplist(nth1(Index), Solution, Col), % extract the column for the given index 
    all_diff(Col). % Check (incomplete) columns after completing a new row

assign_and_check_row(Domain, Solution, Row) :-
    maplist(assign_cell(Domain), Row),  % assign num from domain for every row
    all_diff(Row), % check row immediately
    maplist(check_col_partial(Solution), Domain). % Check all columns by calling check_col_partial for every index

assign_cell(Domain, Cell) :- nonvar(Cell). % cell pre-filled
assign_cell(Domain, Cell) :- member(Cell, Domain).  % cell empty -> assign a member from domain          

all_diff(List) :-
    include(nonvar, List, OnlyNums), % only keep filled cells
    sort(OnlyNums, Sorted),
    length(OnlyNums, N),
    length(Sorted, N). %if no duplicates, then the length of sorted list is N