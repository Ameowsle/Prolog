% APPROACH: Backtracking left-to-right with domain restriction PER CELL.
% Before assigning a value, candidates are computed by removing already-used
% values in the same row, column, and 3x3 block.

puzzle([[_, 6, 4, 8, _, _, 3, _, 7],
        [_, 5, 8, 2, 3, _, _, 6, _],
        [_, _, _, _, _, 4, _, _, _],
        [2, _, _, _, _, 1, _, _, _],
        [_, _, _, _, 8, _, _, _, _],
        [_, _, _, _, _, 5, 9, _, 6],
        [_, _, 3, 6, _, _, 7, _, 5],
        [_, _, _, _, _, _, _, 9, 2],
        [_, 7, _, _, _, _, _, _, 1]]).

sudoku(Solution) :-
    puzzle(Solution),
    fill_grid(Solution, Solution, 1).

fill_grid([], _, _).
fill_grid([Row|RestRows], Solution, RowIdx) :-
    fill_row(Row, RowIdx, 1, Solution),
    NextRow is RowIdx + 1,
    fill_grid(RestRows, Solution, NextRow).

fill_row([], _, _, _).
fill_row([Cell|Rest], RowIdx, ColIdx, Solution) :-
    nonvar(Cell),
    NextCol is ColIdx + 1,
    fill_row(Rest, RowIdx, NextCol, Solution).

fill_row([Cell|Rest], RowIdx, ColIdx, Solution) :-
    var(Cell),
    candidates(RowIdx, ColIdx, Solution, Cands),
    member(Cell, Cands),
    NextCol is ColIdx + 1,
    fill_row(Rest, RowIdx, NextCol, Solution).

% Candidates = [1..9] minus values used in same row, column, and block 
candidates(RowIdx, ColIdx, Solution, Cands) :-
    nth1(RowIdx, Solution, Row),
    include(nonvar, Row, RowUsed),
    maplist(nth1(ColIdx), Solution, Col),
    include(nonvar, Col, ColUsed),
    block_values(RowIdx, ColIdx, Solution, BlockUsed),
    numlist(1, 9, All),
    subtract(All, RowUsed, After1),
    subtract(After1, ColUsed, After2),
    subtract(After2, BlockUsed, Cands).

block_values(RowIdx, ColIdx, Solution, Values) :-
    BlockRow is ((RowIdx - 1) // 3) * 3 + 1,
    BlockCol is ((ColIdx - 1) // 3) * 3 + 1,
    R2 is BlockRow + 1, R3 is BlockRow + 2,
    C2 is BlockCol + 1, C3 is BlockCol + 2,
    nth1(BlockRow, Solution, Row1),
    nth1(R2, Solution, Row2),
    nth1(R3, Solution, Row3),
    nth1(BlockCol, Row1, V1), nth1(C2, Row1, V2), nth1(C3, Row1, V3),
    nth1(BlockCol, Row2, V4), nth1(C2, Row2, V5), nth1(C3, Row2, V6),
    nth1(BlockCol, Row3, V7), nth1(C2, Row3, V8), nth1(C3, Row3, V9),
    include(nonvar, [V1,V2,V3,V4,V5,V6,V7,V8,V9], Values).