nonogram(RConstr, CConstr, Rows) :-
    length(RConstr, NRows),
    length(CConstr, NCols),
    matrix(NRows, NCols, Rows, Cols),
    append(RConstr, CConstr, LineConstr),
    append(Rows, Cols, Lines),
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

space([' '|Line],Line).                 % adiciona um espaco

add_space(Line, Line).                  % verefica se precisa de um espaco
add_space([' '|Line],RestLine) :-
    add_space(Line, RestLine).

check_part(Line, Line, 0).              % verifica se a linha esta com as partes cprretas
check_part(['x'|Line], Rest, N) :-
    N > 0,
    N1 is N - 1,
    check_part(Line, Rest, N1).

%
% Predicados para fazer print
%

print_elements([]).             % print de um elemento
print_elements([Element|T]):-
    Element=' ', write(' .'),print_elements(T).
print_elements([Element|T]):-
    Element='x', write(' X'),print_elements(T).

print_rows([]).               % print da matrix
print_rows([H|T]) :- print_elements(H), nl, print_rows(T).

puzzle([RowConstr, ColConstr|_]) :-
    nonogram(RowConstr, ColConstr, Rows),
    nl, print_rows(Rows), nl.