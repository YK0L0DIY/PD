sum(X,R):-sum(X,0,R).
sum([],R,R).
sum([X|T],Y,R):-Y1 is Y+X,sum(T,Y1,R).

prod(X,R):-prod(X,1,R).
prod([],R,R).
prod([X|T],Y,R):-Y1 is Y*X,prod(T,Y1,R).

len(X,R):- len(X,0,R).
len([],R,R).
len([_|T],Y,R):-Y1 is Y+1,len(T,Y1,R).

compr(_,X,[],X).
compr(OP,X,[E|T],R):-
    compr(OP,X,T,R1),
    functor(S,OP,2),
    arg(1,S,E),
    arg(2,S,R1),
    R is S.

comprT(_,R,[],R).
comprT(OP,X,[E|T],R):-
    functor(S,OP,2),
    arg(1,S,X),
    arg(2,S,E),
    X1 is S,
    comprT(OP,X1,T,R).

sumT(X,T):- comprT(+,0,X,T).
prodT(X,T):- comprT(*,1,X,T).
sumbT(X,T):- comprT(-,0,X,T).




