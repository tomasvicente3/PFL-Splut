%belongs(+Player, +Piece)
belongs(1, 'S').
belongs(1, 'D').
belongs(1, 'T').
belongs(2, 's').
belongs(2, 'd').
belongs(2, 't').

%direction_map(+Direction, -[Dx, Dy])
direction_map('N', [0, -1]).
direction_map('S', [0, 1]).
direction_map('E', [1, 0]).
direction_map('W', [-1, 0]).

%piece_map(+Piece, -String)
piece_map('S', 'Sorcerer').
piece_map('D', 'Dwarf').
piece_map('T', 'Troll').
piece_map('s', 'Sorcerer').
piece_map('d', 'Dwarf').
piece_map('t', 'Troll').

%column_map(+Column, -Index)
column_map('A', 1).
column_map('B', 2).
column_map('C', 3).
column_map('D', 4).
column_map('E', 5).
column_map('F', 6).
column_map('G', 7).
column_map('H', 8).
column_map('I', 9).
column_map('J', 10).
column_map('K', 11).

%aaaaaaaaaaaa
%can_move(+Piece, +Board, +Position, +Direction)
can_move(_, Board, [X, Y], Direction):-
    direction_map(Direction, [Dx, Dy]),
    Nx is X + Dx,
    Ny is Y + Dy,
    get_piece(Board, [Nx, Ny], Ocupied), !,
    Ocupied = 0.

can_move('Troll', Board, [X, Y], Direction):-
    direction_map(Direction, [Dx, Dy]),
    Nx is X + Dx,
    Ny is Y + Dy,
    get_piece(Board, [Nx, Ny], Ocupied), !,
    format("Ocupied: ~w", [Ocupied]), nl,
    Ocupied = 'R',
    write('troll'),nl.

can_move('Dwarf', Board, [X, Y], Direction):-
    direction_map(Direction, [Dx, Dy]),
    Nx is X + Dx,
    Ny is Y + Dy,
    get_piece(Board, [Nx, Ny], Ocupied), !,
    Ocupied = -1, !, fail.

can_move('Dwarf', Board, [X, Y], Direction):-
    direction_map(Direction, [Dx, Dy]),
    Nx is X + Dx,
    Ny is Y + Dy, !,
    can_move('Dwarf', Board, [Nx,Ny], [Dx, Dy]), !.

%valid_moves(+GameState, +Player, -ListOfMoves)
valid_moves([Board,_], Player, ListOfMoves):-
    findall(Piece, belongs(Player, Piece), PlayerPieces),
    write(PlayerPieces), nl,
    get_player_pieces_info(Board, PlayerPieces, PlayerPiecesInfo),
    write(PlayerPiecesInfo), nl,
    get_moves(Board, PlayerPiecesInfo, ListOfMoves),
    write(ListOfMoves), nl.

%get_player_pieces_info(+Board, +PlayerPieces, -PlayerPiecesInfo)
get_player_pieces_info(_, [], []).
get_player_pieces_info(Board, [Piece | Rest], [[Piece, Position] | RestInfo]):-
    get_position(Board, Piece, Position),
    get_player_pieces_info(Board, Rest, RestInfo).
get_player_pieces_info(Board, [Piece | Rest], RestInfo):-
    \+ get_position(Board, Piece, _),
    get_player_pieces_info(Board, Rest, RestInfo).

%get_moves(+Board, +PlayerPieces, -ListOfMoves)
get_moves(_ ,[], []).
get_moves(Board, [[Piece, [X,Y]] | Rest], ListOfMoves):-
    findall([Piece, [X,Y], Direction], (piece_map(Piece, PieceName), can_move(PieceName, Board, [X, Y], Direction)), PieceMoves),
    get_moves(Rest, RestMoves),
    append(PieceMoves, RestMoves, ListOfMoves).


%get_position(+Board, +Piece, -Position)
get_position(Board, Piece, [X, Y]):-
    get_position_aux(Board, Piece, [_, 1], [X, Y]).

get_position_aux([], _, _, _):- !, fail.
get_position_aux([Row | _], Piece, [_, RowAcc], [X, Y]):-
    check_row(Row, Piece, 1, X),
    Y = RowAcc, !.
get_position_aux([_ | Rest], Piece, [_, RowAcc], [X, Y]):-
    NewRowAcc is RowAcc + 1,
    get_position_aux(Rest, Piece, [1, NewRowAcc], [X, Y]).

%check_row(+Row, +Piece, +ColAcc, -X)
check_row([], _, _, _):- !, fail.
check_row([Piece | _], Piece, ColAcc, ColAcc).
check_row([_ | Rest], Piece, ColAcc, X):-
    NewColAcc is ColAcc + 1,
    check_row(Rest, Piece, NewColAcc, X).


%get_piece(+Board, +Position, -Ocupied)
get_piece(Board, [X, Y], Ocupied):-
    length(Board, Size),
    X > 0, Y > 0, X =< Size, Y =< Size, !,
    nth1(Y, Board, Row),
    nth1(X, Row, Ocupied), !.
    
%init_board(+Size, -Board)
init_board(7, [
    [-1,   -1,   -1,   'R',    -1,   -1,   -1],
    [-1,   -1,   't',  'd',   's',   -1,   -1],
    [-1,    0,    0,    0,      0,    0,   -1],
    ['R',   0,    0,    0,      0,    0,   'R'],
    [-1,    0,    0,    0,      0,    0,   -1],
    [-1,   -1,   'S',  'D',   'T',   -1,   -1],
    [-1,   -1,   -1,   'R',    -1,   -1,   -1]
]).
init_board(9, [
    [-1,   -1,   -1,    -1,    'R',   -1,   -1,   -1,   -1],
    [-1,   -1,   -1,   't',    'd',   's',  -1,   -1,   -1],
    [-1,   -1,    0,    0,      0,     0,    0,   -1,   -1],
    [-1,    0,    0,    0,      0,     0,    0,    0,   -1],
    ['R',   0,    0,    0,      0,     0,    0,    0,   'R'],
    [-1,    0,    0,    0,      0,     0,    0,    0,   -1],
    [-1,   -1,    0,    0,      0,     0,    0,   -1,   -1],
    [-1,   -1,   -1,   'S',    'D',   'T',  -1,   -1,   -1],
    [-1,   -1,   -1,   -1,     'R',   -1,   -1,   -1,   -1]
]).

init_board(11, [
    [-1,   -1,   -1,   -1,     -1,    'R',  -1,   -1,   -1,   -1,   -1],
    [-1,   -1,   -1,   -1,     't',   'd',  's',  -1,   -1,   -1,   -1],
    [-1,   -1,   -1,    0,      0,     0,    0,    0,   -1,   -1,   -1],
    [-1,   -1,    0,    0,      0,     0,    0,    0,    0,   -1,   -1],
    [-1,    0,    0,    0,      0,     0,    0,    0,    0,    0,   -1],
    ['R',   0,    0,    0,      0,     0,    0,    0,    0,    0,   'R'],
    [-1,    0,    0,    0,      0,     0,    0,    0,    0,    0,   -1],
    [-1,   -1,    0,    0,      0,     0,    0,    0,    0,    0,   -1],
    [-1,   -1,   -1,    0,      0,     0,    0,    0,    0,    0,    0],
    [-1,   -1,   -1,   -1,     'S',   'D',  'T',  -1,   -1,   -1,   -1],
    [-1,   -1,   -1,   -1,     -1,    'R',   -1,  -1,   -1,   -1,   -1]
]).
