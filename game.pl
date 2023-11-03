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

/*
%step(+GameState, +Player, +CurrentStep, +MaxStep, -NewGameState)
step(FinalGameState,_, Step, Step, FinalGameState).
step(GameState, Player, CurrentStep, MaxStep, FinalGameState):-
    CurrentStep < MaxStep,
    choose_move(GameState, Player, Move),
    move(GameState, Move, NewGameState), !,
    NewStep is CurrentStep + 1,
    step(NewGameState, Player, NewStep, MaxStep, FinalGameState).


%game_cycle(+GameState, +Player)
game_cycle([Board,_], Player):-
    game_over(Board, Winner), !,
    congratulate(Winner).

game_cycle(GameState, Player):-
    [Board, Turns] = GameState,
    min(Turns, 3, MaxSteps),
    step(GameState, Player, 0, MaxSteps, NewGameState),
    
    NextPlayer is mod(Player+1,2)+1,
    NextTurns is Turns + 1,
    [NewBoard, NextTurns] = NewerGameState,
    display_game(NewGameState), !,
    game_cycle(NewerGameState, NextPlayer).


%game_over(+GameState, -Winner)
game_over(Board, Winner):-. % TODO

%choose_move(+Board, +Player, -Move)
%jogador escolhe jogada
choose_move(GameState, human, Move):-
% interaction to select move TODO


%choose_move(+Board, +Player, +ComputerLevel, -Move)
%computador escolhe jogada
choose_move(Board, Player, ComputerLevel, Move):-
    valid_moves(GameState, Moves),
    choose_move(Level, GameState, Moves, Move).

/** trocar o choose move aqui? Está nos slides mas não no enunciado aqui está choose_move(Level, GameState, Moves, Move)**//*
choose_move(Board, Player, 1, Move):-
    random_select(Move, Moves, _Rest).

choose_move(Board, Player, 2, Move):-
    setof(Value-Mv, NewState^( member(Mv, Moves),
    move(GameState, Mv, NewState),
    value(NewState, Player, Value) ), [_V-Move|_]).
% value assumes lower value is better

%move(+GameState, +Move, -NewGameState).
move([Board, Turns], Move, [NewBoard, NewTurns]):-. %TODO

%value(+GameState, +Player, -Value)
value([Board, Turns], Player, Value):-.
*/