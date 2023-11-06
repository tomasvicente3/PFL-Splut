%initial_state(+Size, -GameState)
initial_state(Size, [Board, 1, 1]):-
    init_board(Size, Board), !.

%can_move(+Piece, +Board, +Position, +Direction, -MoveType)
%Every piece can move to an empty space
can_move(_, Board, [X, Y], Direction, emptySpace):-
    direction_map(Direction, [Dx, Dy]),
    Nx is X + Dx,
    Ny is Y + Dy,
    get_piece(Board, [Nx, Ny], Ocupied),
    Ocupied = 0.

%A Troll can move to an empty space and pull the rock behind it
can_move('Troll', Board, [X, Y], Direction, trollPull) :-
    direction_map(Direction, [Dx, Dy]),
    Nx is X + Dx,
    Ny is Y + Dy,
    get_piece(Board, [Nx, Ny], Ocupied),
    Ocupied = 0,
    opposing_direction(Direction, OpposingDirection),
    direction_map(OpposingDirection, [ODx, ODy]),
    Ox is X + ODx,
    Oy is Y + ODy,
    get_piece(Board, [Ox, Oy], Ocupied2),
    Ocupied2 = 'R'.

%A troll can relocate to a spot occupied by a rock and then throw the rock.
can_move('Troll', Board, [X, Y], Direction, trollThrow) :-
    direction_map(Direction, [Dx, Dy]),
    Nx is X + Dx,
    Ny is Y + Dy,
    get_piece(Board, [Nx, Ny], Ocupied),
    Ocupied = 'R',
    set_piece(Board, [X,Y], 0, NewBoard),

    can_throw_rock(NewBoard, [Nx, Ny]).

%A dwarf can move to an occupied space as long as it can shift every piece in front one space in the same direction
can_move('Dwarf', Board, [X, Y], Direction, dwarfPush) :-
    direction_map(Direction, [Dx, Dy]),
    Nx is X + Dx,
    Ny is Y + Dy,
    get_piece(Board, [Nx, Ny], Ocupied),
    Ocupied \= 0,
    can_push(Board, [Nx, Ny], Direction).

%can_throw_rock(+Board, +Position)
can_throw_rock(Board, [X, Y]):-
    Directions = ['UP', 'RIGHT', 'DOWN', 'LEFT'],
    findall(Direction, (member(Direction, Directions), can_throw(Board, [X,Y], Direction)), ListOfDirections),!,
    length(ListOfDirections, Length),
    Length > 0.

%can_be_thrown_through(+Board, +Position, +Direction)
%We can push a piece as long as eventually we find an empty space
can_push(Board, [X, Y], Direction):-
    direction_map(Direction, [Dx, Dy]),
    Nx is X + Dx,
    Ny is Y + Dy,
    get_piece(Board, [Nx, Ny], Ocupied), !,
    (Ocupied = 0; can_push(Board, [Nx,Ny], Direction)), !.

%valid_moves(+GameState, +Player, -ListOfMoves)
valid_moves([Board,_, _], Player, ListOfMoves):-
    findall(Piece, belongs(Player, Piece), PlayerPieces),
    get_positions(Board, PlayerPieces, PiecesPosition),
    get_moves(Board, PiecesPosition, ListOfMoves).

%get_positions(+Board, +PiecesList, -PiecesPosition)
get_positions(_, [], []).
get_positions(Board, [Piece | Rest], [[Piece,[X,Y]] | RestPiecesPosition]):-
    nth1(Y, Board, Row),
    nth1(X, Row, Piece),
    get_positions(Board, Rest, RestPiecesPosition).
get_positions(Board, [_ | Rest], PiecesPosition):-
    get_positions(Board, Rest, PiecesPosition).

%get_all_rocks(+Board, -RockPositions)
get_all_rocks(Board, RockPositions):-
    findall([X,Y], (nth1(Y,Board,Row), nth1(X,Row,'R')), RockPositions), !.

