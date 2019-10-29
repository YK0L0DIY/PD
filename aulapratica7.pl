%aula de dia 23
%eval(X,X):-integer(X).
%
%eval(X+Y,Z):-
%    eval(X,XX),eval(Y,YY),Z is XX+YY.
%
%eval(X-Y,Z):-
%    eval(X,XX),eval(Y,YY),Z is XX-YY.
%
%calc:-
%    write('> '),flush,read(XX),eval(XX,Y), write(Y), nl,calc.

