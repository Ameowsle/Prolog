:- use_module(library(clpfd)).

% Golomb Ruler (CSPLib prob006)
% Find N marks on a ruler where all pairwise differences are distinct.
% First mark is always 0, marks are strictly increasing.

golomb(Marks) :- % entry point: user provides a list, N is inferred from its length
    length(Marks, N),
    golomb(N, Marks).

golomb(N, Marks) :-
    length(Marks, N), % create a list of N variables, one per mark
    Max is N * N,
    Marks ins 0..Max, % each mark must be within 0..N^2 (loose upper bound)
    Marks = [0|_], % CONSTRAINT: fix the first mark at 0
    chain(Marks, #<), % marks must be strictly increasing left to right
    pairwise_diffs(Marks, Diffs), % collect all pairwise distances between marks
    all_distinct(Diffs), % CONSTRAINT (Golomb property): all distances must be unique
    label(Marks). 

pairwise_diffs([], []). 
pairwise_diffs([_], []). % one mark, no differences
pairwise_diffs([A|Rest], Diffs) :-
    maplist(diff_from(A), Rest, ADiffs), % distances from A to every mark to its right
    pairwise_diffs(Rest, RestDiffs),
    append(ADiffs, RestDiffs, Diffs).   % combine both sets into one flat list

diff_from(A, B, D) :-
    D #= B - A.                          % D is the distance from A to B (always positive)
