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
    display_board_rows(Board).

display_board_rows([]).
display_board_rows([Row | Rest]) :-
    display_board_row(Row),
    nl,
    display_board_rows(Rest).

display_board_row([]).
display_board_row([Cell | Rest]) :-
    (Cell = -1 -> write('   ');
     Cell = 0 -> write(' |_| ');
     format(' |~w| ', [Cell])),
    display_board_row(Rest).
