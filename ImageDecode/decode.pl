% File: decode.pl
% Pavlos Spanoudakis (sdi1800184)

:- lib(ic).

% diags.pl file (ex1) is required
:- ['../MatrixDiagonals/diags.pl'].

% Lecture code --------------------------
make_matrix(M, N, Matrix) :-
   length(Matrix, M),
   make_lines(N, Matrix).

make_lines(_, []).
make_lines(N, [Line|Matrix]) :-
   length(Line, N),
   make_lines(N, Matrix).
% ---------------------------------------

% Used to set all Matrix element domains to [0, 1]
% 0 -> '.'
% 1 -> '*'
set_domain([]).
set_domain([FL|RL]) :-
	FL #:: [0, 1],
	set_domain(RL).

% Used to set total '*' constraint in each Matrix line.
% [FL|RL] are the Matrix Lines and [FS|RS] are the number of '*' for each line
line_constraints([], []).
line_constraints([FL|RL], [FS|RS]) :-
	sum(FL) #= FS,
	line_constraints(RL, RS).

% Used to set total '*' constraint in each Matrix column.
column_constraints(_, []).
column_constraints(Matrix, [FS|RS]) :-
	del_first(Matrix, First, Rest),
	sum(First) #= FS,
	column_constraints(Rest, RS).

% Used to set total '*' constraint in each Matrix descending diagonal.
down_diags_constraints(_, []).
down_diags_constraints([FD|RD], [FS|RS]) :-
	sum(FD) #= FS,
	down_diags_constraints(RD, RS).

% Used to set total '*' constraint in each Matrix ascending diagonal.
up_diags_constraints(_, []).
up_diags_constraints([FD|RD], [FS|RS]) :-
	sum(FD) #= FS,
	up_diags_constraints(RD, RS).

% Prints the found solution.
print_solution([]).
print_solution([FL|RL]) :-
	print_line(FL),
	print("\n"),
	print_solution(RL).

% Prints the given line of the solution.
% 0 -> '.'
% 1 -> '*'
print_line([]).
print_line([0|R]) :-
	print(" ."),
	print_line(R).
print_line([1|R]) :-
	print(" *"),
	print_line(R).

decode(LineSums, ColumnSums, DownDiagSums, UpDiagSums) :-
	% Setting up domains
	length(LineSums, Lines),
	length(ColumnSums, Columns),
	make_matrix(Lines, Columns, Matrix),
	set_domain(Matrix),

	% Setting up constraints
	line_constraints(Matrix, LineSums),
	column_constraints(Matrix, ColumnSums),
	diags(Matrix, DiagsDown, DiagsUp),
	down_diags_constraints(DiagsDown, DownDiagSums),
	up_diags_constraints(DiagsUp, UpDiagSums),

	% Finding a solution
	search(Matrix, 0, first_fail, indomain, complete, []),

	% Pretty printing
	print_solution(Matrix).
