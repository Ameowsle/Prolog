% Problem: Partially pre-filled quasigroup with size m. 
partially_quasigroup([
        [1, _, _, 4],
        [_, _, 2, _],
        [3, _, _, _],
        [_, 3, _, _]
    ]).

quasigroup(Solution):-
    partially_quasigroup(Solution), % stores partially pre-filled quasigroup in Solution
    row_all_diff(Solution),
    transpose(Solution, Transposed),
    row_all_diff(Transposed).

row_all_diff([]).
row_all_diff([First | Rest]):-
    all_diff(First),
    row_all_diff(Rest). % all elements in a row must be distinct


% Rule 1: Rows are empty
transpose([[]|_], []).
% Rule 2: Rows have at least one element [H|T]
transpose([[H|T]|Rows], [FirstCol|Rest]) :-
    maplist(row_head_tail, [[H|T]|Rows], FirstCol, RestMatrix),
    transpose(RestMatrix, Rest).

