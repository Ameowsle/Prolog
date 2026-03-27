% 1 for occupied, 0 for gap
% build matrix 
:- use_module(library(clpfd)).

%given constraints: for the row and and col the list of constraints is stored in a list. 
%row_constraints([[1,1], [3,3], [3,3], [1,1], [3,4], [3,4], [1,1], [10], [9], [7]]).
%col_constraints([[1], [2,2], [2,2,3], [10], [2,3], [2,3], [2,2,3], [10], [2,2,3], [2]]).
row_constraints([[1], [3], [5], [3], [1]]).
col_constraints([[1], [3], [5], [3], [1]]).

nanogram(Solution):-
    row_constraints(RowCounts),
    col_constraints(ColCounts),
    length(RowCounts, NumRows),
    length(ColCounts, NumCols),
    
    length(Solution, NumRows), %Solution = [_, _, _, _, _, _, _, ..]
    maplist(flip_length(NumCols), Solution), %flip_length(Länge, Liste) :- length(Liste, Länge).
    
    append(Solution, Vars), % 1D list
    Vars ins 0..1 ,
    label(Vars), %generates all possible 0/1 combinations
    findsol(RowCounts, ColCounts, Solution),
    !. %Stops after finding the first solution
    

findsol(RowCounts, ColCounts,Solution):- 
    apply_constraints(RowCounts, Solution),
    transpose(Solution, Transposed), %transposes the matrix
    apply_constraints(ColCounts, Transposed).

flip_length(Length, List) :- length(List, Length).


apply_constraints([], _).
apply_constraints([FirstC|RestC], [FirstL|RestL]):-
    check_line(FirstC, FirstL),
    apply_constraints(RestC, RestL).

%Basecase: if no constraints left, the line is filled with 0
check_line([], Line) :- maplist(=(0), Line).

%Block has length B
check_line([B|Bs], Line) :-
    % 1) Führender Gap (kann leer sein) → alles 0
    append(Gap, Rest, Line), % cuts Line in pieces Gap + Rest = Line
    maplist(=(0), Gap), %fills list Gap with 0

    % 2) Block with lenth B --> all 1
    length(Block, B),
    append(Block, After, Rest), % Block +After =Rest
    %Gap (all 0) + (Block(all 1) + After(min one 0))= Line
    maplist(=(1), Block),

    % 3) If last Block (no other constraint)= 0; If not: min. one 0, than recursion (calls with next constraint)
    check_after(Bs, After). 

% If last block (no other constraint)
check_after([], After) :-
    maplist(=(0), After).

% Oter constraints: sets 0 and calls checkline with next B
check_after(B, [0|After]) :- %After= 0 + After (sets a 0 between the blocks)
    check_line(B, After).

