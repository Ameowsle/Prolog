:- use_module(library(clpfd)).

% THE PUZZLE: Unknown cells are represented as anonymous variables (_).
puzzle([
    [_, _, _, _, _, _, _, _, _],
    [_, _, _, _, _, _, _, _, _],
    [_, _, _, _, _, _, _, _, _],
    [_, _, _, _, _, _, _, _, _],
    [_, _, _, _, _, _, _, _, _],
    [_, _, _, _, _, _, _, _, _],
    [_, _, _, _, _, _, _, _, _],
    [_, _, _, _, _, _, _, _, _],
    [_, _, _, _, _, _, _, _, _]
]).

cages([
    % Zeile 1-2
    cage(3,  [pos(1,1), pos(1,2)]),                          % gelb, oben links
    cage(15, [pos(1,3), pos(2,3), pos(3,3)]),                % grün
    cage(22, [pos(1,6), pos(2,6)]),                          % grün
    cage(4,  [pos(1,7), pos(1,8)]),                          % blau
    cage(16, [pos(1,8), pos(1,9)]),                          % gelb
    cage(15, [pos(1,9), pos(2,9), pos(3,9)]),                % grün
    cage(25, [pos(2,1), pos(3,1), pos(4,1)]),                % blau
    cage(17, [pos(2,3), pos(2,4), pos(2,5)]),                % pink
    cage(9,  [pos(3,3), pos(3,4)]),                          % gelb
    cage(8,  [pos(3,6), pos(3,7)]),                          % grün
    cage(20, [pos(3,7), pos(3,8)]),                          % blau
    cage(6,  [pos(4,1), pos(5,1)]),                          % gelb
    cage(14, [pos(4,2), pos(5,2), pos(5,3)]),                % pink
    cage(17, [pos(4,5), pos(4,6), pos(5,6)]),                % grün
    cage(17, [pos(4,8), pos(4,9), pos(5,9)]),                % pink
    cage(13, [pos(5,2), pos(5,3)]),                          % grün
    cage(20, [pos(5,4), pos(5,5), pos(6,5)]),                % pink
    cage(12, [pos(5,9), pos(6,9)]),                          % gelb
    cage(27, [pos(6,1), pos(7,1), pos(8,1)]),                % blau
    cage(6,  [pos(6,3), pos(6,4)]),                          % grün
    cage(20, [pos(6,6), pos(7,6), pos(7,5)]),                % grün
    cage(6,  [pos(6,7), pos(7,7)]),                          % blau
    cage(10, [pos(7,5), pos(7,4), pos(7,3)]),                % blau
    cage(14, [pos(7,8), pos(7,9)]),                          % grün
    cage(8,  [pos(8,2), pos(8,3)]),                          % gelb
    cage(16, [pos(8,3), pos(8,4)]),                          % grün
    cage(15, [pos(8,6), pos(8,7)]),                          % pink
    cage(13, [pos(9,5), pos(9,6)]),                          % blau
    cage(17, [pos(9,8), pos(9,9)])                           % pink
]).

sudoku(Solution):-
    % copy the predefined puzzel into Solution  
    puzzle(Solution),
    % flatten the matrix into a single list and restrict every cell (every element in Vars) to 1–9.
    append(Solution, Vars), % Vars=[_,6,4,8,_,...,_,1]
    Vars ins 1..9,
    % Apply row, column, and 3×3 block constraints.
    rows_all_diff(Solution), % all elements in a row must be distinct
    cols_all_diff(Solution), % all elements in a col must be distinct
    blocks_all_diff(Solution), % all 3x3 blocks must be distinct
    %copy the predefinded cages into CageList
    cages(CageList),
    cages_all_diff_AND_add_up(CageList, Solution),
    % CLP searchs concrete values to all remaining Vars.
    label(Vars).

cages_all_diff_AND_add_up([],_).
cages_all_diff_AND_add_up([cage(Sum, Pos)| Rest], Solution):-
    maplist(pos_to_list(Solution), Pos, AsList), %Translates Positions in a List: iterates over Positions list
    all_different(AsList),
    sum(AsList, #=, Sum),
    cages_all_diff_AND_add_up(Rest, Solution).

pos_to_list(pos(R,C), Matrix, AsNum):-
    nth1(R, Matrix, Row),
    nth1(C, Row, AsNum).


rows_all_diff([]).
rows_all_diff([FirstRow| Rest]):-
    all_different(FirstRow),
    rows_all_diff(Rest).

cols_all_diff(Solution):-
    transpose(Solution, Transposed),
    rows_all_diff(Transposed).

blocks([], [], []).
blocks([V1,V2,V3|Rest1], [V4,V5,V6|Rest2], [V7,V8,V9|Rest3]) :-
    all_distinct([V1,V2,V3,V4,V5,V6,V7,V8,V9]),
    blocks(Rest1, Rest2, Rest3).

blocks_all_diff([]).
blocks_all_diff([R1, R2, R3 | Rest]):-
    blocks(R1, R2, R3 ),
    blocks_all_diff(Rest).
