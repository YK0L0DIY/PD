mgsqr(N, V) :- N2 is N*N, length(V, N2), fd_domain(V, 1, N2), fd_all_different(V).


/*
	TIPO 	INICIAL 	PASSO
	-------------------------
	line	(I-1)*N+1	1
	column	J			N
	ddiag	1			N+1
	adiag	N           N-1
*/

/*
	line:
		I - index of the line.
		V - All the variables.
		N - Size of problem.
		LV - variables from V that are in the line I.
*/
lines(N, V, C) :- lines(N, V, N, C).

lines(0, _, _, _).
lines(I, V, N, C) :- line(I, V, N, LV), sum(LV, C), NI is I-1, lines(NI, V, N, C).

line(I, V, N, LV) :- XI is (I-1)*N+1, XP is 1, pop(N, XI, XP, V, LV).

/*
	column:
		J - index of the column.
		V - All the variables.
		N - Size of problem.
		CV - variables from V that are in column J.
*/
columns(N, V, C) :- columns(N, V, N, C).

columns(0, _, _, _).
columns(J, V, N, C) :- column(J, V, N, CV), sum(CV, C), NJ is J-1, columns(NJ, V, N, C). 

column(J, V, N, CV) :- XP is N, pop(N, J, XP, V, CV).

/*
	ddiag: (descending diagonal)
		N - Size of problem.
		V - All the variables.
		DV - variables from V that are on the descending diagonal.
*/
ddiags(N, V, C) :- ddiag(N, V, DV), sum(DV, C).

ddiag(N, V, DV) :- XDD is 1, XP is N+1, pop(N, XDD, XP, V, DV).

/* 	
	adiag: (ascending diagonal)
		N - Size of problem.
		V - All the variables.
		DV - variables from V that are on the acending diagonal.
*/
adiags(N, V, C) :- adiag(N, V, DV), sum(DV, C).

adiag(N, V, DV) :- XAD is N, XP is N-1, pop(N, XAD, XP, V, DV).

/*
	pop:
		K - nth element.
		XI - first element.
		XP - the step.
		V - All the variables.
		[H|T] - sublista no elemento I(line, column or diagonal) with the step XP.
*/
pop(0, _, _, _, []).
pop(K, XI, XP, V, [H|T]) :- nth1(XI, V, H), NXI is XI + XP, K1 is K-1, pop(K1, NXI, XP, V, T).

/*
	sum:
		V - All the variables.
		S - sum from all of the variables.
*/
sum(V, S) :- sum(V, 0, S).
sum([], X, Y) :- X #= Y.
sum([H|T], A, S) :- B #= A+H, sum(T, B, S).


pretty(N, V) :- mgsqr(N, V), lines(N, V, C), columns(N, V, C), ddiags(N, V, C), adiags(N, V, C), fd_labeling(V), pretty(N, N, V).
pretty(0, _, _).
pretty(I, N, V) :- line(I, V, N, LV), format("~3w", LV), NI is I-1, pretty(NI, N, LV).  