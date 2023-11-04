game_loop(GameState, _) :-
    game_over(GameState), !.

game_loop([Board, Turn, Steps], Player) :-
    step([Board, _, Steps], Player, NewBoard),
    NewTurn is Turn + 1,
    min(NewTurn, 3, NewSteps),
    NewPlayer is 3 - Player,
    game_loop([NewBoard, NewTurn, NewSteps], NewPlayer).

step([NewBoard, _, 0], _, NewBoard) :- !.
step([Board, _, Steps], Player, NewBoard):-
    format("\nPlayer ~w's turn (~w steps left)\n", [Player, Steps]), nl,
    choose_move(Board, Player, Move),
    move(Board, Move, AccBoard),
    clear_screen,
    display_game(AccBoard),
    NewSteps is Steps - 1,
    step([AccBoard, _, NewSteps], Player, NewBoard).

choose_move(Board, Player, Move):-
    valid_moves([Board,_, _], Player, ListOfMoves),
    write('Choose a move: \n'),

    length(ListOfMoves, Length),
    display_moves(ListOfMoves, Length, 1),

    read_option(1, Length, Option),
    nth1(Option, ListOfMoves, Move).

move(Board, [Piece, [X,Y], Direction], NewBoard):-
    direction_map(Direction, [Dx, Dy]),
    Nx is X + Dx, Ny is Y + Dy,
    get_piece(Board, [Nx, Ny], Ocupied),
    Ocupied = 0, !,
    set_piece(Board, [X,Y], 0, TempBoard),
    set_piece(TempBoard, [Nx, Ny], Piece, NewBoard).

move(Board, [Piece, [X,Y], Direction], NewBoard):-
    direction_map(Direction, [Dx, Dy]),
    Nx is X + Dx, Ny is Y + Dy,
    get_piece(Board, [Nx, Ny], Ocupied),
    piece_map(Piece, PieceType),
    Ocupied = 'R', PieceType = 'Troll', !,
    set_piece(Board, [X,Y], 0, TempBoard),
    set_piece(TempBoard, [Nx, Ny], Piece, TempBoard2),
    throw_rock(TempBoard2, [Nx, Ny], NewBoard), !.

game_over([Board, _, _]):-
    \+ get_position(Board, 'S', _), !,
    congratulate(2).
game_over([Board, _, _]):-
    \+ get_position(Board, 's', _), !,
    congratulate(1).

congratulate(Winner):-
    format(" You win!\nCongratulations, Player ~w!",[Winner]), nl,
    write('Press any key to return to the main menu.\n'),
    get_char(_),
    menu(main).