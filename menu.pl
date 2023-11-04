menu(main) :-
    repeat,
    clear_screen,
    print_logo,
    print_options(main_menu),
    read_option(1, 3, Option),
    option(main_menu, Option).   

print_options(main_menu) :-
    write('1 - Play\n'),
    write('2 - Rules\n'),
    write('3 - Exit\n'). 

option(main_menu, 1) :-
    menu(board_size, Size),
    menu(game_mode),
    initial_state(Size, GameState),
    [Board, _, _] = GameState,
    display_game(Board), !,
    game_loop(GameState, 1).

option(main_menu, 2):-
    repeat,
    clear_screen,
    print_logo,
    print_rules,
    write('Press any key to return to the main menu. '),
    get_char(_),!,
    menu(main).

option(main_menu, 3).

menu(board_size, Size) :-
    repeat,
    clear_screen,
    print_logo,
    print_options(board_size),
    read_option(1, 3, Option),
    option(board_size, Option, Size).  

print_options(board_size) :-
    write('Choose the board size:\n'),
    write('1 - Small (7 rows)\n'),
    write('2 - Medium (9 rows)\n'),
    write('3 - Large (11 rows)\n').

option(board_size, 1, Size) :-
    Size = 7.

option(board_size, 2, Size) :-
    Size = 9.

option(board_size, 3, Size) :-
    Size = 11.

menu(game_mode) :-
    repeat,
    clear_screen,
    print_logo,
    print_options(game_mode),
    read_option(1, 4, Option),
    option(game_mode, Option).

print_options(game_mode) :-
    write('Choose the game mode:\n'),
    write('1 - Player vs Player\n'),
    write('2 - Player vs AI\n'),
    write('3 - AI vs Player\n'),
    write('4 - AI vs AI\n').

option(game_mode, 1) :-
    assertz(human(1)),
    assertz(human(2)).

option(game_mode, 2) :-
    assertz(human(1)),
    menu(computer_difficulty, 2, Difficulty),
    assertz(computer(2, Difficulty)).

option(game_mode, 3) :-
    menu(computer_difficulty, 1, Difficulty),
    assertz(computer(1, Difficulty)),
    assertz(human(2)).

option(game_mode, 4) :-
    menu(computer_difficulty, 1, Difficulty1),
    assertz(computer(1, Difficulty1)),
    menu(computer_difficulty, 2, Difficulty2),
    assertz(computer(2, Difficulty2)).

menu(computer_difficulty, PlayerNum, Difficulty) :-
    repeat,
    clear_screen,
    print_logo,
    print_options(computer_difficulty, PlayerNum),
    read_option(1, 2, Difficulty).

print_options(computer_difficulty, PlayerNum) :-
    format('Choose the AI behaviour for player ~d:\n', [PlayerNum]),
    write('1 - Basic\n'),
    write('2 - Intelligent\n').
