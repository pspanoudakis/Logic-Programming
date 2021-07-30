% File: hopfield.pl
% Pavlos Spanoudakis (sdi1800184)

hopfield([V1|RV], W) :-
	length([V1|RV], M),						% M is the number of given vectors
	length(V1, N),							% N is the vectors length
	hopfield_matrixes_sum([V1|RV], VM),		% Getting the sum of the Matrixes of all Vectors
	identity_matr(N, IM),					% Creating Indentity Matrix In
	NM is M * (-1),
	matr_prod(IM, NM, PIM),					% Getting Matrix (-M)*In
	matr_sum(VM, PIM, W).					% Adding it to the previously calculated Matrix

hopfield_matrixes_sum([], []).
hopfield_matrixes_sum([V1|RV], TM) :-		% Returns the sum of the Matrixes of vectors in [V1|RV] in TM.
	hopfield_vector_matr(V1, V1, VM),		% Get the Matrix V1 * (V1)^-1
	hopfield_matrixes_sum(RV, RM),			% Find the total Matrix for the rest of the vectors
	matr_sum(VM, RM, TM).					% Add the 2 Matrixes and return in TM.

hopfield_prod(X1,X2, P) :-					% Multiplies X1 with X2 and stores the result in P.
	abs(X1, 1),								% But checks if X1 and X2 are either +1 or -1.
	abs(X2, 1),
	P is X1*X2.

hopfield_vector_matr(_, [], []).
hopfield_vector_matr(V, [N|R], [FL|RL]) :-	% Returns Matrix V * V^-1 in [FL|RL].
	list_hopfield_prod(V, N, FL),
	hopfield_vector_matr(V, R, RL).			% [N|R] is initialy V, but N is removed in every new call,
											% So V will be have been multiplied with every element of it at the end.

matr_prod([], _, []).
matr_prod([FL|RL], N, [NF|NR]) :-			% Multiplies Matrix [FL|RL] with N.
	list_prod(FL, N, NF),					% Multiply first line
	matr_prod(RL, N, NR).					% And multiply the rest of the lines

list_hopfield_prod([], _, []).
list_hopfield_prod([H|T], N, [NH|NT]) :-	% Multiplies List [H|T] with N, but using hopfield_prod,
	hopfield_prod(H, N, NH),				% to make sure the list elements and N are either +1 or -1.
	list_prod(T, N, NT).
	
list_prod([], _, []).
list_prod([H|T], N, [NH|NT]) :-				% Multiplies List [H|T] with N.
	NH is H * N,
	list_prod(T, N, NT).

matr_sum([FR|RR], [], [FR|RR]):- !.			% cut is needed here, otherwise there will be multiple identical solutions
matr_sum([], [], []).
matr_sum([F1|R1], [F2|R2], [S1|S2]) :-		% Calculates the sum Matrix of Matrixes [F1|R1] and [F2|R2] and returns it in [S1|S2]
	list_sum(F1, F2, S1),					% Add the Matrixes line by line
	matr_sum(R1, R2, S2).

list_sum([], [], []).						% Returns a list with the sums of the corresponding elements
list_sum([H1|T1], [H2|T2], [HS|TS]) :-		% in lists [H1|T1] and [H2|T2] in [HS|TS].
	HS is H1 + H2,
	list_sum(T1, T2, TS).

make_identity_matr_lines([], LineLength, LineLength, []).
make_identity_matr_lines([Current|Rest], Index, LineLength, [NewCurrent|NewRest]) :-	% Gets a Matrix LineLength x LineLength and returns
	length(Current, LineLength),														% an identity Matrix [NewCurrent|NewRest].
	identity_line(Current, Index, NewCurrent),											% Index indicates the Current Line element to be set to 1
	NewIndex is Index + 1,
	make_identity_matr_lines(Rest, NewIndex, LineLength, NewRest).

identity_matr(N, IM) :-						% Returns an identity Matrix N x N in IM
	length(M, N),							% Create a Matrix "skeleton" with N lines
	make_identity_matr_lines(M, 0, N, IM).

identity_line([], _, []).					% Creates a List where Nth element is 1 and the rest are 0.
identity_line([_|T], N, [1|Rest]) :-
	N = 0,									% If N is 0, add 1 in line
	identity_line(T, -1, Rest).
identity_line([_|T], N, [0|Rest]) :-
	N \= 0,									% If N is not 0, add 0 in line
	N2 is N - 1,
	identity_line(T, N2, Rest).
