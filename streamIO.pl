%--------------GENERAL--------------
%clear_screen/0
clear_screen :- write('\33\[2J').

%read_option(+Min, +Max, -Option)
%Reads an option from the user, between Min and Max
read_option(Min, Max, Option) :-
    repeat,
    write('\nOption: '),
    read_number(Option),
    (between(Min, Max, Option) ->  true ; write('Invalid option! Try again: '), fail).

%--------------MENU--------------
%print_menu/0
print_logo :-
    write('  ____    ____    _       _   _   _____ '), nl,
    write(' / ___|  |  _ \\  | |     | | | | |_   _|'), nl,
    write(' \\___ \\  | |_) | | |     | | | |   | |  '), nl,
    write('  ___) | |  __/  | |___  | |_| |   | |  '), nl,
    write(' |____/  |_|     |_____|  \\___/    |_|  '), nl, nl.

%print_menu/0                                
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
%display_game(+Board)
display_game(Board) :-
    clear_screen,
    length(Board, Length),
    display_header(Length),
    display_bar(Length),
	display_board(Board, 1, Length).

%display_header(+Length)
%Displays the numbers of the columns separated by bars
display_header(Length):-
    write('\n   '),
    display_header_aux(Length, 1).

%display_header_aux(+Length, +Index)
%Recursive preditate that while Index is less than Length, displays the number of the column and increments Index
display_header_aux(Length, Index) :- Index > Length, !, write('|\n').
display_header_aux(Length, Index) :-
    write('| '),
    write(Index),
    write(' '),
    I1 is Index + 1,
    display_header_aux(Length, I1).

%display_bar(+Length)
%Prints 4 spaces and ---- for each column
display_bar(Length):-
    write('   '),
    display_bar_aux(Length, 1).

%display_bar_aux(+Length, +Index)
%Recursive preditate that while Index is less than Length, writes ---- and increments Index
display_bar_aux(Length, Index) :- Index > Length, !, write('-\n').
display_bar_aux(Length, Index) :-
    write('----'),
    I1 is Index + 1,
    display_bar_aux(Length, I1).

%display_board(+Board, +N, +Length)
%Base case, when there are no more rows to display changes line
display_board([], _, _) :- write('|\n').

%display_board(+Board, +N, +Length)
%Recursive predicate that prints the row number, calls display_board_row and adds a bar at the bottom
display_board([Row | Rest], N, Length) :-
    format('~w ', [N]),
    (N < 10 -> write(' '); true),
	display_board_row(Row),
    display_bar(Length),
	N1 is N + 1,
	display_board(Rest, N1, Length).

%display_board_row(+Row)
%Base case, when there are no more cells to display changes line
display_board_row([]) :- write('|\n').

%If the cell is -1 only displays spaces
display_board_row([-1 | Rest]) :- write('    '), display_board_row(Rest).

%If the cell is 0 displays the cell but with empty space
display_board_row([0 | Rest]) :- write('|   '), display_board_row(Rest).

%Recursive case, If the cell is 0 displays spaces and the cell value
display_board_row([Cell | Rest]) :-
    format('| ~w ', [Cell]),
	display_board_row(Rest).

%display_moves(+ListOfMoves, +N, +I)
%Base case, when there are no more moves to display changes line
display_moves(_, 0, _) :- nl.

%Move is an emptySpace
display_moves([H|T], N, I) :-
    [Piece, _, Direction, MoveType] = H,
    MoveType = emptySpace,

    piece_map(Piece, PieceType),
    format('~w. ~w(~w) ~w \n', [I, PieceType, Piece, Direction]),

    N1 is N - 1,
    I1 is I + 1,
    display_moves(T, N1, I1).

%Move is a trollPull
display_moves([H|T], N, I) :-
    [Piece, _, Direction, MoveType] = H,
    MoveType = trollPull,

    piece_map(Piece, PieceType),
    format('~w. ~w(~w) ~w and pull rock behind \n', [I, PieceType, Piece, Direction]),

    N1 is N - 1,
    I1 is I + 1,
    display_moves(T, N1, I1).

