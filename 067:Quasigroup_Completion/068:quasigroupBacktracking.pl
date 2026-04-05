% Problem: Partially pre-filled quasigroup with size m. 
partially_quasigroup([
        [1, _, _, 4],
        [_, _, 2, _],
        [3, _, _, _],
        [_, 3, _, _]
    ]).

quasigroup(Solution):-
    partially_quasigroup(Solution), % stores partially pre-filled quasigroup in Solution
    length(Solution, M),
    numlist(1, M, Domain),
    maplist(assign_and_check_row(Domain), Solution),  % Check line by line 
    numlist(1, M, Indices),
    maplist(check_col(Solution), Indices).

check_col(Solution, Index):-
    maplist(nth1(Index), Solution, Col),
    all_diff(Col).

assign_and_check_row(Domain, Row) :-
    maplist(assign_cell(Domain), Row),  % assign num from domain for every row
    all_diff(Row). %check row immediately

assign_cell(_, Cell) :- nonvar(Cell).  
assign_cell(Domain, Cell) :- 
    member(Cell, Domain).              

all_diff(List) :-
    sort(List, Sorted),
    length(List, N),
    length(Sorted, N).
