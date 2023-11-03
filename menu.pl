%menu(+Option)
%handles user input

main_menu :-
    repeat,
    clear_screen,
    print_logo,
    print_options(main_menu),
    read_option(1, 3, Option),
    option(main_menu, Option).

option(main_menu, 1) :-
    get_game_configurations(Size),
    initial_state(Size, GameState),

    [Board, _, _] = GameState,
    
    clear_screen,
    display_game(Board), !,

    game_loop(GameState, 1).


option(main_menu, 2):-
    repeat,
    clear_screen,
    print_logo,
    print_rules,
    write('Press any key to return to the main menu.\n'),
    get_char(_),
    menu.

option(main_menu, 3).

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
    write('Please choose the game mode \n'),
    write('1 - Player vs Player \n'),
    write('2 - Player vs Computer \n'),
    write('3 - Computer vs Player \n'),
    write('4 - Computer vs Computer'),nl,
    read_number(Mode),
    between(1, 4, Mode), !.

%get_computer_difficulty(-Difficulty)
get_computer_difficulty(Difficulty):-
    repeat,
    write('Please choose the computer behaviour'),
    write('1 - Random\n'),
    write('2 - Greedy)'),nl,
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
