%belongs(+Player, +Piece)
belongs(1, 'S').
belongs(1, 'D').
belongs(1, 'T').
belongs(2, 's').
belongs(2, 'd').
belongs(2, 't').

%direction_map(+Direction, -[Dx, Dy])
direction_map('UP', [0, -1]).
direction_map('DOWN', [0, 1]).
direction_map('RIGHT', [1, 0]).
direction_map('LEFT', [-1, 0]).

%opposing_direction(?Direction1, ?Direction2)
opposing_direction('UP', 'DOWN').
opposing_direction('DOWN', 'UP').
opposing_direction('RIGHT', 'LEFT').
opposing_direction('LEFT', 'RIGHT').

%piece_map(+Piece, -String)
piece_map('S', 'Sorcerer').
piece_map('D', 'Dwarf').
piece_map('T', 'Troll').
piece_map('s', 'Sorcerer').
piece_map('d', 'Dwarf').
piece_map('t', 'Troll').

%column_map(+Column, -Index)
column_map('A', 1).
column_map('B', 2).
column_map('C', 3).
column_map('D', 4).
column_map('E', 5).
column_map('F', 6).
column_map('G', 7).
column_map('H', 8).
column_map('I', 9).
column_map('J', 10).
column_map('K', 11).

%get_index_letter(+Index, -Letter)
get_index_letter(1, 'A').
get_index_letter(2, 'B').
get_index_letter(3, 'C').
get_index_letter(4, 'D').
get_index_letter(5, 'E').
get_index_letter(6, 'F').
get_index_letter(7, 'G').
get_index_letter(8, 'H').
get_index_letter(9, 'I').
get_index_letter(10, 'J').
get_index_letter(11, 'K').

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
    [-1,   -1,    0,    0,      0,     0,    0,    0,    0,    -1,   -1],
    [-1,   -1,   -1,    0,      0,     0,    0,    0,    -1,    -1,    -1],
    [-1,   -1,   -1,   -1,     'S',   'D',  'T',  -1,   -1,   -1,   -1],
    [-1,   -1,   -1,   -1,     -1,    'R',   -1,  -1,   -1,   -1,   -1]
]).