%Move is a trollThrow
display_moves([H|T], N, I) :-
    [Piece, _, Direction, MoveType] = H,
    MoveType = trollThrow,

    piece_map(Piece, PieceType),
    format('~w. ~w(~w) ~w and throw rock \n', [I, PieceType, Piece, Direction]),

    N1 is N - 1,
    I1 is I + 1,
    display_moves(T, N1, I1).

%Move is a dwarfPush
display_moves([H|T], N, I) :-
    [Piece, _, Direction, MoveType] = H,
    MoveType = dwarfPush,

    piece_map(Piece, PieceType),
    format('~w. ~w(~w) ~w and push every piece \n', [I, PieceType, Piece, Direction]),

    N1 is N - 1,
    I1 is I + 1,
    display_moves(T, N1, I1).

%choose_direction(+ListOfMoves, -ChosenDirection)
%Displays the list of moves and reads the chosen direction
choose_direction(ListOfDirections, ChosenDirection):-
    length(ListOfDirections, Length),
    display_directions(ListOfDirections, Length, 1),
    read_option(1, Length, Option),
    nth1(Option, ListOfDirections, ChosenDirection).

%display_directions(+ListOfDirections, +N, +I)
%Base case, when there are no more directions to display changes line
display_directions(_, 0, _) :- nl.

%Recursive case, displays the direction and increments the index
display_directions([Direction|T], N, I) :-
    format('~w. ~w \n', [I, Direction]),
    N1 is N - 1,
    I1 is I + 1,
    display_directions(T, N1, I1).

%choose_levitating_rock(+LevitatingRocks, -ChosenRockIndex)
%Displays the list of levitating rocks and reads the chosen rock
choose_levitating_rock(LevitatingRocks, ChosenRockIndex) :-
    length(LevitatingRocks, Length),
    display_levitating_rocks(LevitatingRocks, Length, 1),
    read_option(1, Length, ChosenRockIndex).

%display_levitating_rocks(+LevitatingRocks, +N, +I)
%Base case, when there are no more rocks to display changes line
display_levitating_rocks(_, 0, _) :- nl.

%Recursive case, displays the rock and increments the index
display_levitating_rocks([[X, Y]|T], N, I) :-
    format('~w. Rock (~w, ~w) \n', [I, X, Y]),
    N1 is N - 1,
    I1 is I + 1,
    display_levitating_rocks(T, N1, I1).

%print_congratulations(+Winner)
print_congratulations(1) :-
    write('  ____   _         _  __   __ _____  ____      _ '), nl,
    write(' |  _ \\ | |       / \\ \\ \\ / /| ____||  _ \\    / |'), nl,
    write(' | |_) || |      / _ \\ \\ V / |  _|  | |_) |   | |'), nl,
    write(' |  __/ | |___  / ___ \\ | |  | |___ |  _ <    | |'), nl,
    write(' |_|    |_____|/_/  _\\_\\|_|  |_____||_| \\_\\   |_|'), nl,
    write('                                                 '), nl,
    write('         \\ \\      / // _ \\ | \\ | |               '),  nl,       
    write('          \\ \\ /\\ / /| | | ||  \\| |               '), nl,        
    write('           \\ V  V / | |_| || |\\  |               '),   nl,      
    write('            \\_/\\_/   \\___/ |_| \\_|               \n\n').


print_congratulations(2) :-
    write('  ____   _         _  __   __ _____  ____     ____  '), nl,
    write(' |  _ \\ | |       / \\ \\ \\ / /| ____||  _ \\   |___ \\ '), nl,
    write(' | |_) || |      / _ \\ \\ V / |  _|  | |_) |    __) |'), nl,
    write(' |  __/ | |___  / ___ \\ | |  | |___ |  _ <    / __/ '), nl,
    write(' |_|    |_____|/_/  _\\_\\|_|  |_____||_| \\_\\  |_____|'), nl,
    write('                                                    '),nl,
    write('         \\ \\      / // _ \\ | \\ | |                  '), nl,        
    write('          \\ \\ /\\ / /| | | ||  \\| |                  '),  nl,       
    write('           \\ V  V / | |_| || |\\  |                  '),     nl,    
    write('            \\_/\\_/   \\___/ |_| \\_|                  \n\n').