%get_moves(+Board, +PiecesList, -ListOfMoves)
get_moves(_, [], []).
get_moves(Board, [[Piece, [X, Y]] | RestPieces], ListOfMoves):-
    Directions = ['UP', 'RIGHT', 'DOWN', 'LEFT'],
    findall([Piece, [X,Y], Direction, MoveType], 
            (member(Direction, Directions), piece_map(Piece, PieceType), can_move(PieceType, Board, [X, Y], Direction, MoveType)), 
            PieceMoves),
    get_moves(Board, RestPieces, RestMoves),
    append(PieceMoves, RestMoves, ListOfMoves).

%get_piece(+Board, +Position, -Ocupied)
get_piece(Board, [X, Y], Ocupied):-
    length(Board, Size),
    X > 0, Y > 0, X =< Size, Y =< Size, !,
    nth1(Y, Board, Row),
    nth1(X, Row, Ocupied), !.

%set_piece(+Board, +Position, +Piece, -NewBoard)
set_piece(Board, [X,Y], Piece, NewBoard):-
    set_piece_aux(Board, [X,Y], Piece, 1, NewBoard).

%set_piece_aux(+Board, +Position, +Piece, +CurrY, -NewBoard)
%Base case, we got to the correct column
set_piece_aux([Row | Rest], [X, Y], Piece, Y, [NewRow | Rest]):-
    replace_at_row(Row, X, Piece, NewRow), !.
set_piece_aux([Row | Rest], [X, Y], Piece, CurrY, [Row | NewRest]):-
    CurrY < Y,
    NextY is CurrY + 1,
    set_piece_aux(Rest, [X, Y], Piece, NextY, NewRest).

%replace_at_row(+Row, +Index, +Piece, -NewRow)
replace_at_row(Row, Index, Piece, NewRow):- replace_at_row_aux(Row, Index, Piece, 1, NewRow).

replace_at_row_aux([_ | Rest], Index, Piece, Index, [Piece | Rest]).
replace_at_row_aux([H | T], Index, Piece, CurrIdx, [H| NewT]):-
    CurrIdx < Index,
    NextIdx is CurrIdx + 1,
    replace_at_row_aux(T, Index, Piece, NextIdx, NewT).

%can_throw(+Board, +Position, +Direction)
can_throw(Board, [X, Y], Direction):-
    direction_map(Direction, [Dx, Dy]),
    Nx is X + Dx, Ny is Y + Dy,
    get_piece(Board, [Nx, Ny], Ocupied),
    can_be_thrown_through(Ocupied), !.

%in_bounds(+Board, +Position)
in_bounds(Board, [X,Y]):-
    X > 0, Y > 0,
    length(Board, Size),
    X =< Size, Y =< Size.

%throw_rock(+Board, +Player, +Position, -NewBoard)
throw_rock(Board, Player, [X,Y], NewBoard):-
    human(Player), !,
    Directions = ['UP', 'RIGHT', 'DOWN', 'LEFT'],
    findall(Direction, (member(Direction, Directions), can_throw(Board, [X,Y], Direction)), ListOfDirections),!,
    write('\nChoose a direction to throw the rock: \n'),
    choose_direction(ListOfDirections, ChosenDirection),
    direction_map(ChosenDirection, [Dx, Dy]),
    Nx is X + Dx, Ny is Y + Dy,
    flying_rock(Board, [Nx,Ny], ChosenDirection, NewBoard).

throw_rock(Board, Player, [X,Y], NewBoard):-
    computer(Player, 1), !,
    Directions = ['UP', 'RIGHT', 'DOWN', 'LEFT'],
    findall(Direction, (member(Direction, Directions), can_throw(Board, [X,Y], Direction)), ListOfDirections),!,
    length(ListOfDirections, Length),
    custom_random(1, Length, ChosenDirectionIndex),
    nth1(ChosenDirectionIndex, ListOfDirections, ChosenDirection),
    format("\nComputer ~w chose to throw the rock ~w \n",[Player, ChosenDirection]),
    get_char(_),
    direction_map(ChosenDirection, [Dx, Dy]),
    Nx is X + Dx, Ny is Y + Dy,
    flying_rock(Board, [Nx,Ny], ChosenDirection, NewBoard).

