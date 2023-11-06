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

%can_be_thrown_through(+Piece)
can_be_thrown_through(0).
can_be_thrown_through('D').
can_be_thrown_through('d').
can_be_thrown_through('S').
can_be_thrown_through('s').

%stops_rock(+Piece)
stops_rock(-1).
stops_rock(-2).
stops_rock('R').
stops_rock('T').
stops_rock('t').

%init_board(+Size, -Board)
init_board(7, [
    [-1,   -1,   -1,   'R',    -2,   -1,   -1],
    [-1,   -1,   't',  'd',   's',   -2,   -1],
    [-1,    0,    0,    0,      0,    0,   -2],
    ['R',   0,    0,    0,      0,    0,   'R'],
    [-1,    0,    0,    0,      0,    0,   -2],
    [-1,   -1,   'S',  'D',   'T',   -2,   -1],
    [-1,   -1,   -1,   'R',    -2,   -1,   -1]
]).


init_board(9, [
    [-1,   -1,   -1,    -1,    'R',   -2,   -1,   -1,   -1],
    [-1,   -1,   -1,   't',    'd',   's',  -2,   -1,   -1],
    [-1,   -1,    0,    0,      0,     0,    0,   -2,   -1],
    [-1,    0,    0,    0,      0,     0,    0,    0,   -2],
    ['R',   0,    0,    0,      0,     0,    0,    0,   'R'],
    [-1,    0,    0,    0,      0,     0,    0,    0,   -2],
    [-1,   -1,    0,    0,      0,     0,    0,   -2,   -1],
    [-1,   -1,   -1,   'S',    'D',   'T',  -2,   -1,   -1],
    [-1,   -1,   -1,   -1,     'R',   -2,   -1,   -1,   -1]
]).

init_board(11, [
    [-1,   -1,   -1,   -1,     -1,    'R',  -2,   -1,   -1,   -1,   -1],
    [-1,   -1,   -1,   -1,     't',   'd',  's',  -2,   -1,   -1,   -1],
    [-1,   -1,   -1,    0,      0,     0,    0,    0,   -2,   -1,   -1],
    [-1,   -1,    0,    0,      0,     0,    0,    0,    0,   -2,   -1],
    [-1,    0,    0,    0,      0,     0,    0,    0,    0,    0,   -2],
    ['R',   0,    0,    0,      0,     0,    0,    0,    0,    0,   'R'],
    [-1,    0,    0,    0,      0,     0,    0,    0,    0,    0,   -2],
    [-1,   -1,    0,    0,      0,     0,    0,    0,    0,   -2,   -1],
    [-1,   -1,   -1,    0,      0,     0,    0,    0,   -2,   -1,   -1],
    [-1,   -1,   -1,   -1,     'S',   'D',  'T',  -2,   -1,   -1,   -1],
    [-1,   -1,   -1,   -1,     -1,    'R',   -2,  -1,   -1,   -1,   -1]
]).
