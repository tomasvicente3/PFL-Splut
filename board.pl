%initial_state(+Size, -GameState)
initial_state(Size, [Board, 1, 1]):-
    init_board(Size, Board), !.

%can_move(+Piece, +Board, +Position, +Direction, -MoveType)
%Every piece can move to an empty space
can_move(_, Board, [X, Y], Direction, emptySpace):-
    direction_map(Direction, [Dx, Dy]),
    Nx is X + Dx,
    Ny is Y + Dy,
    get_piece(Board, [Nx, Ny], Ocupied),
    Ocupied = 0.

%A Troll can move to an empty space and pull the rock behind it
can_move('Troll', Board, [X, Y], Direction, trollPull) :-
    direction_map(Direction, [Dx, Dy]),
    Nx is X + Dx,
    Ny is Y + Dy,
    get_piece(Board, [Nx, Ny], Ocupied),
    Ocupied = 0,
    opposing_direction(Direction, OpposingDirection),
    direction_map(OpposingDirection, [ODx, ODy]),
    Ox is X + ODx,
    Oy is Y + ODy,
    get_piece(Board, [Ox, Oy], Ocupied2),
    Ocupied2 = 'R'.

%A troll can move to a location and throw a rock as long as it can be thrown
can_move('Troll', Board, [X, Y], Direction, trollThrow) :-
    direction_map(Direction, [Dx, Dy]),
    Nx is X + Dx,
    Ny is Y + Dy,
    get_piece(Board, [Nx, Ny], Ocupied),
    Ocupied = 'R',
    set_piece(Board, [X,Y], 0, NewBoard),

    can_throw_rock(NewBoard, [Nx, Ny]).

%A dwarf can move to an occupied space as long as it can shift every piece in front
can_move('Dwarf', Board, [X, Y], Direction, dwarfPush) :-
    direction_map(Direction, [Dx, Dy]),
    Nx is X + Dx,
    Ny is Y + Dy,
    get_piece(Board, [Nx, Ny], Ocupied),
    Ocupied \= 0,
    can_push(Board, [Nx, Ny], Direction).

%Check if a rock can be thrown from a position
can_throw_rock(Board, [X, Y]):-
    Directions = ['UP', 'RIGHT', 'DOWN', 'LEFT'],
    findall(Direction, (member(Direction, Directions), can_throw(Board, [X,Y], Direction)), ListOfDirections),!,
    length(ListOfDirections, Length),
    Length > 0.

%Check if we can shift every piece in a certain direction starting from a position
can_push(Board, [X, Y], Direction):-
    direction_map(Direction, [Dx, Dy]),
    Nx is X + Dx,
    Ny is Y + Dy,
    get_piece(Board, [Nx, Ny], Ocupied), !,
    (Ocupied = 0; can_move('Dwarf', Board, [Nx,Ny], Direction, _)), !.

%valid_moves(+GameState, +Player, -ListOfMoves)
valid_moves([Board,_, _], Player, ListOfMoves):-
    findall(Piece, belongs(Player, Piece), PlayerPieces),
    get_player_pieces_info(Board, PlayerPieces, PlayerPiecesInfo),
    get_moves(Board, PlayerPiecesInfo, ListOfMoves).

%get_moves(+Board, +PlayerPieces, -ListOfMoves)
get_moves(_ ,[], []).
get_moves(Board, [[Piece, [X,Y]] | Rest], ListOfMoves):-
    Directions = ['UP', 'RIGHT', 'DOWN', 'LEFT'],
    findall([Piece, [X,Y], Direction, MoveType], (member(Direction, Directions), piece_map(Piece, PieceType), can_move(PieceType, Board, [X, Y], Direction, MoveType)), PieceMoves),
    get_moves(Board, Rest, RestMoves),
    append(PieceMoves, RestMoves, ListOfMoves).

%get_player_pieces_info(+Board, +PlayerPieces, -PlayerPiecesInfo)
%Obtains a list of pieces and their positions
get_player_pieces_info(_, [], []).
get_player_pieces_info(Board, [Piece | Rest], [[Piece, Position] | RestInfo]):-
    get_position(Board, Piece, Position),
    get_player_pieces_info(Board, Rest, RestInfo).
get_player_pieces_info(Board, [Piece | Rest], RestInfo):-
    \+ get_position(Board, Piece, _),
    get_player_pieces_info(Board, Rest, RestInfo).


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

%can_throw(+Board, +Position, +Direction)
can_throw(Board, [X, Y], Direction):-
    direction_map(Direction, [Dx, Dy]),
    Nx is X + Dx, Ny is Y + Dy,
    get_piece(Board, [Nx, Ny], Ocupied),
    can_be_thrown_through(Ocupied), !.

%in_bounds(+Board, +Position)
in_bounds(Board, [X,Y]):-
    X > 0, Y > 0,
    length(Board, Size),
    X =< Size, Y =< Size.

%throw_rock(+Board, +Position, -NewBoard)
throw_rock(Board, [X,Y], NewBoard):-
    Directions = ['UP', 'RIGHT', 'DOWN', 'LEFT'],
    findall(Direction, (member(Direction, Directions), can_throw(Board, [X,Y], Direction)), ListOfDirections),!,
    write('\nChoose a direction to throw the rock: \n'),
    choose_direction(ListOfDirections, ChosenDirection),
    direction_map(ChosenDirection, [Dx, Dy]),
    Nx is X + Dx, Ny is Y + Dy,
    flying_rock(Board, [Nx,Ny], ChosenDirection, NewBoard).

