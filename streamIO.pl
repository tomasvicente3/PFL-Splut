%--------------GENERAL--------------
clear_screen :- write('\33\[2J').

read_option(Min, Max, Option) :-
    repeat,
    write('\nOption: '),
    read_number(Option),
    (between(Min, Max, Option) ->  true ; write('Invalid option! Try again: '), fail).

%--------------MENU--------------

print_logo :-
    write('  ____    ____    _       _   _   _____ '), nl,
    write(' / ___|  |  _ \\  | |     | | | | |_   _|'), nl,
    write(' \\___ \\  | |_) | | |     | | | |   | |  '), nl,
    write('  ___) | |  __/  | |___  | |_| |   | |  '), nl,
    write(' |____/  |_|     |_____|  \\___/    |_|  '), nl, nl.
                                        
print_rules:-
    write('Splut! is a 2-4 players abstract board game that was invented by Tommy\n'), 
    write('De Coninck in 2009. The game is played on a special board with squares\n'), 
    write('forming a diamond shape.\n\n'), 
    write('Each player has three pieces: a Stonetroll, a Dwarf, and a Sorcerer.\n'), 
    write('There are also four Rocks on the board. The goal of the game is to kill all\n'), 
    write('opposing Sorcerers by throwing a Rock on their heads\n\n'),
    write('Each turn, a player must make three steps, except for the first and second\n'),
    write('players on their first turns, who must make one and two steps respectively.\n'),
    write('Each step involves moving one of the player\'s pieces to an adjacent square.\n\n'), 
    write('Different types of pieces have different abilities. A Stonetroll can pull or\n'), 
    write('throw Rocks, a Dwarf can push other pieces, and a Sorcerer can levitate Rocks.\n'), 
    write('Throwing or levitating a Rock ends the player\'s turn immediately.\n\n'),
    write('If a Rock lands on a Sorcerer\'s head, the Sorcerer and his team are eliminated\n'),
    write('from the game. If a Rock lands on a Dwarf\'s head, the Dwarf is removed from the\n'),
    write('board. The game ends when only one player remains or when all players agree to end it.\n\n').

%--------------GAME--------------
display_game(Board) :-
    print_logo,
	write('\n  | A | B | C | D | E | F | G |'), nl,
	write('   ----------------------------'), nl,
	display_board_rows(Board, 1).

display_board_rows([], _).
display_board_rows([Row | Rest], N) :-
	write(N),
	write(' |'),
	display_board_row(Row),
	nl,
	write('   ----------------------------'), nl,
	N1 is N + 1,
	display_board_rows(Rest, N1).

display_board_row([]) :- write('|').
display_board_row([-1 | Rest]) :- write('    '), display_board_row(Rest).
display_board_row([Cell | Rest]) :-
	write(' | '),
	display_cell(Cell),
	display_board_row(Rest).

display_cell(0) :- write(' ').
display_cell(Cell) :- write(Cell).

display_moves(_, 0, _) :- nl.
display_moves([H|T], N, I) :-
    [Piece, [X,Y], Direction] = H,
    piece_map(Piece, PieceName),
    format('~w. ~w(~w) - ~w \n', [I, PieceName, Piece, Direction]),
    N1 is N - 1,
    I1 is I + 1,
    display_moves(T, N1, I1).

%get_direction(+ListOfDirections, -ChosenDirection)
get_direction(ListOfDirections, ChosenDirection):-
    repeat,
    format("Choose a direction to throw the rock: ~w", [ListOfDirections]), nl,
    read_char(Char),
    member(Char, ListOfDirections), !,
    ChosenDirection = Char. 