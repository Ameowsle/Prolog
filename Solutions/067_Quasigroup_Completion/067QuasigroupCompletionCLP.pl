:- use_module(library(clpfd)).

% Example instance: a partially pre-filled 7x7 quasigroup. Filled cells hold a
% value in 1..M, empty cells are unbound variables. This is only example data;
% the solver takes the puzzle as an argument (see quasigroup/2), so the same
% relation solves any instance, not just this one.
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
% Puzzle is an MxM board (list of M rows). Filled cells hold a value in 1..M,
% empty cells are unbound. Solution is the same board with every cell bound so
% that each row and each column is a permutation of 1..M. We solve in place
% (Solution = Puzzle): the pre-filled cells already pin their values and the
% clpfd constraints below fill in the rest.
quasigroup(Puzzle, Solution):-
    Solution = Puzzle,
    length(Solution, M),
    append(Solution, Vars), % flatten the matrix into one list, restrict every cell to 1..M
    Vars ins 1..M,
    maplist(all_distinct, Solution),    % all elements in a row must be distinct
    transpose(Solution, Transposed),
    maplist(all_distinct, Transposed),  % all elements in a column must be distinct
    label(Vars).
