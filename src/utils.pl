%min(+A, +B, -Min)
%Returns the minimum of A and B
min(A, B, Min):-
    A > B,
    Min = B.
min(A, _, A).

% read_number(-Number)
% Reads a number from the input using get_code
read_number(X):-
    read_number_aux(X,0).
read_number_aux(X,Acc):- 
    get_code(C),
    between(48, 57, C), !,
    Acc1 is 10*Acc + (C - 48),
    read_number_aux(X,Acc1).
read_number_aux(X,X).

% read_char(-Char)
read_char(Char) :-
    get_code(Code),
    char_code(Char, Code).

%custom_random(+Lower, +Higher, -Random)
%Generates a random number between Lower and Higher and takes care of the edge case Lower = Higher
custom_random(Lower, Higher, Random):-
    Higher1 is Higher + 1,
    random(Lower, Higher1, Random).

%get_min(+ListOfNumbers, -Min)
%Gets the minimum of a list of numbers
get_min([H|T], Min):-
    get_min_aux(T, H, Min).
get_min_aux([], Min, Min).
get_min_aux([H|T], Acc, Min):-
    min(H, Acc, NewAcc),
    get_min_aux(T, NewAcc, Min).

%distance(+Position1, +Position2, -Distance)
%Distance between two points in 2D space
distance([X1, Y1], [X2, Y2], D) :-
    DX is abs(X2 - X1),
    DY is abs(Y2 - Y1),
    D is DX+DY.

%get_rock_distances(+Positions, +TrollPosition, +EnemySorcererPosition, -Distances)
%Gets the distances from the player's troll to the enemy's sorcerer, passing through the rocks
get_rock_distances([], _, _, []).
get_rock_distances([RockPos|T], TrollPos, EnemySorcererPos, [Distance|Distances]):-
    distance(TrollPos, RockPos, TrollDistance),
    distance(RockPos, EnemySorcererPos, SorcererDistance),
    Distance is TrollDistance + SorcererDistance,
    get_rock_distances(T, TrollPos, EnemySorcererPos, Distances).
