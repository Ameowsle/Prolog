
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
    append(Solution, Vars),
    fill(Vars, Solution).

fill([], _).
fill([H|Rest], Solution):-
    nonvar(H), %checks if H is a Number (Nonvar), returns true if so and goes on (if false the other fill method is called)
    fill(Rest, Solution).

fill([H|Rest], Solution):-
    var(H), %checks if H is a _ (var)
    member(H, [1,2,3,4,5,6,7,8,9]),
    check_position(Solution),
    fill(Rest, Solution).


check_position(Solution):-
    rows_all_diff(Solution), % all elements in a row must be distinct
    cols_all_diff(Solution), % all elements in a col must be distinct
    blocks_all_diff(Solution). % all 3x3 blocks must be distinct

rows_all_diff([]).
rows_all_diff([FirstRow| Rest]):-
    all_diff(FirstRow), %checks if the chosen Number fits in the Row 
    rows_all_diff(Rest).

cols_all_diff(Solution):-
    numlist(1,9,Indices), %creates list with number 1 to 9
    maplist(check_with_index(Solution), Indices). %calls function on every index 

check_with_index(Solution, Index):-
    maplist(nth1(Index), Solution, Col), %takes the element at Index from every Row and stores it in Col
    all_diff(Col).  %checks if the chosen Number fits in the Col 


blocks([], [], []).
blocks([V1,V2,V3|Rest1], [V4,V5,V6|Rest2], [V7,V8,V9|Rest3]) :-
    all_diff([V1,V2,V3,V4,V5,V6,V7,V8,V9]),
    blocks(Rest1, Rest2, Rest3).

blocks_all_diff([]).
blocks_all_diff([R1, R2, R3 | Rest]):-
    blocks(R1, R2, R3),
    blocks_all_diff(Rest).

all_diff(List) :-
    include(nonvar, List, OnlyNum),  %only keep the numbers (remove all _)
    sort(OnlyNum, Sorted), % sort removes duplicates
    %check if list is the same after the sort
    length(OnlyNum, N), 
    length(Sorted, N).