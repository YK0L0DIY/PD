nonogram(RConstr, CConstr, Rows) :-
    length(RConstr, NRows),
    length(CConstr, NCols),
    matrix(NRows, NCols, Rows, Cols),
    append(RConstr, CConstr, LineConstr),
    append(Rows, Cols, Lines),
    solve(Lines, LineConstr).

/**
 * matrix return the Cols and the Rows
 */

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
% Nonogram solving algorithm
%

solve(Lines, Constrs) :-
    pack(Lines, Constrs, Pack),     % todas as possibilidades por linha/coluna
    sort(Pack, SortedPack),         % ordena por ordem de menores possibilidades
    solve(SortedPack).              % consroi as restricoes fixando uma a uma

solve([]).
solve([line(_, Line, Constr)|Rest]) :-
    check_line(Line, Constr),
    solve(Rest).

/**
 * pack(+Lines:list, +Constrs:list, -Result:list) is det.
 *
 * Packs a line and its constraints into a single term and adds the number of
 * possible line solutions given the line's length and constraints as the term's
 * first argument to enable sorting.
 */
pack([], [], []).
pack([Line|Lines], [Constr|Constrs], [line(Count, Line, Constr)|Result]) :-
    length(Line, LineLength),
    length(CheckLine, LineLength),
    findall(CheckLine, check_line(CheckLine, Constr), NCheckLine),
    length(NCheckLine, Count),
    pack(Lines, Constrs, Result).

/**
 * check_line(+Line:list ,+Constraints:list) is nondet.
 *
 * Checks if the given Line satisfies the Constraints. Can also generate all
 * valid lines if given a line with some or all members unbound. Examples:
 *   ?- check_line([x, ' ', x, ' '], [1,1]).
 *   true .
 *   ?- L = [_,_,_,_,_], check_line(L, [2,1]).
 *   L = [x, x, ' ', x, ' '] ;
 *   L = [x, x, ' ', ' ', x] ;
 *   L = [' ', x, x, ' ', x] .
 */
check_line([],[]) :- !.
check_line(Line, [Part|Rest]) :-
    Rest \= [],
    add_space(Line, Line2),
    check_part(Line2, Line3, Part),
    force_space(Line3, Line4),
    check_line(Line4, Rest).
check_line(Line, [Part|[]]) :-
    add_space(Line, Line2),
    check_part(Line2, Line3, Part),
    add_space(Line3, Line4),
    check_line(Line4, []).

force_space([' '|Line],Line).

add_space(Line, Line).
add_space([' '|Line],RestLine) :-
    add_space(Line, RestLine).

check_part(Line, Line, 0).
check_part(['x'|Line], RestLine, N) :-
    N > 0,
    N1 is N - 1,
    check_part(Line, RestLine, N1).

%
% Functions to produce a nice output
%

print_solution([]).
print_solution([Row|Rows]) :-
    print(' '),
    print_line(Row),
    nl,
    print_solution(Rows).

print_line([]).
print_line([Var|Vars]) :-
    print_var(Var),
    print(' '),
    print_line(Vars).

print_var(' ') :- print('.').
print_var('x') :- print('X').

%
% Tests and examples
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
     RowConstr = [[1],[3],[1,1,1],[1],[1]],
     ColConstr = [[1],[1],[5],[1],[1]],
     puzzle([RowConstr, ColConstr]).

puzzle([RowConstr, ColConstr|_]) :-
    nonogram(RowConstr, ColConstr, Rows),
    nl, print_solution(Rows), nl.