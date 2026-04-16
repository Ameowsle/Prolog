% Problem: Partially pre-filled quasigroup with size m. 
partially_quasigroup([
    [1, _, _, _, 5],
    [_, 2, _, _, _],
    [_, _, 3, _, _],
    [_, _, _, 4, _],
    [5, 3, 4, 2, 1]
]).
quasigroup(Solution):-
    partially_quasigroup(Solution), % stores partially pre-filled quasigroup in Solution
    length(Solution, M),
    numlist(1, M, Domain),
    maplist(fill_row(Domain, Solution), Solution).


fill_row(Domain, Solution, Row):-
    include(nonvar, Row, Prefilled), % collect prefilled values
    subtract(Domain, Prefilled, Reduced),  % remove prefilled from domain
    assign_cell(Row, Reduced, 1, Solution).

assign_cell([], _Remaining, _Index, _Solution).
assign_cell([Cell|Rest], Remaining, Index, Solution):-
    nonvar(Cell), % cell pre-filled
    NextIndex is Index + 1,
    assign_cell(Rest, Remaining, NextIndex, Solution).

assign_cell([Cell|Rest], Remaining, Index, Solution) :- 
    var(Cell),
    select(Cell, Remaining, NewRemaining), % cell empty -> assign a member from domain 
    check_col_partial(Solution, Index),
    NextIndex is Index + 1,
    assign_cell(Rest, NewRemaining, NextIndex, Solution).


all_diff(List) :-
    include(nonvar, List, OnlyNums), % only keep filled cells
    sort(OnlyNums, Sorted),
    length(OnlyNums, N),
    length(Sorted, N). %if no duplicates, then the length of sorted list is N

check_col_partial(Solution, Index):-
    maplist(nth1(Index), Solution, Col), % extract the column for the given index 
    all_diff(Col). % Check (incomplete) columns after completing a new row
    
