:- use_module(library(clpfd)).

% Problem: Partially pre-filled quasigroup with size m. 
partially_quasigroup([
        [1, _, _, 4],
        [_, _, 2, _],
        [3, _, _, _],
        [_, 3, _, _]
    ]).

quasigroup(Solution):-
    partially_quasigroup(Solution),
    
    length(Solution, M),
    append(Solution, Vars), % flatten the matrix into a single list and restrict every cell (every element in Vars) to 1–m.
    Vars ins 1..M,

    maplist(all_distinct, Solution), % all elements in a row must be distinct
    transpose(Solution, Transposed),
    maplist(all_distinct, Transposed), % all elements in a col must be distinct

    label(Vars).