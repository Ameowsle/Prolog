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
    maplist(assign_and_check_row(Domain), Solution),  % Zeile für Zeile prüfen
    numlist(1, M, Indices),
    maplist(check_col(Solution), Indices).

check_col(Solution, Index):-
    maplist(nth1(Index), Solution, Col),
    all_diff(Col).

assign_and_check_row(Domain, Row) :-
    maplist(assign_cell(Domain), Row),  % Zelle für Zelle belegen
    all_diff(Row).                      % Zeile sofort prüfen

assign_cell(_, Cell) :- nonvar(Cell).  % bereits fixiert
assign_cell(Domain, Cell) :- 
    member(Cell, Domain).              % offen: Wert aus Domain wählen

all_diff(List) :-
    sort(List, Sorted),
    length(List, N),
    length(Sorted, N).
