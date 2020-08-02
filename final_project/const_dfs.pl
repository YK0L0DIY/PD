nonogram(RConstr, CConstr, Rows) :-
    length(RConstr, NRows),
    length(CConstr, NCols),
    matrix(NRows, NCols, Rows, Cols),
    append(RConstr, CConstr, LineConstr),
    append(Rows, Cols, Lines),
    vLine(Lines,LineConstr),
    solve(Lines, LineConstr).

%
% matrix devolve as Rows Cols da matrix
%

matrix(NRows, NCols, Rows, Cols) :-
    create_mat(NRows, NCols, Rows),
    extract_columns(NCols, Rows, Cols).

create_mat(0, _, []).
create_mat(N0, N, [Line|Matrix]) :-
    N0 > 0,
    N1 is N0 - 1,
    length(Line, N),
    fd_domain(Line,[0,1]),                      % limita-se as variavies com 0 ou 1
    create_mat(N1, N, Matrix).

extract_columns(NCols, Rows, Cols) :-
    NCols1 is NCols + 1,
    extract_columns(NCols, NCols1, Rows, Cols).
extract_columns(0, _, _, []) :- !.
extract_columns(N, Max, Rows, [Col|Cols]) :-
    InvN is Max - N,
    extract(Rows,Col, InvN),
    N1 is N - 1,
    extract_columns(N1, Max, Rows, Cols).

extract(Rows, Col, N) :-
    maplist(nth1(N), Rows, Col).

%
% Algoritmo para resolver o nonograma
%

sumListaC([],0).            % fazer o contrang de uma lista para terem a soma pretendida
sumListaC(L,Sum):-
    sumListaC(L,0,Sum).
sumListaC([],X,Y):-
    X #= Y.
sumListaC([E|L],S,Sum):-
    S1 #= S+E,
    sumListaC(L,S1,Sum).

sumLista([],0).            % calcular a soma dos elemetos de uma lista
sumLista(L,Sum):-
    sumLista(L,0,Sum).
sumLista([],X,X).
sumLista([E|L],S,Sum):-
    S1 = S+E,
    sumLista(L,S1,Sum).

vLine([],[]).                % verificar a soma de cada linha
vLine([SubL|T],[SubL2|T2]):-
    avSum(SubL,SubL2,_),
    vLine(T,T2).

avSum([],[],0).             % averiguar que a soma de uma lista de constrag e igual a soma da lista pretendida
avSum(Line,CLine,S):-
    sumLista(Line,S),
    sumListaC(CLine,S).

solve(Lines, Constrs) :-
    allPossibilitis(Lines, Constrs, All),     % todas as possibilidades por linha/coluna
    sort(All, Sorted),!,                        % ordena por ordem de menores possibilidades
    solve(Sorted).                            % verefica se a linha esta correta relativamente as possibilidades

solve([]):-!.
solve([line(_, Line, Constr)|Rest]) :-
    check_line(Line, Constr),
    solve(Rest).

%
%   calcula todas a possibilidades uma linha segundo as restricoes e devolve uma lista de tupulos
%   cada tupulo com o numero de possibilidades para essa linha, linha e contricao criada
%

allPossibilitis([], [], []).
allPossibilitis([Line|Lines], [Constr|Constrs], [line(Count, Line, Constr)|Result]) :-
    length(Line, LineLength),
    length(CheckLine, LineLength),
    setof(CheckLine, check_line(CheckLine, Constr), NCheckLine),
    length(NCheckLine, Count),
    allPossibilitis(Lines, Constrs, Result).

% check_line verefica se a linha esta correta segundo as constricoes ou constroi uma linha segundo as restricoes
%   Exemplo:
%   ?- L = [_,_,_,_,_], check_line(L, [2,1]).
%   L = [x, x, ' ', ' ', x] ;
%   L = [' ', x, x, ' ', x] ;
%   L = [x, x, ' ', x, ' '] .

check_line([],[]).
check_line(Line, [Part|Rest]) :-
    Rest \= [],
    add_space(Line, Line2),
    check_part(Line2, Line3, Part),
    space(Line3, Line4),
    check_line(Line4, Rest).
check_line(Line, [Part|[]]) :-
    add_space(Line, Line2),
    check_part(Line2, Line3, Part),
    add_space(Line3, Line4),
    check_line(Line4, []).

space([0|Line],Line).                 % adiciona um espaco

add_space(Line, Line).                  % verefica se precisa de um espaco
add_space([0|Line],RestLine) :-
    add_space(Line, RestLine).

check_part(Line, Line, 0).              % verifica se a linha esta com as partes cprretas
check_part([1|Line], Rest, N) :-
    N > 0,
    N1 is N - 1,
    check_part(Line, Rest, N1).

%
% Predicados para fazer print
%

print_elements([]).             % print de um elemento
print_elements([Element|T]):-
    Element=0, write(' .'),print_elements(T).
print_elements([Element|T]):-
    Element=1, write(' X'),print_elements(T).

print_rows([]).               % print da matrix
print_rows([H|T]) :- print_elements(H), nl, print_rows(T).

puzzle([RowConstr, ColConstr|_]) :-
    nonogram(RowConstr, ColConstr, Rows),
    nl, print_rows(Rows), nl.