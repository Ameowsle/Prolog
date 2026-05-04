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
    partially_quasigroup(Solution),
    length(Solution, M),
    numlist(1, M, Domain),
    maplist(fill_row_dc(Domain, Solution), Solution).


fill_row_dc(Domain, Solution, Row):-
    include(nonvar, Row, Prefilled), % collect prefilled values
    subtract(Domain, Prefilled, Reduced),  % remove prefilled from domain
    assign_cell_dc(Row, Reduced, 1, Solution).

assign_cell_dc([], _Remaining, _Index, _Solution).
assign_cell_dc([Cell|Rest], Remaining, Index, Solution):-
    nonvar(Cell), % cell pre-filled
    NextIndex is Index + 1,
    assign_cell_dc(Rest, Remaining, NextIndex, Solution).

assign_cell_dc([Cell|Rest], Remaining, Index, Solution) :-
    var(Cell),
    maplist(nth1(Index), Solution, Col),      % extract the column for the given index
    include(nonvar, Col, ColUsed),            % collect already filled column values
    subtract(Remaining, ColUsed, Candidates), % candidates = row domain minus column values
    member(Cell, Candidates),                 % cell empty -> assign from restricted domain
    select(Cell, Remaining, NewRemaining),    % update remaining row values
    NextIndex is Index + 1,
    assign_cell_dc(Rest, NewRemaining, NextIndex, Solution).
