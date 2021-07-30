% File: diags.pl
% Pavlos Spanoudakis (sdi1800184)

% Lecture Predicates ----------------------------
del_first([], [], []).
del_first([[X|L]|R], [X|RX], [L|RL]) :-
   del_first(R, RX, RL).

empty_lists([]).
empty_lists([[]|M]) :-
   empty_lists(M).

% Predicates implemented for this exercise ------

% Deletes all '_DUMMY_' elements from the given list
del_dummies([],[]).
del_dummies([X|L], [X|RL]) :-
	X \= '_DUMMY_',
	del_dummies(L,RL).
del_dummies([X|L], RL) :-
	X = '_DUMMY_',
	del_dummies(L, RL).

% Deletes all '_DUMMY_' elements from the given matrix
del_matrix_dummies([], []).
del_matrix_dummies([F|L], [NF|NL]) :-
	del_dummies(F, NF),
	del_matrix_dummies(L, NL).

% Adds '_DUMMY_' elements to the head of the given list,
% until counter is 0.
add_dummies_left(L, L, 0).
add_dummies_left(L, ['_DUMMY_'|NL], Counter) :-
	Counter > 0,
	Ncounter is Counter-1,
	add_dummies_left(L, NL, Ncounter).

% Adds '_DUMMY_' elements to the end of the given list,
% until counter is 0.
add_dummies_right(L, L, 0).
add_dummies_right(L, FL, Counter) :-
	Counter > 0,
	Ncounter is Counter-1,
	append(L, ['_DUMMY_'], NL),
	add_dummies_right(NL, FL, Ncounter).	

% Adds LC '_DUMMY_' elements at the front of list L,
% and RC '_DUMMY_' elements at the end of it.
add_dummies(L, FL, LC, RC) :-
	add_dummies_left(L, NL, LC),
	add_dummies_right(NL, FL, RC).

% Fills up the Matrix with '_DUMMY_' elements.
% In each call, adds LC dummies to the head of F,
% and RC dummies to the end of F.
% To be used by diags_up.
add_matrix_dummies_up([],[], _, _).
add_matrix_dummies_up([F|L], [NF|NL], LC, RC) :-
	RC >= 0,
	add_dummies(F, NF, LC, RC),
	NLC is LC+1,
	NRC is RC-1,
	% Next line will be filled with LC+1 dummies in front,
	% and RC-1 dummies at the end.
	add_matrix_dummies_up(L, NL, NLC, NRC).

% Fills up the Matrix with '_DUMMY_' elements.
% In each call, adds LC dummies to the head of F,
% and RC dummies to the end of F.
% To be used by diags_down.
add_matrix_dummies_down([],[], _, _).
add_matrix_dummies_down([F|L], [NF|NL], LC, RC) :-
	LC >= 0,
	add_dummies(F, NF, LC, RC),
	NLC is LC-1,
	NRC is RC+1,
	% Next line will be filled with LC-1 dummies in front,
	% and RC+1 dummies at the end.
	add_matrix_dummies_down(L, NL, NLC, NRC).

% Returns a list with the columns of the given matrix.
get_columns(Matrix, []) :-
	empty_lists(Matrix).
get_columns(Matrix, [Col|RestCols]) :-
	del_first(Matrix, Col, Left),
	get_columns(Left, RestCols).

% Finding diagonals (either ascending or descending):
% - Fill up the matrix with dummies in order to "shift" the lines.
% With proper shifting, the elements of each diagonal will be in the same column.
% - Get the columns of the new matrix
% - Delete all the dummy elements of it
% - The remaining list of lists is also a list with the diagonals.

% Returns a list with the ascending diagonals of the given matrix.
diags_up(Matrix, Diags) :-
	length(Matrix, Length),		% get number of lines to fill up the matrix
								% with dummy elements properly
	RC is Length-1,
	LC is 0,
	add_matrix_dummies_up(Matrix, DMatrix, LC, RC),
	get_columns(DMatrix, Dcols),
	del_matrix_dummies(Dcols, Diags).

% Returns a list with the descending diagonals of the given matrix.
diags_down(Matrix, Diags) :-
	length(Matrix, Length),		% get number of lines to fill up the matrix
								% with dummy elements properly
	LC is Length-1,
	RC is 0,
	add_matrix_dummies_down(Matrix, DMatrix, LC, RC),
	get_columns(DMatrix, Dcols),
	del_matrix_dummies(Dcols, Diags).

diags(Matrix, DiagsDown, DiagsUp) :-
	diags_down(Matrix, DiagsDown),
	diags_up(Matrix, DiagsUp).