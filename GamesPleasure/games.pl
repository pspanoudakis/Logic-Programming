% File: games.pl
% Pavlos Spanoudakis (sdi1800184)

% Lecture Code ----------------------------------------------

between(LBound, RBound, LBound) :-
    LBound =< RBound. 
between(LBound, RBound, Result) :-
    LBound < RBound,
    NextLBound is LBound + 1,
    between(NextLBound, RBound, Result).

games(Ps, T, K, Gs, MaxP) :-
	findall(p(Gs, P), solution(Ps, T, T, K, Gs, P), L),
	findmax(L, MaxP),
	member(p(Gs,MaxP), L).

findmax([p(_, A)], A).
findmax([p(_,A1)|L], MaxA) :-
	findmax(L, MaxL),
	max(A1, MaxL, MaxA).
% -----------------------------------------------------------

% Returns all the possible solutions using backtracking
% [Ps|R] is the list of game pleasures, T is the capacity, Current is the current number of chips,
% K is the number of added chips in every refil, [Times|Rest] is the list of times each game will be played,
% and TP is the total pleasure.
solution([], _, _, _, [], 0).
solution([Ps|R], T, Current, K, [Times|Rest], TP) :-
	(Ps < 0 -> Times is 1; between(1, Current, Times)),		% If the current game "pleasure" is negative, just play it once
	T2 is (Current - Times) + K,
	min(T, T2, NewCurrent),									% Make sure the capacity is not exeeded
	solution(R, T, NewCurrent, K, Rest, P),					% Continue with the rest of the games
	TP is (Times*Ps) + P.									% Calculate total pleasure
