print_logo :-
    write('\t    _____ ______  _                  ___________\n'),
    write('\t   / ____|  _   || |      | |    | ||____   ____|\n'),
    write('\t   | (___ | |_| || |      | |    | |     | |\n'),
    write('\t   (___ )|  ___/ | |      | |    | |     | |\n'),
    write('\t   ____) | |     | |_____ | (___/ /      | |\n'),
    write('\t  |_____/|_|     |_______| (_____/       |_|\n').


board([
    [-1, -1, -1, 'R', -1, -1, -1],
    [-1, -1, 't', 'd', 's', -1, -1],
    [-1, 0, 0, 0, 0, 0, -1],
    ['R', 0, 0, 0, 0, 0, 'R'],
    [-1, 0, 0, 0, 0, 0, -1],
    [-1, -1, 'S', 'D', 'T', -1, -1],
    [-1, -1, -1, 'R', -1, -1, -1]
]).

display_game:-
    board(GameBoard),
    display_board(GameBoard).

display_board(Board) :-
	write('  | A | B | C | D | E | F | G |'), nl,
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

display_cell(-1) :- write(' ').
display_cell(0) :- write(' ').
display_cell(Cell) :- write(Cell).
