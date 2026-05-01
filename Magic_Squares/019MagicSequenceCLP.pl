:- use_module(library(clpfd)).

% A magic sequence of length N is a sequence [X0, X1, ..., X(N-1)] where
% Xi equals the number of times i appears in the sequence.
% Example (N=10): [6,2,1,0,0,0,1,0,0,0]

magic_sequence(N, Seq) :-
    length(Seq, N), 
    Seq ins 0..N,  
    N1 is N - 1,
    numlist(0, N1, Indices), % Indices = [0, 1, 2, ..., N-1]
    build_pairs(Indices, Seq, Pairs), % build pairs [0-X0, 1-X1, ..., (N-1)-X(N-1)] for global_cardinality
    % core constraint: value i occurs exactly Xi times in Seq (self-referential,
    % since Xi is both a variable in the sequence and its own count)
    global_cardinality(Seq, Pairs),
    label(Seq). 


% zips indices and sequence variables into key-value pairs:
% build_pairs([0,1,2], [X0,X1,X2], [0-X0, 1-X1, 2-X2])
build_pairs([], [], []).
build_pairs([I|Is], [X|Xs], [I-X|Ps]) :-
    build_pairs(Is, Xs, Ps).
