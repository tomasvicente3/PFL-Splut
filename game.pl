%game_loop(+GameState, +Player)

%Calls the step function, increments turn, resets steps and changes player
game_loop([Board, Turn, Steps], Player) :-
    step([Board, _, Steps], Player, NewBoard),
    NewTurn is Turn + 1,
    min(NewTurn, 3, NewSteps),
    NewPlayer is 3 - Player,
    game_loop([NewBoard, NewTurn, NewSteps], NewPlayer).

%step(+GameState, +Player, -NewBoard)

%If the game is over, stop
step(GameState,_,_) :- game_over(GameState), !.

%If the player has no steps left, end turn
step([NewBoard, _, 0], _, NewBoard) :- !.

%If the player has steps left, the player chooses the move, the move is made and the game is displayed
step(GameState, Player, NewBoard):-
    [Board, _, Steps] = GameState,
    format("\nPlayer ~w's turn (~w steps left)\n", [Player, Steps]), nl,
    choose_move(Board, Player, Move),
    move(GameState, Move, AccBoard),
    display_game([AccBoard, _, _]),
    NewSteps is Steps - 1,
    step([AccBoard, _, NewSteps], Player, NewBoard).

%choose_move(+Board, +Player, -Move)
%Gets the list of valid moves, displays them and asks the player to choose one
choose_move(Board, Player, Move):-
    human(Player), !,
    valid_moves([Board,_, _], Player, ListOfMoves),
    length(ListOfMoves, Length),
    Length > 0, !,

    write('Choose a move: \n'),
    display_moves(ListOfMoves, Length, 1),

    read_option(1, Length, Option),
    nth1(Option, ListOfMoves, Move).

choose_move(Board, Player, Move):-
    computer(Player, DificultyLevel), !,
    choose_move(Board, Player, DificultyLevel, Move),
    [Piece, _, Direction, _] = Move,
    piece_map(Piece, PieceName),
    format('Computer ~w chose the move: ~w(~w) - ~w \n', [Player, PieceName, Piece, Direction]),
    get_char(_).

%choose_move(+Board, +Player, +DificultyLevel, -Move)
%Given that the player is a computer, chooses a move based on the dificulty level
choose_move(Board, Player, 1, Move):- !,
    valid_moves([Board,_, _], Player, ListOfMoves),
    length(ListOfMoves, Length),
    Length > 0, !,
    custom_random(1, Length, Option),
    nth1(Option, ListOfMoves, Move).

%move(+GameState, +Move, -NewGameState)
%When a dwarf/troll is going to an empty space, move the piece
move([Board, _ ,_], [Piece, [X,Y], Direction, emptySpace], NewBoard):-
    piece_map(Piece, PieceType),
    PieceType \= 'Sorcerer', !,
    direction_map(Direction, [Dx, Dy]),
    Nx is X + Dx, Ny is Y + Dy,
    set_piece(Board, [X,Y], 0, TempBoard),
    set_piece(TempBoard, [Nx, Ny], Piece, NewBoard), !.

%When a Sorcerer is going to an empty space, ask the player if he wants to levitate a rock
move([Board, _ ,_], [Piece, [X,Y], Direction, emptySpace], NewBoard):-
    piece_map(Piece, PieceType),
    PieceType = 'Sorcerer', !,
    direction_map(Direction, [Dx, Dy]),
    Nx is X + Dx, Ny is Y + Dy,
    set_piece(Board, [X,Y], 0, TempBoard),
    set_piece(TempBoard, [Nx, Ny], Piece, TempBoard2),
    belongs(Player, Piece),
    levitate_rock(TempBoard2, Direction, Player, NewBoard), !.

%Upon a trollPull, move the troll and the rock behind him
move([Board, _ ,_], [Piece, [X,Y], Direction, trollPull], NewBoard):-
    direction_map(Direction, [Dx, Dy]),
    Nx is X + Dx, Ny is Y + Dy,
    set_piece(Board, [Nx, Ny], Piece, TempBoard1),
    set_piece(TempBoard1, [X,Y], 'R', TempBoard2),
    opposing_direction(Direction, OppositeDirection),
    direction_map(OppositeDirection, [Dx2, Dy2]),
    Nx2 is X + Dx2, Ny2 is Y + Dy2,
    set_piece(TempBoard2, [Nx2, Ny2], 0, NewBoard), !.

%Uppon a trollThrow, move the troll and throw the rock
move([Board, _ ,_], [Piece, [X,Y], Direction, trollThrow], NewBoard):-
    direction_map(Direction, [Dx, Dy]),
    Nx is X + Dx, Ny is Y + Dy,
    set_piece(Board, [X,Y], 0, TempBoard),
    set_piece(TempBoard, [Nx, Ny], Piece, TempBoard2),
    belongs(Player, Piece),
    throw_rock(TempBoard2, Player, [Nx, Ny], NewBoard), !.

%Uppon a dwarfPush, move the dwarf and pieces in front one space in a given direction
move([Board, _ ,_], [_, [X,Y], Direction, dwarfPush], NewBoard):-
    shift_line(Board, [X,Y], Direction, NewBoard), !.

%game_over(+GameState)
%Checks if the game is over(There's a sorcerer missing)
game_over([Board, _, _]):-
    get_positions(Board, ['S'], Positions),
    Positions = [], !,
    congratulate(2).
game_over([Board, _, _]):-
    get_positions(Board, ['s'], Positions),
    Positions = [], !,
    congratulate(1).

%congratulate(+Winner)
congratulate(Winner):-
    print_congratulations(Winner),
    write('Press any key to return to the main menu.\n'),
    get_char(_),
    menu(main).