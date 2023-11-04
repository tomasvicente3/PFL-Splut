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
    length(Board, Length),
    display_header(Length),
    display_bar(Length),
	display_board_rows(Board, 1, Length).

display_header(Length):-
    write('\n   '),
    display_header_aux(Length, 1).

display_header_aux(Length, Index) :- Index > Length, !, write('|\n').
display_header_aux(Length, Index) :-
    write('| '),
    get_index_letter(Index, Letter),
    write(Letter),
    write(' '),
    I1 is Index + 1,
    display_header_aux(Length, I1).

display_bar(Length):-
    write('   '),
    display_bar_aux(Length, 1).

display_bar_aux(Length, Index) :- Index > Length, !, write('-\n').
display_bar_aux(Length, Index) :-
    write('----'),
    I1 is Index + 1,
    display_bar_aux(Length, I1).


display_board_rows([], _, _) :- write('|\n').

display_board_rows([Row | Rest], N, Length) :-
    format('~w ', [N]),
    (N < 10 -> write(' '); true),
	display_board_row(Row),
    display_bar(Length),
	N1 is N + 1,
	display_board_rows(Rest, N1, Length).

display_board_row([]) :- write('|\n').

display_board_row([-1 | Rest]) :- write('    '), display_board_row(Rest).
display_board_row([Cell | Rest]) :-
	write('| '),
	display_cell(Cell),
    write(' '),
	display_board_row(Rest).

display_cell(0) :- write(' ').
display_cell(Cell) :- write(Cell).

display_moves(_, 0, _) :- nl.
display_moves([H|T], N, I) :-
    [Piece, [X,Y], Direction] = H,
    piece_map(Piece, PieceType),
    format('~w. ~w(~w) - ~w \n', [I, PieceType, Piece, Direction]),
    N1 is N - 1,
    I1 is I + 1,
    display_moves(T, N1, I1).

display_directions(_, 0, _) :- nl.
display_directions([Direction|T], N, I) :-
    format('~w. ~w \n', [I, Direction]),
    N1 is N - 1,
    I1 is I + 1,
    display_directions(T, N1, I1).

choose_direction(ListOfDirections, ChosenDirection):-
    length(ListOfDirections, Length),
    display_directions(ListOfDirections, Length, 1),
    read_option(1, Length, Option),
    nth1(Option, ListOfDirections, ChosenDirection).