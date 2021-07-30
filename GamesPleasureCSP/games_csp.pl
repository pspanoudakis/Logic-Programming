% File: games_csp.pl
% Pavlos Spanoudakis (sdi1800184)

:- lib(ic).
:- lib(branch_and_bound).

games_csp(Ps, T, K, Gs, TotalMaxP) :-
	% Set variables and domains
	length(Ps, NumGames),
	length(Gs, NumGames),
	Gs #:: 1..T,
	% Set constraints
	constraints(Gs, T, K, Ps, PleasureList),
	MaxP #= sum(PleasureList),
	bb_min(search(Gs, 0, most_constrained, indomain_middle, complete, []),
		   MaxP, bb_options{strategy: continue, solutions: all, report_success:true/0, report_failure:true/0}),
	TotalMaxP is -MaxP.

% Called to set variable constraints.
% Sets the constraints for the first variable, and then calls restConstraints to set the rest
% [G|R] is the list with the number of times to play each game
% T is capacity, K is refill chips
% [P|RestPleasures] is a list with the pleasures for each game
% [Pleasure|RestTotalPleasures] is a list with the total "obtained" pleasure by each game (G*P == Pleasure)
constraints([G|R], T, K, [P|RestPleasures], [Pleasure|RestTotalPleasures]) :-
	Temp #= T-G+K,					% Chips left after the first game is played 
	NewCurrent #= min(Temp, T),		% The number of chips in the wallet after the refill
	Pleasure #= -(P*G),				% This is the total pleasure obtained by this game. We get the negative value, so that
									% bb_min favors the "min cost" solution, which will be the one with the higher pleasure.
	restConstraints(R, T, K, RestPleasures, RestTotalPleasures, NewCurrent).	% Set the constraints for the rest of the games

restConstraints([], _, _, [], [], _).
restConstraints([G|R], T, K, [P|RestPleasures], [Pleasure|RestTotalPleasures], CurrentWallet) :-
	G #=< CurrentWallet,			% Cannot play the game more times than CurrentWallet chips
	Temp #= CurrentWallet-G+K,		% Chips left after the game is played 
	NewCurrent #= min(Temp, T),		% The number of chips in the wallet after the refill
	Pleasure #= -(P*G),				% This is the total pleasure obtained by this game
	restConstraints(R, T, K, RestPleasures, RestTotalPleasures, NewCurrent).	% Set the constraints for the rest of the games
