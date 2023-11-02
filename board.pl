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


%get_board_size(-Size)
get_board_size(Size):-
    repeat,
    write('Please choose the board height in squares (an odd number between 7 and 11): '),
    read_number(Size),
    Remainder is mod(Size, 2),
    Remainder =:= 1,
    between(7, 11, Size), !.   

%get_game_mode(-Mode)
get_game_mode(Mode):-
    repeat,
    write('Please choose the game mode (1 - Player vs Player, 2 - Player vs Computer, 3 - Computer vs Computer): '),nl,
    read_number(Mode),
    between(1, 3, Mode), !.

%get_computer_difficulty(-Difficulty)
get_computer_difficulty(Difficulty):-
    repeat,
    write('Please choose the computer behaviour (1 - Random, 2 - Greedy): '),nl,
    read_number(Difficulty),
    between(1, 2, Difficulty), !.

%setup_mode(+Mode)
setup_mode(1):-
    assertz(human(1)),
    assertz(human(2)).
setup_mode(2):-
    assertz(human(1)),
    get_computer_difficulty(Difficulty),
    assertz(computer(2, Difficulty)).
setup_mode(3):-
    get_computer_difficulty(Difficulty1),
    assertz(computer(1, Difficulty1)),
    get_computer_difficulty(Difficulty2),
    assertz(computer(2, Difficulty2)).

%get_players
get_players:-
    get_game_mode(Mode),
    setup_mode(Mode).

get_game_configurations(Size):-
    get_board_size(Size),
    get_players.