% All-Interval Series (CSPLib prob007)
% Find a permutation S of {0..N-1} such that the consecutive absolute
% differences also form a permutation of {1..N-1}.

all_interval(N, S) :-
    length(S, N),
    N1 is N - 1,
    numlist(0, N1, Domain),
    build(S, Domain, [], none).

build([], _, _, _).
build([H|T], Avail, Used, none) :-
    select(H, Avail, Rest),
    build(T, Rest, Used, H).
build([H|T], Avail, Used, Prev) :-
    Prev \= none,
    select(H, Avail, Rest),
    D is abs(H - Prev),
    \+ member(D, Used),
    build(T, Rest, [D|Used], H).
