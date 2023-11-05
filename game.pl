game_loop([Board, Turn, Steps], Player) :-
    step([Board, _, Steps], Player, NewBoard),
    NewTurn is Turn + 1,
    min(NewTurn, 3, NewSteps),
    NewPlayer is 3 - Player,
    game_loop([NewBoard, NewTurn, NewSteps], NewPlayer).

step(GameState,_,_) :- game_over(GameState), !.
step([NewBoard, _, 0], _, NewBoard) :- !.

step([Board, _, Steps], Player, NewBoard):-
    format("\nPlayer ~w's turn (~w steps left)\n", [Player, Steps]), nl,
    choose_move(Board, Player, Move),
    move(Board, Move, AccBoard),
    display_game(AccBoard),
    NewSteps is Steps - 1,
    step([AccBoard, _, NewSteps], Player, NewBoard).

choose_move(Board, Player, Move):-
    valid_moves([Board,_, _], Player, ListOfMoves),
    length(ListOfMoves, Length),
    Length > 0, !,
    %format("ListOfMoves: ~w\n", [ListOfMoves]), nl,

    write('Choose a move: \n'),
    display_moves(ListOfMoves, Length, 1),

    read_option(1, Length, Option),
    nth1(Option, ListOfMoves, Move).
    

move(Board, [Piece, [X,Y], Direction, emptySpace], NewBoard):-
    direction_map(Direction, [Dx, Dy]),
    Nx is X + Dx, Ny is Y + Dy,
    set_piece(Board, [X,Y], 0, TempBoard),
    set_piece(TempBoard, [Nx, Ny], Piece, NewBoard).


move(Board, [Piece, [X,Y], Direction, trollPull], NewBoard):-
    direction_map(Direction, [Dx, Dy]),
    Nx is X + Dx, Ny is Y + Dy,
    set_piece(Board, [Nx, Ny], Piece, TempBoard1),
    set_piece(TempBoard1, [X,Y], 'R', TempBoard2),
    opposing_direction(Direction, OppositeDirection),
    direction_map(OppositeDirection, [Dx2, Dy2]),
    Nx2 is X + Dx2, Ny2 is Y + Dy2,
    set_piece(TempBoard2, [Nx2, Ny2], 0, NewBoard), !.

move(Board, [Piece, [X,Y], Direction, trollThrow], NewBoard):-
    direction_map(Direction, [Dx, Dy]),
    Nx is X + Dx, Ny is Y + Dy,
    get_piece(Board, [Nx, Ny], Ocupied),
    piece_map(Piece, PieceType),
    set_piece(Board, [X,Y], 0, TempBoard),
    set_piece(TempBoard, [Nx, Ny], Piece, TempBoard2),
    throw_rock(TempBoard2, [Nx, Ny], NewBoard), !.

move(Board, [Piece, [X,Y], Direction, dwarfPush], NewBoard):-
    format("move(~w, [~w, [~w,~w], ~w, dwarfPush], NewBoard).\n", [Board, Piece, X, Y, Direction]),
    format("shift_line(~w, [~w, ~w], ~w, NewBoard).\n", [Board, X, Y, Direction]),
    shift_line(Board, [X,Y], Direction, NewBoard), 
    format("NewBoard: ~w\n", [NewBoard]),
    !.

shift_line(Board, [X, Y], Direction, NewBoard) :-
    get_push_lenght(Board, [X, Y], Direction, Length),
    format("shift_line(~w, [~w, ~w], ~w, NewBoard).\n", [Board, X, Y, Direction]),
    shift_line_aux(Board, [X, Y], Direction, NewBoard, Length).

%The idea of my shift_line_aux(+Board, +Position, +Direction, -NewBoard, +Length) is to shift the line every cell from the position to (position + length * direction). To do so it starts by shifting the last cell, then the second to last and so on until it reaches the first cell(Lenght = 0)
shift_line_aux(Board, [X, Y], Direction, NewBoard, 0) :-
    %Base case, put a 0 in position [X, Y]
    set_piece(Board, [X, Y], 0, NewBoard), !.

shift_line_aux(Board, [X, Y], Direction, NewBoard, Length) :-
    %Recursive case, put the last piece([X, Y]+[Direction * Length]) in position [X, Y]+[Direction * Length + 1] and call shift_line_aux with Length - 1
    Length > 0,
    multiply_direction(Direction, Length, [Dx, Dy]),

    FromX is X + Dx,
    FromY is Y + Dy,

    ToX is X + Dx * 2,
    ToY is Y + Dy * 2,

    get_piece(Board, [FromX, FromY], Piece),
    set_piece(Board, [ToX, ToY], Piece, TempBoard),
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

game_over([Board, _, _]):-
    \+ get_position(Board, 'S', _), !,
    congratulate(2).
game_over([Board, _, _]):-
    \+ get_position(Board, 's', _), !,
    congratulate(1).

congratulate(Winner):-
    print_congratulations(Winner),
    write('Press any key to return to the main menu.\n'),
    get_char(_),
    menu(main).

