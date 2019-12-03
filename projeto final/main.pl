create_mat(0, _, []).
create_mat(N0, N, [Line|Matrix]) :-
	N0 > 0,
	N1 is N0 - 1,
	length(Line, N),
	fd_domain(Line,[0,1]), % limita-se as variavies
	create_mat(N1, N, Matrix).


sumListaC([],0).
sumListaC(L,Sum):-
    sumListaC(L,0,Sum).
sumListaC([],X,Y):-X #= Y.
sumListaC([E|L],S,Sum):-
    S1 #= S+E,
    sumListaC(L,S1,Sum).

sumLista([],0).
sumLista(L,Sum):-
    sumLista(L,0,Sum).
sumLista([],X,Y):-X = Y.
sumLista([E|L],S,Sum):-
    S1 = S+E,
    sumLista(L,S1,Sum).

sumL([],[],0).
sumL(Lx,Matx,S):-
    sumLista(Lx,S),
    sumListaC(Matx,S).

vSum([],[]).
vSum([SubL|T],[SubL2|T2]):-
    sumL(SubL,SubL2,S),
    vSum(T,T2).


constrangir([L|C],TColunas,TLinhas,Vars):-
    create_mat(TColunas,TLinhas,MATRIX),
    vSum(L,MATRIX),
    flatten(MATRIX, Vars), % cria-se a linha completa
    fd_labeling(Vars).


puzzle(A,V):-
    constrangir(A,4,4,V).

