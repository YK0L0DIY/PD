perm([], []).
perm(L, [X|LP]) :-
    select(X, L, LX),
    perm(LX, LP).

ord([]).
ord([_]).
ord([A,B|X]) :- A<B, ord([B|X]).

psort(L, S) :- perm(L, S), ord(S).

isort(I, S) :- isort(I, [], S).
isort([], S, S).
isort([X|Xs], SI, SO) :-
    insord(X, SI, SX),
    isort(Xs, SX, SO).
insord(X, [], [X]).
insord(X, [A|As], [X,A|As]) :- X=<A.
insord(X, [A|As], [A|AAs]) :-
    X>A,
    insord(X, As, AAs).

qsort(L, S) :- qsort(L, [], S).
qsort([], L, L).
qsort([X|Xs], L0, L) :-
    part(Xs, X, MEN, MAI),
    qsort(MAI, L0, L1),
    qsort(MEN, [X|L1], L).
part([], _, [], []).
part([X|L], Y, [X|L1], L2) :-
    X =< Y, !,
    part(L, Y, L1, L2).
part([X|L], Y, L1, [X|L2]) :-
    part(L, Y, L1, L2).

random(0,[]).
random(X,[R|Y]):- random(R), X1 is X-1, random(X1,Y).