throw_rock(Board, Player, [X,Y], NewBoard):-
    computer(Player, 2), !,
    Directions = ['UP', 'RIGHT', 'DOWN', 'LEFT'],
    findall(Direction, (member(Direction, Directions), can_throw(Board, [X,Y], Direction)), ListOfDirections),!,
    
    findall([Direction, Value], (member(Direction, ListOfDirections), direction_map(Direction, [Dxl, Dyl]), Tx is X + Dxl, Ty is Y + Dyl, flying_rock(Board, [Tx,Ty], Direction, TempBoard) ,value([TempBoard, _, _], Player, Value)), ListOfValues),
    get_best(ListOfValues, ChosenDirection),

    format("\nComputer ~w chose to throw the rock ~w \n",[Player, ChosenDirection]),
    get_char(_),
    direction_map(ChosenDirection, [Dx, Dy]),
    Nx is X + Dx, Ny is Y + Dy,
    flying_rock(Board, [Nx,Ny], ChosenDirection, NewBoard).

%flying_rock(+Board, +Position, +Direction, -NewBoard)
%If the next position is out of bounds, the rock stops
flying_rock(Board, [X,Y], Direction, NewBoard):-
    direction_map(Direction, [Dx, Dy]),
    Nx is X + Dx, Ny is Y + Dy,
    \+ in_bounds(Board, [Nx,Ny]), !,
    set_piece(Board, [X,Y], 'R', NewBoard).

%If the  next pos is a piece that stops the rock, the rock stops
flying_rock(Board, [X,Y], Direction, NewBoard):-
    direction_map(Direction, [Dx, Dy]),
    Nx is X + Dx, Ny is Y + Dy,
    get_piece(Board, [Nx, Ny], NextPiece),
    stops_rock(NextPiece), !,
    set_piece(Board, [X,Y], 'R', NewBoard).

%If the next pos is a sorcerer, the rock stops and the sorcerer dies
flying_rock(Board, [X,Y], Direction, NewBoard):-
    direction_map(Direction, [Dx, Dy]),
    Nx is X + Dx, Ny is Y + Dy,
    get_piece(Board, [Nx, Ny], NextPiece),
    piece_map(NextPiece, PieceType), PieceType = 'Sorcerer', !,
    set_piece(Board, [Nx,Ny], 'R', NewBoard).

%If the next pos is unoccupied or occupied by a piece that doesn't stop the rock, the rock keeps flying
flying_rock(Board, [X,Y], Direction, NewBoard):-
    direction_map(Direction, [Dx, Dy]),
    Nx is X + Dx, Ny is Y + Dy,
    get_piece(Board, [Nx, Ny], NextPiece),
    \+ stops_rock(NextPiece), in_bounds(Board, [Nx,Ny]), !,
    flying_rock(Board, [Nx, Ny], Direction, NewBoard).

%shift_piece(+Board, +Position, +Direction, -NewBoard)
%We get the lenght(number of pieces we need to shift) and then we shift the line
shift_line(Board, [X, Y], Direction, NewBoard) :-
    get_push_lenght(Board, [X, Y], Direction, Length),
    shift_line_aux(Board, [X, Y], Direction, NewBoard, Length).

%shift_line_aux(+Board, +Position, +Direction, -NewBoard, +Length)
%Base case, we shifted all the pieces (Put the 0 in the initial position)
shift_line_aux(Board, [X, Y], _, NewBoard, 0) :-
    set_piece(Board, [X, Y], 0, NewBoard), !.

