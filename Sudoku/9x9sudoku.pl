:- use_module(library(clpfd)).

% THE PUZZLE: Unknown cells are represented as anonymous variables (_).
puzzle([[_, 6, 4, 8, _, _, 3, _, 7],
         [_, 5, 8, 2, 3, _, _, 6, _], 
         [_, _, _, _, _, 4, _, _, _],
         [2, _, _, _, _, 1, _, _, _],
         [_, _, _, _, 8, _, _, _, _],
         [_, _, _, _, _, 5, 9, _, 6],
         [_, _, 3, 6, _, _, 7, _, 5],
         [_, _, _, _, _, _, _, 9, 2],
         [_, 7, _, _, _, _, _, _, 1]]).

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
    % CLP searchs concrete values to all remaining Vars.
    label(Vars).

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


