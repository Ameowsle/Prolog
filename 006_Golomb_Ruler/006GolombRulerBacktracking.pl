% Golomb Ruler (CSPLib prob006)
% Find N marks on a ruler where all pairwise differences are distinct.
% First mark is always 0, marks are strictly increasing.

% golomb(+N, -Marks)
golomb(N, Marks) :-
    Max is N * N, % loose upper bound on ruler length
    N1 is N - 1, % still need N-1 more marks after the fixed 0
    build([0], N1, Max, [], Marks). % start building from [0], no differences used yet


% Acc: marks placed so far, stored in reverse order
% Remaining: how many marks still need to be placed
% Max: upper bound on mark values (N^2)
% UsedDiffs: all distances already used, no new mark may repeat one
% Marks: the final result, only bound in the base case

% build(+Acc, +Remaining, +Max, +UsedDiffs, -Marks)
%basecase: Remaining=0 (all marks are set)
build(Acc, 0, _, _, Marks) :-
    reverse(Acc, Marks). % Acc was built in reverse order, flip it
build([Last|Acc], Rem, Max, Used, Marks) :-
    Succ is Last + 1, % next mark must be strictly greater than Last
    between(Succ, Max, M), % generate candidate M in range [Last+1, Max]
    mark_diffs(M, [Last|Acc], NewDiffs), % compute distances from M to all existing marks
    \+ (member(D, NewDiffs), member(D, Used)), % reject M if any distance is part of NewDiff and UsedDiffs
    append(NewDiffs, Used, Used1),
    Rem1 is Rem - 1, % one fewer mark to place
    build([M, Last|Acc], Rem1, Max, Used1, Marks).

% mark_diffs(+NewMark, +ExistingMarks, -Diffs)
mark_diffs(_, [], []). % no existing marks, no differences
mark_diffs(NewMark, [H|T], [D1|Diffs]) :-
    D1 is NewMark - H, % distance from existing mark H to new mark M
    mark_diffs(NewMark, T, Diffs). % recurse over remaining marks
