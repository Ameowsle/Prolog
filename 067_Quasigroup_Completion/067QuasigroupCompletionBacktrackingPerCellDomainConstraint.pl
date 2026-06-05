% Example instance: a partially pre-filled 7x7 quasigroup. Filled cells hold a
% value in 1..M, empty cells are unbound. This is only example data; the solver
% takes the puzzle as an argument (see quasigroup/2), so the same relation
% solves any instance.
partially_quasigroup([
    [1, _, _, 4, _, _, _],
    [_, 3, _, _, _, 7, _],
    [_, _, 5, _, _, _, 2],
    [4, _, _, 7, _, _, _],
    [_, 6, _, _, 2, _, _],
    [_, _, 1, _, _, 4, _],
    [7, _, _, 3, _, _, 6]
]).

% quasigroup(+Puzzle, -Solution)
% Solve in place (Solution = Puzzle): like the per-cell solver, but the column
% values are subtracted from the candidate set before a cell is assigned, so a
% column-conflicting value never enters the search tree at all.
quasigroup(Puzzle, Solution):-
    Solution = Puzzle,
    length(Solution, M),
    numlist(1, M, Domain),
    maplist(fill_row_dc(Domain, Solution), Solution).

% fill_row_dc(+Domain, +Solution, +Row)
% Reduce the full Domain by the values already pre-filled in Row, then assign
% the empty cells of Row from what remains. Solution is the whole board, needed
% so assign_cell_dc/4 can read the columns.
fill_row_dc(Domain, Solution, Row):-
    include(nonvar, Row, Prefilled), % collect prefilled values
    subtract(Domain, Prefilled, Reduced),  % remove prefilled from domain
    assign_cell_dc(Row, Reduced, 1, Solution).

% assign_cell_dc(+Row, +Remaining, +Index, +Solution)
% Walk the row left to right. Index is the 1-based column of the current cell.
% Remaining is the set of row values not yet placed.
assign_cell_dc([], _Remaining, _Index, _Solution).
assign_cell_dc([Cell|Rest], Remaining, Index, Solution):-
    nonvar(Cell), % cell pre-filled, skip it (its value is not in Remaining)
    NextIndex is Index + 1,
    assign_cell_dc(Rest, Remaining, NextIndex, Solution).
assign_cell_dc([Cell|Rest], Remaining, Index, Solution) :-
    var(Cell),
    maplist(nth1(Index), Solution, Col),      % extract the column for the given index
    include(nonvar, Col, ColUsed),            % collect already filled column values
    subtract(Remaining, ColUsed, Candidates), % candidates = row domain minus column values
    member(Cell, Candidates),                 % cell empty -> assign from the restricted domain
    select(Cell, Remaining, NewRemaining),    % update remaining row values
    NextIndex is Index + 1,
    assign_cell_dc(Rest, NewRemaining, NextIndex, Solution).
