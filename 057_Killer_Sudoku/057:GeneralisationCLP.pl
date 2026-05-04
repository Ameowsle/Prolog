:- use_module(library(clpfd)).

% THE PUZZLE: Unknown cells are represented as anonymous variables (_).
puzzle([
    [2, _, 5, _, _, _, _, _, _],
    [_, 6, _, _, _, _, _, _, _],
    [_, 9, _, _, _, _, _, _, _],
    [_, _, _, 2, _, _, _, _, _],
    [1, _, _, _, _, _, _, _, _],
    [9, 7, _, _, _, _, _, _, _],
    [_, _, _, _, _, _, _, _, _],
    [_, _, _, _, _, _, _, _, _],
    [_, _, _, _, _, _, _, _, _]
]).

cages([
    cage(3,  [pos(1,1), pos(1,2)]),             
    cage(15, [pos(1,3), pos(1,4), pos(1,5)]),
    cage(22, [pos(1,6), pos(2,6), pos(2,5), pos(3,5)]), 
    cage(4,  [pos(1,7), pos(2,7)]),             
    cage(16, [pos(1,8), pos(2,8)]),                        
    cage(15, [pos(1,9), pos(2,9), pos(3,9), pos(4,9)]),   
    cage(25, [pos(2,1), pos(3,1), pos(3,2), pos(2,2)]),  
    cage(17, [pos(2,3), pos(2,4)]),             
    cage(9,  [pos(3,3), pos(3,4), pos(4,4)]),             
    cage(8,  [pos(3,6), pos(4,6), pos(5,6)]),            
    cage(20, [pos(3,8), pos(3,7), pos(4,7)]),   
    cage(6,  [pos(4,1), pos(5,1)]), 
    cage(14, [pos(4,2), pos(4,3)]),
    cage(17, [pos(4,5), pos(5,5), pos(6,5)]),
    cage(17, [pos(5,7), pos(5,8), pos(4,8)]),
    cage(13, [pos(5,2), pos(6,2), pos(5,3)]),
    cage(20, [pos(5,4), pos(6,4), pos(7,4)]), 
    cage(20, [pos(6,6), pos(7,6), pos(7,7)]),
    cage(12, [pos(5,9), pos(6,9)]),   
    cage(27, [pos(6,1), pos(7,1), pos(8,1), pos(9,1)]),  
    cage(6,  [pos(6,3), pos(7,2), pos(7,3)]),             
    cage(6,  [pos(6,7), pos(6,8)]), 
    cage(10, [pos(7,5), pos(8,5), pos(8,4), pos(9,4)]),   
    cage(14, [pos(7,8), pos(7,9), pos(8,8), pos(8,9)]),   
    cage(8,  [pos(8,2), pos(9,2)]),           
    cage(16, [pos(8,3), pos(9,3)]), 
    cage(15, [pos(8,6), pos(8,7)]),
    cage(13, [pos(9,5), pos(9,6), pos(9,7)]),
    cage(17, [pos(9,8), pos(9,9)]) 
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
    takeSQRLines(Solution, SquareR), % all blocks must be distinct
    cages(CageList),  %copy the predefinded cages into CageList
    cages_all_diff_AND_add_up(CageList, Solution),
    label(Vars).  % CLP searchs concrete values to all remaining Vars.

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

