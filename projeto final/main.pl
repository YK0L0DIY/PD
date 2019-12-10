create_mat(0, _, []).
create_mat(N0, N, [Line|Matrix]) :-
	N0 > 0,
	N1 is N0 - 1,
	length(Line, N),
	fd_domain(Line,[0,1]), % limita-se as variavies com 0 ou 1
	create_mat(N1, N, Matrix).

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

avSum([],[],0).             % averiguar que a soma de uma lista de constrag e igual a soma da lista pretendida
avSum(Lx,Matx,S):-
    sumLista(Lx,S),
    sumListaC(Matx,S).

vLine([],[]).                % verificar a soma de cada linha
vLine([SubL|T],[SubL2|T2]):-
    avSum(SubL,SubL2,S),
    vLine(T,T2).

extract(ColNumber, Matrix, Column) :-   % extraie coluna de uma matrix
    maplist(nth0(ColNumber), Matrix, Column).

vColumns(M,L,Number):-       % verieficar a soma de cada coluna
    vColumns(M,L,0,Number).
vColumns(_,[],R,R).
vColumns(M,[E|T],N,Max):-
    extract(N,M,Col),
    avSum(E,Col,S),
    N1 is N+1,
    vColumns(M,T,N1,Max).

numberOfElements([],0).     % clcular o numero de elementos numa lista
numberOfElements(List,R):-
    numberOfElements(List,0,R).
numberOfElements([],R,R).
numberOfElements([E|T],N,R):-
    N1 is N+1,
    numberOfElements(T,N1,R).

vgrups([E|C],L):-           % vereficar se uma lsita tem os grupos corretos como pretendidos
    vgrups(C,E,L).
vgrups([],L):-
    vgrups([],0,L).
vgrups([],0,[]).
vgrups(L,C,[E|T]):-
    E=0,
    vgrups(L,C,T).
vgrups([],C,[E|T]):-
    E=1,
    C1 is C-1,
    vgrups([],C1,T).
vgrups(L,0,[E|T]):-
    E=1,fail.
vgrups([El|Tl],0,[E|T]):-
    E=0,
    vgrups(Tl,El,T).
vgrups(L,C,[E|T]):-
    E=1,
    C1 is C-1,
    vgrups(L,C1,T).


vLinha([],[]).           % verificar que todas as linhas teem os grupos corretamente formados
vLinha([SubL|T],[SubL2|T2]):-
    vgrups(SubL,SubL2),
    vLinha(T,T2).

vColunas(M,L,Number):-  % verificar que todas as colunas teem os grupos corretamnete criados
    vColunas(M,L,0,Number).
vColunas(_,[],R,R).
vColunas(M,[E|T],N,Max):-
    extract(N,M,Col),
    vgrups(E,Col),
    N1 is N+1,
    vColunas(M,T,N1,Max).

constrangir([C,L|_],MATRIX):-       % criar as contricoes :D
    numberOfElements(C,TColunas),   % obtem-se o numero de colunas
    numberOfElements(L,TLinhas),    % obtem-se o numero de linhas
    create_mat(TLinhas,TColunas,MATRIX),
    vLine(L,MATRIX),        % verefica-se se as somas sao iguais as restricoes pretendidas tanto nas linhas como nas colunas
    vColumns(MATRIX,C,TColunas),
    flatten(MATRIX, Vars), % cria-se a linha completa
    fd_labeling(Vars),     % da-se valoeres corretos aos elementos
    vLinha(L,MATRIX),      % verifica-se se as restricoes estao corretas nas linhas e nas colunas
    vColunas(MATRIX,C,TColunas).

print_elements([]).             % print de um elemento
print_elements([E|T]):-
    E=0, write('.'),print_elements(T).
print_elements([E|T]):-
    E=1, write('X'),print_elements(T).

print_matrix([]).               % print da matrix
print_matrix([H|T]) :- print_elements(H), nl, print_matrix(T).

puzzle(A):-                     % main
    constrangir(A,V),
    print_matrix(V).

%puzzle([[[1],[3],[1,1,1],[1],[1]],[[1],[1],[5],[1],[1]]]).
