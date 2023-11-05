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

    write('Choose a move: \n'),
    display_moves(ListOfMoves, Length, 1),

    read_option(1, Length, Option),
    nth1(Option, ListOfMoves, Move).

move(Board, [Piece, [X,Y], Direction, emptySpace], NewBoard):-
    piece_map(Piece, PieceType),
    PieceType \= 'Sorcerer', !,
    direction_map(Direction, [Dx, Dy]),
    Nx is X + Dx, Ny is Y + Dy,
    set_piece(Board, [X,Y], 0, TempBoard),
    set_piece(TempBoard, [Nx, Ny], Piece, NewBoard), !.

%When its a sorcerer going to an empty space
move(Board, [Piece, [X,Y], Direction, emptySpace], NewBoard):-
    piece_map(Piece, PieceType),
    PieceType = 'Sorcerer', !,
    direction_map(Direction, [Dx, Dy]),
    Nx is X + Dx, Ny is Y + Dy,
    set_piece(Board, [X,Y], 0, TempBoard),
    set_piece(TempBoard, [Nx, Ny], Piece, TempBoard2),
    levitate_rock(TempBoard2, Direction, NewBoard), !.

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
    shift_line(Board, [X,Y], Direction, NewBoard), !.

game_over([Board, _, _]):-
    get_positions(Board, ['S'], Positions),
    Positions = [], !,
    congratulate(2).
game_over([Board, _, _]):-
    get_positions(Board, ['s'], Positions),
    Positions = [], !,
    congratulate(1).

congratulate(Winner):-
    print_congratulations(Winner),
    write('Press any key to return to the main menu.\n'),
    get_char(_),
    menu(main).