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

extract(ColNumber, Matrix, Column) :-
    maplist(nth0(ColNumber), Matrix, Column).

vColumns(M,L,Number):-vColumns(M,L,0,Number).
vColumns(_,[],R,R).
vColumns(M,[E|T],N,Max):-
    extract(N,M,Col),
    sumL(E,Col,S),
    N1 is N+1,
    vColumns(M,T,N1,Max).

constrangir([C,L|_],TLinhas,TColunas,MATRIX):-
%    fd_domain(TLinhas,1,20),
%    fd_domain(TColunas,1,20),
    create_mat(TLinhas,TColunas,MATRIX),
    vSum(C,MATRIX),
    vColumns(MATRIX,L,TColunas),
    flatten(MATRIX, Vars), % cria-se a linha completa
    fd_labeling(Vars).

print_elements([]).
print_elements([E|T]):-
    E=0, write('.'),print_elements(T).
print_elements([E|T]):-
    E=1, write('X'),print_elements(T).


print_matrix([]).
print_matrix([H|T]) :- print_elements(H), nl, print_matrix(T).


puzzle(A):-
    constrangir(A,5,5,V),
    print_matrix(V).
