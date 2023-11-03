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
    piece_map(Piece, PieceName),
    Ocupied = 'R', PieceName = 'Troll', !,
    set_piece(Board, [X,Y], 0, TempBoard),
    set_piece(TempBoard, [Nx, Ny], Piece, TempBoard2),
    throw_rock(TempBoard2, [Nx, Ny], NewBoard), !.

step([_, _, 0], _, _) :- !.

step([Board, _, Steps], Player, NewBoard):-
    format("Player ~w's turn (~w steps left)\n", [Player, Steps]), nl,
    choose_move(Board, Player, Move),
    clear_screen,
    move(Board, Move, NewBoard),
    display_game(NewBoard),
    NewSteps is Steps - 1,
    step([NewBoard, _, NewSteps], Player, _).

game_loop(GameState, _) :-
    game_over(GameState), !.

game_loop(GameState, Player) :-
    [Board, Turn, Steps] = GameState,
    step([Board, _, Steps], Player, NewBoard),
    NewTurn is Turn + 1,
    min(NewTurn, 3, NewSteps),
    NewPlayer is 3 - Player,
    game_loop([NewBoard, NewTurn, NewSteps], NewPlayer).

%game_over(+GameState)
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
    menu.