%We shift the front piece one space (Initial pos + direction*(length-1) -> (Initial pos + direction*length)
shift_line_aux(Board, [X, Y], Direction, NewBoard, Length) :-
    Length > 0,

    multiply_direction(Direction, Length-1, [Dx2, Dy2]),
    Nx is X + Dx2, Ny is Y + Dy2,
    get_piece(Board, [Nx, Ny], Piece),

    multiply_direction(Direction, Length, [Dx3, Dy3]),
    Nx2 is X + Dx3, Ny2 is Y + Dy3,
    set_piece(Board, [Nx2, Ny2], Piece, TempBoard),

    NewLength is Length - 1,
    shift_line_aux(TempBoard, [X, Y], Direction, NewBoard, NewLength).

%get_push_lenght(+Board, +Position, +Direction, -Length)
%Calls the aux predicate with the initial length = 1
get_push_lenght(Board, [X, Y], Direction, Length) :-
    get_push_lenght_aux(Board, [X, Y], Direction, 1, Length).

%While we haven't found an empty space, we increase the length and recursevly call the predicate
get_push_lenght_aux(Board, [X, Y], Direction, LengthSoFar, Length) :-
    direction_map(Direction, [Dx, Dy]),
    Nx is X + Dx,
    Ny is Y + Dy,
    get_piece(Board, [Nx, Ny], Piece),
    Piece \= 0,
    NewLength is LengthSoFar + 1,
    get_push_lenght_aux(Board, [Nx, Ny], Direction, NewLength, Length).

%Base case, If we found an empty space, we stop and return the length
get_push_lenght_aux(Board, [X, Y], Direction, LengthSoFar, LengthSoFar) :-
    direction_map(Direction, [Dx, Dy]),
    Nx is X + Dx,
    Ny is Y + Dy,
    get_piece(Board, [Nx, Ny], Piece),
    Piece = 0, !.

%multiply_direction(+Direction, +Length, -MultipliedDirection)
multiply_direction(Direction, Length, [Dx, Dy]) :-
    direction_map(Direction, [Dx1, Dy1]),
    Dx is Dx1 * Length,
    Dy is Dy1 * Length.

%levitate_rock(+GameState, +Direction, +Player, -NewBoard)
%A rock can be levitated if there is an empty space walking in the direction of the sorcerer
levitate_rock([Board, Turn, Steps], Direction, Player, NewBoard) :-
    human(Player),
    \+ non_continuous_levitate(Turn),
    direction_map(Direction, [Dx, Dy]),
    get_all_rocks(Board, Positions),

    findall([X, Y], (levitate_free_space(Board, [X, Y], [Dx, Dy], Positions)), LevitatingRocks),
    length(LevitatingRocks, Length),
    Length > 0, !,
    write('Do you want to levitate a rock? \n'),
    write('1. Yes \n'),
    write('2. No \n'),
    read_option(1, 2, UserResponse),
    (UserResponse = 1 ->
        assertz(levitating(Turn, Steps)),
        write('Choose a rock to levitate: \n'),
        choose_levitating_rock(Player, LevitatingRocks, ChosenRockIndex),
        nth1(ChosenRockIndex, LevitatingRocks, [RX, RY]),
        set_piece(Board, [RX, RY], 0, TempBoard),
        NX is RX + Dx, NY is RY + Dy,
        set_piece(TempBoard, [NX, NY], 'R', NewBoard)
    ;
        assertz(not_levitating(Turn, Steps)),
        NewBoard = Board
    ).

levitate_rock([Board, Turn, Steps], Direction, Player, NewBoard) :-
    computer(Player, _),
    \+ non_continuous_levitate(Turn),
    direction_map(Direction, [Dx, Dy]),
    get_all_rocks(Board, Positions),

    findall([X, Y], (levitate_free_space(Board, [X, Y], [Dx, Dy], Positions)), LevitatingRocks),
    length(LevitatingRocks, Length),
    Length > 0, !,
    custom_random(1,2, BotDecision),
    (BotDecision = 1 ->
        assertz(levitating(Turn, Steps)),
        choose_levitating_rock(Player, LevitatingRocks, ChosenRockIndex),
        nth1(ChosenRockIndex, LevitatingRocks, [RX, RY]),
        format("Computer ~w chose to levitate the rock in (~w,~w) \n", [Player, RX, RY]),
        get_char(_),
        set_piece(Board, [RX, RY], 0, TempBoard),
        NX is RX + Dx, NY is RY + Dy,
        set_piece(TempBoard, [NX, NY], 'R', NewBoard)
    ;
        format("Computer ~w chose to not levitate a rock \n", [Player]), get_char(_),
        assertz(not_levitating(Turn, Steps)), 
        NewBoard = Board
    ).
/*
levitate_rock([Board, Turn, Steps], Direction, Player, NewBoard) :-
    computer(Player, 2),
    \+ non_continuous_levitate(Turn),
    direction_map(Direction, [Dx, Dy]),
    get_all_rocks(Board, Positions),

    findall([X, Y], (levitate_free_space(Board, [X, Y], [Dx, Dy], Positions)), LevitatingRocks),
    length(LevitatingRocks, Length),
    Length > 0, !,
    custom_random(1,2, BotDecision),
    (BotDecision = 1 ->
        assertz(levitating(Turn, Steps)),
        choose_levitating_rock(Player, LevitatingRocks, ChosenRockIndex),
        nth1(ChosenRockIndex, LevitatingRocks, [RX, RY]),
        format("Computer ~w chose to levitate the rock in (~w,~w) \n", [Player, RX, RY]),
        get_char(_),
        set_piece(Board, [RX, RY], 0, TempBoard),
        NX is RX + Dx, NY is RY + Dy,
        set_piece(TempBoard, [NX, NY], 'R', NewBoard)
    ;
        format("Computer ~w chose not to levitate a rock \n", [Player]), get_char(_),
        assertz(not_levitating(Turn, Steps)), 
        NewBoard = Board
    ).
*/
levitate_rock([Board, _, _], _, _, Board).


%levitate_free_space(+Position, +Direction, +Positions)
%checks if there is an empty space to levitate the rocks
levitate_free_space(Board, [X, Y], [Dx, Dy], Positions) :-
    member([X, Y], Positions),
    X2 is X + Dx, Y2 is Y + Dy, 
    get_piece(Board, [X2, Y2], Piece), 
    Piece = 0.

%non_continuous_levitate(+Turn)
%Checks if the player has already levitated and stopped levitating a rock in a given turn
non_continuous_levitate(Turn):-
    levitating(Turn, Step1), not_levitating(Turn, Step2), 
    integer(Step1), integer(Step2), 
    Step2 < Step1.

%value(+GameState, +Player, -Value)
%Evaluates the board in terms of favorable positions for the player
value([Board, _, _], Player, Value):-
    get_positions(Board, ['R'], RockPositionsAux),
    findall([X,Y], member([_,[X,Y]], RockPositionsAux), RockPositions),
    
    get_troll_pos(Board, Player, TrollPosition),
    get_enemy_sorcerer_pos(Board,Player, EnemySorcererPosition),
    
    get_rock_distances(RockPositions, TrollPosition, EnemySorcererPosition, RockDistances),
    get_min(RockDistances, Value), !.

%get_troll_pos(+Board, +Player, -TrollPosition)
%Gets the position of the player's troll
get_troll_pos(Board, Player, TrollPosition):-
    piece_map(Piece, 'Troll'),
    belongs(Player, Piece),
    get_positions(Board, [Piece], TrollPositionList),
    nth1(1, TrollPositionList, [_, TrollPosition]).

%get_enemy_sorcerer_pos(+Board, +Player, -EnemySorcererPosition)
%Gets the position of the enemy sorcerer
get_enemy_sorcerer_pos(Board, Player, EnemySorcererPosition):-
    Enemy is 3 - Player,
    piece_map(EnemyS, 'Sorcerer'),
    belongs(Enemy, EnemyS),
    get_positions(Board, [EnemyS], EnemySorcererPositionList),
    nth1(1, EnemySorcererPositionList, [_,EnemySorcererPosition]).

%sorcerer_dead(+Board, +Player)
%Checks if the player's sorcerer is dead
sorcerer_dead(Board, 1):-
    get_positions(Board, ['S'], SorcererPositions),!,
    SorcererPositions = [].

sorcerer_dead(Board, 2):-
    get_positions(Board, ['s'], SorcererPositions),!,
    SorcererPositions = [].

%get_best_move(+Board, +ListOfMoves, +Player, -BestMove)
%Gets the best move for the player
get_best_move(Board, ListOfMoves, Player, BestMove):-
    findall([Move, Value], (member(Move, ListOfMoves), move([Board, _, _], Move, NewBoard), value([NewBoard, _, _], Player, Value)), ListOfValues),
    get_best(ListOfValues, BestMove).

%get_best(+ListOfValues, -BestMove)
%Gets the best move from a list of moves
get_best([[Move, Value] | Other], BestMove):-
    get_best_aux(Other, Value, Move, BestMove).

get_best_aux([], _, Move, Move).
get_best_aux([[Move, Value] | Other], AccValue, _, BestMove):-
    Value < AccValue, !,
    get_best_aux(Other, Value, Move, BestMove).
get_best_aux([_ | Other], AccValue, AccMove, BestMove):-
    get_best_aux(Other, AccValue, AccMove, BestMove).
