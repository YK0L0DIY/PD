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
% Predicado para fazer as constrange
%
solve([],[]).
solve([Line|TL],[CLine|TCL]):-
    fd_labeling(Line),
    check_line(Line,CLine),
    solve(TL,TCL).

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

print_elements([]).
print_elements([Element|T]):-
    Element=0, write(' .'),print_elements(T).
print_elements([Element|T]):-
    Element=1, write(' X'),print_elements(T).

print_rows([]).               % print da matrix
print_rows([H|T]) :- print_elements(H), nl, print_rows(T).

%
% Main
%

puzzle([L,C]):-
    nonogram(L,C,V),
    print_rows(V).

%
% Testes
%

test1 :-
    RowConstr = [[4],[1],[3,1],[2],[2]],
    ColConstr = [[1,1],[1,1],[3],[1,2],[3]],
    puzzle([RowConstr, ColConstr]).

test2 :-
    RowConstr = [[3],[2,1],[3,2],[2,2],[6],[1,5],[6],[1],[2]],
    ColConstr = [[1,2],[3,1],[1,5],[7,1],[5],[3],[4],[3]],
    puzzle([RowConstr, ColConstr]).

test3 :-
    RowConstr = [[3],[4,2],[6,6],[6,2,1],[1,4,2,1],[6,3,2],[6,7],[6,8],[1,10],
                [1,10],[1,10],[1,1,4,4],[3,4,4],[4,4],[4,4]],
    ColConstr = [[1],[11],[3,3,1],[7,2],[7],[15],[1,5,7],[2,8],[14],[9],[1,6],
                [1,9],[1,9],[1,10],[12]],
    puzzle([RowConstr, ColConstr]).

test4 :-
    RowConstr = [[1,1,1,1],[1,1,1,1],[1,1,1,1],[1,1,1,1],[1,1,1,1],[1,1,1,1],
                [1,1,1,1],[1,1,1,1]],
    ColConstr = [[1,1,1,1],[1,1,1,1],[1,1,1,1],[1,1,1,1],[1,1,1,1],[1,1,1,1],
                [1,1,1,1],[1,1,1,1]],
    puzzle([RowConstr, ColConstr]).

test5 :-
     RowConstr = [[1,1], [2,1,2], [2,1,1,2], [5,1,1,5], [4,1,1,5], [3,2,4], [3,4,4],
                 [11], [4], [3,4,3], [10], [6,2], [11], [2,6], [10], [2,4,2], [4],
                 [2,2], [8], [2,1,1,2], [2,2,2,2], [4,4], [8]],
     ColConstr = [[2], [5,1,1], [7,1,2,1,1], [5,2,1,2,3], [3,2,1,1,1,2,2], [1,5,2,3],
                 [2,17], [12,1,1], [12,1,1], [2,17], [1,5,2,3], [2,1,1,1,2,2],
                 [6,2,1,2,3], [5,1,1,1,1], [7,1,1], [5], [2]],
     puzzle([RowConstr, ColConstr]).

test6 :-
     RowConstr = [[6], [3, 1, 3], [1, 3, 1, 3], [3, 14], [1, 1, 1], [1, 1, 2, 2], [5, 2, 2], [5, 1, 1], [5, 3, 3, 3], [8, 3, 3, 3]],
     ColConstr = [[4], [4], [1, 5], [3, 4], [1, 5], [1], [4, 1], [2, 2, 2], [3, 3], [1, 1, 2], [2, 1, 1], [1, 1, 2], [4, 1], [1, 1, 2], [1, 1, 1], [2, 1, 2], [1, 1, 1], [3, 4], [2, 2, 1], [4, 1]],
     puzzle([RowConstr, ColConstr]).

test7 :-
     RowConstr = [[5], [2, 3, 2], [2, 5, 1], [2, 8], [2, 5, 11], [1, 1, 2, 1, 6], [1, 2, 1, 3], [2, 1, 1], [2, 6, 2], [15, 4], [10, 8], [2, 1, 4, 3, 6], [17], [17], [18], [1, 14], [1, 1, 14], [5, 9], [8], [7]],
     ColConstr = [[5], [3, 2], [2, 1, 2], [1, 1, 1], [1, 1, 1], [1, 3], [2, 2], [1, 3, 3], [1, 3, 3, 1], [1, 7, 2], [1, 9, 1], [1, 10], [1, 10], [1, 3, 5], [1, 8], [2, 1, 6], [3, 1, 7], [4, 1, 7], [6, 1, 8], [6, 10], [7, 10], [1, 4, 11], [1, 2, 11], [2, 12], [3, 13]],
     puzzle([RowConstr, ColConstr]).