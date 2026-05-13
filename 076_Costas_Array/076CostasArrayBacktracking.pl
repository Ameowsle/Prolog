costas(N, Xs) :- % entry point: builds a Costas Array of size N
    numlist(1, N, Domain), % Domain = [1,2,...,N], the values to place
    build(Domain, [], [], Xs). % start building with empty placement and no used diffs

% Avail: values not yet placed
% Placed: values placed so far, in reverse order (most recent first)
% Used: list of Level-Diff pairs already used across all levels
% Xs: final result, only bound in the base case

% base case: all values placed
build([], Placed, _, Xs) :- % all values placed, construct result
    reverse(Placed, Xs). % Placed was built in reverse, flip it to get Xs 
build(Avail, Placed, Used, Xs) :- % recursive case: still values to place
    select(Can, Avail, Rest), % pick candidate Can from Avail, Rest = Avail without Can
    check_diffs(Can, Placed, 1, Used, NewUsed), % verify Can and collect new Level-Diff pairs
    build(Rest, [Can|Placed], NewUsed, Xs). % recurse with Can placed and updated Used

% check_diffs(+Can, +Placed, +Level, +Used, -NewUsed)
% For each previously placed value at increasing levels, check that Can-H is unused at that level.
check_diffs(_, [], _, Used, Used). % base case: no prior values left to check
check_diffs(Can, [H|T], L, Used, NewUsed) :- % check Can against H at level L
    D is Can - H, % compute difference: new value minus value placed L steps ago
    \+ member(L-D, Used), % reject if displacement vector L-D already exists
    L1 is L + 1, % next earlier value is one level further away
    check_diffs(Can, T, L1, [L-D|Used], NewUsed). % recurse with L-D added to Used
