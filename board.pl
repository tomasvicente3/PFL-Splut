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

%opposing_direction(?Direction1, ?Direction2)
opposing_direction('N', 'S').
opposing_direction('S', 'N').
opposing_direction('E', 'W').
opposing_direction('W', 'E').

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

%in_bounds(+Board, +Position)
in_bounds(Board, [X,Y]):-
    X > 0, Y > 0,
    length(Board, Size),
    X =< Size, Y =< Size.

%can_be_thrown_through(+Piece)
can_be_thrown_through(0).
can_be_thrown_through('D').
can_be_thrown_through('d').

%stops_rock(+Piece)
stops_rock(-1).
stops_rock('R').
stops_rock('T').
stops_rock('t').

%can_move(+Piece, +Board, +Position, +Direction)
%checks if a piece can move in a certain direction
can_move('Troll', Board, [X, Y], Direction):-
    direction_map(Direction, [Dx, Dy]),
    Nx is X + Dx,
    Ny is Y + Dy,
    get_piece(Board, [Nx, Ny], Ocupied), !,
    (Ocupied = 'R'; Ocupied=0), !.

can_move('Dwarf', Board, [X, Y], Direction):-
    direction_map(Direction, [Dx, Dy]),
    Nx is X + Dx,
    Ny is Y + Dy,
    get_piece(Board, [Nx, Ny], Ocupied), !,
    (Ocupied = 0; can_move('Dwarf', Board, [Nx,Ny], Direction)), !.

can_move('Sorcerer', Board, [X, Y], Direction):-
    direction_map(Direction, [Dx, Dy]),
    Nx is X + Dx,
    Ny is Y + Dy,
    get_piece(Board, [Nx, Ny], Ocupied), !,
    Ocupied=0.

%can_throw(+Board, +Position, +Direction)
can_throw(Board, [X, Y], Direction):-
    direction_map(Direction, [Dx, Dy]),
    Nx is X + Dx, Ny is Y + Dy,
    get_piece(Board, [Nx, Ny], Ocupied),
    can_be_thrown_through(Ocupied), !.

%throw_rock(+Board, +Position, -NewBoard)
throw_rock(Board, [X,Y], NewBoard):-
    Directions = ['N', 'E', 'S', 'W'],
    findall(Direction, (member(Direction, Directions), can_throw(Board, [X,Y], Direction)), ListOfDirections),!,
    get_direction(ListOfDirections, ChosenDirection),
    direction_map(ChosenDirection, [Dx, Dy]),
    Nx is X + Dx, Ny is Y + Dy,
    flying_rock(Board, [Nx,Ny], ChosenDirection, NewBoard).

%flying_rock(+Board, +Position, +Direction, -NewBoard)
flying_rock(Board, [X,Y], Direction, NewBoard):-
    direction_map(Direction, [Dx, Dy]),
    Nx is X + Dx, Ny is Y + Dy,
    \+ in_bounds(Board, [Nx,Ny]), !,
    set_piece(Board, [X,Y], 'R', NewBoard).

flying_rock(Board, [X,Y], Direction, NewBoard):-
    direction_map(Direction, [Dx, Dy]),
    Nx is X + Dx, Ny is Y + Dy,
    get_piece(Board, [Nx, Ny], NextPiece),
    stops_rock(NextPiece), !,
    set_piece(Board, [X,Y], 'R', NewBoard).

flying_rock(Board, [X,Y], Direction, NewBoard):-
    direction_map(Direction, [Dx, Dy]),
    Nx is X + Dx, Ny is Y + Dy,
    get_piece(Board, [Nx, Ny], NextPiece),
    piece_map(NextPiece, PieceName), PieceName = 'Sorcerer', !,
    set_piece(Board, [Nx,Ny], 'R', NewBoard).

flying_rock(Board, [X,Y], Direction, NewBoard):-
    direction_map(Direction, [Dx, Dy]),
    Nx is X + Dx, Ny is Y + Dy,
    get_piece(Board, [Nx, Ny], NextPiece),
    \+ stops_rock(NextPiece), in_bounds(Board, [Nx,Ny]), !,
    flying_rock(Board, [Nx, Ny], Direction, NewBoard).

%valid_moves(+GameState, +Player, -ListOfMoves)
valid_moves([Board,_, _], Player, ListOfMoves):-
    findall(Piece, belongs(Player, Piece), PlayerPieces),
    %write(PlayerPieces), nl,
    get_player_pieces_info(Board, PlayerPieces, PlayerPiecesInfo),
    %write(PlayerPiecesInfo), nl,
    get_moves(Board, PlayerPiecesInfo, ListOfMoves).
    %write(ListOfMoves), nl.

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
    %format("Piece: ~w, Position: ~w", [Piece, [X,Y]]), nl,
    Directions = ['N', 'E', 'S', 'W'],
    findall([Piece, [X,Y], Direction], (member(Direction, Directions), piece_map(Piece, PieceName), can_move(PieceName, Board, [X, Y], Direction)), PieceMoves),
    get_moves(Board, Rest, RestMoves),
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
    
%set_piece(+Board, +Position, +Piece, -NewBoard)
set_piece(Board, [X,Y], Piece, NewBoard):-
    set_piece_aux(Board, [X,Y], Piece, 1, NewBoard).

set_piece_aux([Row | Rest], [X, Y], Piece, Y, [NewRow | Rest]):-
    replace_at_row(Row, X, Piece, NewRow), !.
set_piece_aux([Row | Rest], [X, Y], Piece, CurrY, [Row | NewRest]):-
    CurrY < Y,
    NextY is CurrY + 1,
    set_piece_aux(Rest, [X, Y], Piece, NextY, NewRest).

%replace_at_row(+Row, +Index, +Piece, -NewRow)
replace_at_row(Row, Index, Piece, NewRow):- replace_at_row_aux(Row, Index, Piece, 1, NewRow).

replace_at_row_aux([_ | Rest], Index, Piece, Index, [Piece | Rest]).
replace_at_row_aux([H | T], Index, Piece, CurrIdx, [H| NewT]):-
    CurrIdx < Index,
    NextIdx is CurrIdx + 1,
    replace_at_row_aux(T, Index, Piece, NextIdx, NewT).



%initial_state(+Size, -GameState)
initial_state(Size, [Board, Turns, Steps]):-
    Turns = 1,
    init_board(Size, Board), 
    min(Turns, 3, Steps), !.

%[[-1,-1,-1,'R',-1,-1,-1],[-1,-1,'t','d','s',-1,-1],[-1,0,0,0,0,0,-1],['R',0,0,0,0,0,'R'],[-1,0,0,0,0,0,-1],[-1,-1,'S','D','T',-1,-1],[-1,-1,-1,'R',-1,-1,-1]]
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
