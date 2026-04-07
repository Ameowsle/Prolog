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
    cage(3,  [pos(1,1), pos(1,2)]),
    cage(15, [pos(1,3), pos(2,3), pos(3,3)]),
    cage(22, [pos(1,6), pos(2,6)])
]).

sudoku(Solution):-
    % copy the predefined puzzel into Solution  
    puzzle(Solution),
    length(Solution, Length),
    % flatten the matrix into a single list and restrict every cell (every element in Vars) to 1–9.
    append(Solution, Vars), % Vars=[_,6,4,8,_,...,_,1]

    Vars ins 1..Length,
    % Apply row, column, and 3×3 block constraints.
    rows_all_diff(Solution), % all elements in a row must be distinct
    cols_all_diff(Solution), % all elements in a col must be distinct
    SquareR is round(sqrt(Length)), % round to convert float to int
    takeSQRLines(Solution, SquareR), % all 3x3 blocks must be distinct
    %copy the predefinded cages into CageList
    cages(CageList),
    cages_all_diff_AND_add_up(CageList, Solution),
    % CLP searchs concrete values to all remaining Vars.
    label(Vars).

cages_all_diff_AND_add_up([],_).
cages_all_diff_AND_add_up([cage(Sum, Pos)| Rest], Solution):-
    maplist(pos_to_list(Solution), Pos, AsList), %Translates Positions in a List: iterates over Positions list
    all_distinct(AsList),
    sum(AsList, #=, Sum),
    cages_all_diff_AND_add_up(Rest, Solution).

pos_to_list(Matrix, pos(R,C), AsNum):-
    nth1(R, Matrix, Row),
    nth1(C, Row, AsNum).


rows_all_diff([]).
rows_all_diff([FirstRow| Rest]):-
    all_distinct(FirstRow),
    rows_all_diff(Rest).

cols_all_diff(Solution):-
    transpose(Solution, Transposed),
    rows_all_diff(Transposed).


take(N, List, PartList, Rest):- 
    length(PartList, N), % Partlist has length N
    append(PartList, Rest, List). % Partlist + Rest = List

% Example: Lines= [[1,2,3,4,5,6,7,8,9], [1,2,3,4,5,6,7,8,9], [1,2,3,4,5,6,7,8,9]], SquareR= 3
% Lines[0] = [1,2,3,4,5,6,7,8,9] -> Block[0] = [1,2,3], Rest[0] = [4,5,6,7,8,9]
% Lines[1] = [1,2,3,4,5,6,7,8,9] -> Block[1] = [1,2,3], Rest[1] = [4,5,6,7,8,9]
% Lines[2] = [1,2,3,4,5,6,7,8,9] -> Block[2] = [1,2,3], Rest[2] = [4,5,6,7,8,9]
% -> Blocks     = [[1,2,3], [1,2,3], [1,2,3]]
% -> RestLines  = [[4,5,6,7,8,9], [4,5,6,7,8,9], [4,5,6,7,8,9]]
buildBlocks([[]|_], _).
buildBlocks(Lines, SquareR):-
    maplist(take(SquareR), Lines, Blocks, RestLines), % takes first SquareR-Elements of every list in Lines and stores them in Blocks. 
    append(Blocks, FlatBlock), 
    all_distinct(FlatBlock),
    buildBlocks(RestLines, SquareR).


takeSQRLines([], _).
takeSQRLines(Matrix, SquareR):-
    take(SquareR, Matrix, Lines, Rest), 
    buildBlocks(Lines, SquareR),
    takeSQRLines(Rest, SquareR).

