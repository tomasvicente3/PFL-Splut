:- consult('utils.pl').
:- consult('board.pl').
:- consult('visuals.pl').
/*
%initial_state(+Size, -GameState)
initial_state(Size, GameState-Player):-
    .%TODO

%display_game(+GameState)
display_game(GameState-Player):-. % TODO

%game_cycle(+GameState)
game_cycle(GameState-Player):-
    game_over(GameState, Winner), !,
    congratulate(Winner).

game_cycle(GameState-Player):-
    choose_move(GameState, Player, Move),
    move(GameState, Move, NewGameState),
    next_player(Player, NextPlayer),
    display_game(NewGameState-NextPlayer), !,
    game_cycle(NewGameState-NextPlayer).


%game_over(+GameState, -Winner)
game_over(GameState, Winner):-. % TODO


choose_move(GameState, human, Move):-
% interaction to select move TODO

choose_move(GameState, computer-Level, Move):-
    valid_moves(GameState, Moves),
    choose_move(Level, GameState, Moves, Move).

%valid_moves(+GameState, +Player, -ListOfMoves)
valid_moves(GameState, Player, ListOfMoves):-
    findall(Move, move(GameState, Move, NewState), Moves).

/** trocar o choose move aqui? Está nos slides mas não no enunciado aqui está choose_move(Level, GameState, Moves, Move)**//*
choose_move(1, _GameState, Moves, Move):-
    random_select(Move, Moves, _Rest).

choose_move(2, GameState, Moves, Move):-
    setof(Value-Mv, NewState^( member(Mv, Moves),
    move(GameState, Mv, NewState),
    value(NewState, Player, Value) ), [_V-Move|_]).
% value assumes lower value is better

%move(+GameState, +Move, -NewGameState).
move(GameState, Move, NewGameState):-. %TODO

%value(+GameState, +Player, -Value)
value(GameState, Player, Value):-.


%choose_move(+GameState, +Player, +Level, -Move)
choose_move(GameState, Player, Level, Move):-.
*/

play:-
    get_game_configurations(Size),
    initial_state(Size, GameState-Player),
    display_game(GameState-Player),
    game_cycle(GameState-Player).
