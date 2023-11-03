%menu(+Option)
%handles user input

menu :-
    repeat,
    clear_screen,
    print_logo,
    print_options,
    read_number(Option),
    between(1,3,Option), !,
    firstMenu(Option).

print_options :-
    write('1 - Play\n'),
    write('2 - Rules\n'),
    write('3 - Exit\n').

firstMenu(1):-
    get_game_configurations(Size),
    initial_state(Size, GameState),

    [Board, _, _] = GameState,
    display_game(Board), !,

    game_loop(GameState, 1).


firstMenu(2):-
    repeat,
    clear_screen,
    print_logo,
    print_rules,
    write('Press any key to return to the main menu.\n'),
    get_char(_),
    menu.

firstMenu(3).

get_game_configurations(Size):-
    get_board_size(Size),
    get_game_mode(Mode),
    setup_mode(Mode).

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
    write('Please choose the game mode \n 1 - Player vs Player \n 2 - Player vs Computer \n 3 - Computer vs Player \n 4 - Computer vs Computer'),nl,
    read_number(Mode),
    between(1, 4, Mode), !.

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
    get_computer_difficulty(Difficulty),
    assertz(computer(1, Difficulty)),
    assertz(human(2)).
setup_mode(4):-
    get_computer_difficulty(Difficulty1),
    assertz(computer(1, Difficulty1)),
    get_computer_difficulty(Difficulty2),
    assertz(computer(2, Difficulty2)).
