num(z).
num(s(X)):-num(X).

soma(z,Y,Y).
soma(s(X),Y,s(Z)):-soma(X,Y,Z).

subt(X,Y,Z):-soma(Z,X,Y).


le(X,Y):-soma(X,_,Y).

lt(X,s(Y)):-le(X,Y).

dobro(X,Y):-soma(X,X,Y).

mult(z,_,z).
mult(s(X),Y,Z):- mult(X,Y,R),soma(Y,R,Z).

div(A,B,X):- mult(X,B,A).

div(A,B,Q,R):- mult(B,Q,X),soma(X,R,A),lt(R,B).

poten(_,z,s(z)).
poten(X,s(Y),Z):- poten(X,Y,W),mult(W,X,Z).

quadrado(X,Y):-mult(X,X,Y).


membro(X, [X|_]).
membro(X, [_|L]) :- membro(X, L).

prefixo([], _).
prefixo([X|A], [X|B]) :- prefixo(A, B).

sufixo(A, A).
sufixo(A, [_|B]) :- sufixo(A, B).

sublista(S, L) :- prefixo(P, L), sufixo(S, P).

catena([], L, L).
catena([X|Xs], L, [X|Y]) :- catena(Xs, L, Y).

corta(L,E,L1,L2):- catena(L1,[E|_],L),L2=[E|_],catena(L1,L2,L).