%flying_rock(+Board, +Position, +Direction, -NewBoard)
%If the next position is out of bounds, the rock stops
flying_rock(Board, [X,Y], Direction, NewBoard):-
    direction_map(Direction, [Dx, Dy]),
    Nx is X + Dx, Ny is Y + Dy,
    \+ in_bounds(Board, [Nx,Ny]), !,
    set_piece(Board, [X,Y], 'R', NewBoard).

%If the  next pos is a piece that stops the rock, the rock stops
flying_rock(Board, [X,Y], Direction, NewBoard):-
    direction_map(Direction, [Dx, Dy]),
    Nx is X + Dx, Ny is Y + Dy,
    get_piece(Board, [Nx, Ny], NextPiece),
    stops_rock(NextPiece), !,
    set_piece(Board, [X,Y], 'R', NewBoard).

%If the next pos is a sorcerer, the rock stops and the sorcerer dies
flying_rock(Board, [X,Y], Direction, NewBoard):-
    direction_map(Direction, [Dx, Dy]),
    Nx is X + Dx, Ny is Y + Dy,
    get_piece(Board, [Nx, Ny], NextPiece),
    piece_map(NextPiece, PieceType), PieceType = 'Sorcerer', !,
    set_piece(Board, [Nx,Ny], 'R', NewBoard).

%If the next pos is unoccupied or occupied by a piece that doesn't stop the rock, the rock keeps flying
flying_rock(Board, [X,Y], Direction, NewBoard):-
    direction_map(Direction, [Dx, Dy]),
    Nx is X + Dx, Ny is Y + Dy,
    get_piece(Board, [Nx, Ny], NextPiece),
    \+ stops_rock(NextPiece), in_bounds(Board, [Nx,Ny]), !,
    flying_rock(Board, [Nx, Ny], Direction, NewBoard).

shift_line(Board, [X, Y], Direction, NewBoard) :-
    get_push_lenght(Board, [X, Y], Direction, Length),
    shift_line_aux(Board, [X, Y], Direction, NewBoard, Length).

shift_line_aux(Board, [X, Y], Direction, NewBoard, 0) :-
    set_piece(Board, [X, Y], 0, NewBoard), !.

shift_line_aux(Board, [X, Y], Direction, NewBoard, Length) :-
    Length > 0,
    direction_map(Direction, [Dx, Dy]),

    multiply_direction(Direction, Length-1, [Dx2, Dy2]),
    Nx is X + Dx2, Ny is Y + Dy2,
    get_piece(Board, [Nx, Ny], Piece),

    multiply_direction(Direction, Length, [Dx3, Dy3]),
    Nx2 is X + Dx3, Ny2 is Y + Dy3,
    set_piece(Board, [Nx2, Ny2], Piece, TempBoard),

    NewLength is Length - 1,
    shift_line_aux(TempBoard, [X, Y], Direction, NewBoard, NewLength).
    
get_push_lenght(Board, [X, Y], Direction, Length) :-
    get_push_lenght_aux(Board, [X, Y], Direction, 1, Length).

get_push_lenght_aux(Board, [X, Y], Direction, LengthSoFar, Length) :-
    direction_map(Direction, [Dx, Dy]),
    Nx is X + Dx,
    Ny is Y + Dy,
    get_piece(Board, [Nx, Ny], Piece),
    Piece \= 0,
    NewLength is LengthSoFar + 1,
    get_push_lenght_aux(Board, [Nx, Ny], Direction, NewLength, Length).

get_push_lenght_aux(Board, [X, Y], Direction, LengthSoFar, LengthSoFar) :-
    direction_map(Direction, [Dx, Dy]),
    Nx is X + Dx,
    Ny is Y + Dy,
    get_piece(Board, [Nx, Ny], Piece),
    Piece = 0, !.


multiply_direction(Direction, Length, [Dx, Dy]) :-
    direction_map(Direction, [Dx1, Dy1]),
    Dx is Dx1 * Length,
    Dy is Dy1 * Length.

% get_positions(+Board, +Piece, -Positions)
get_rock_positions(Board, Positions) :-
    findall([X,Y], (nth1(Y, Board, Row), nth1(X, Row, 'R')), Positions).


levitate_rock(Board, Direction, NewBoard) :-
    direction_map(Direction, [Dx, Dy]),
    get_rock_positions(Board, Positions),
    findall([X, Y], (member([X, Y], Positions), X2 is X + Dx, Y2 is Y + Dy, get_piece(Board, [X2, Y2], Piece), Piece = 0), LevitatingRocks),
    length(LevitatingRocks, Length),
    Length > 0, !,
    write('Do you want to levitate a rock? \n'),
    write('1. Yes \n'),
    write('2. No \n'),
    read_option(1, 2, UserResponse),
    (UserResponse = 1 ->
        write('Choose a rock to levitate: \n'),
        choose_levitating_rock(LevitatingRocks, ChosenRockIndex),
        nth1(ChosenRockIndex, LevitatingRocks, [RX, RY]),
        set_piece(Board, [RX, RY], 0, TempBoard),
        NX is RX + Dx, NY is RY + Dy,
        set_piece(TempBoard, [NX, NY], 'R', NewBoard)
    ; 
        NewBoard = Board
    ).

levitate_rock(Board, _, Board).