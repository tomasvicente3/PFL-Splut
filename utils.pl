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


%get_min_from_pos_dist(+PosDistances, -MinPos, -MinDist)
%Get the position of the closest point to the target and its distance
get_min_from_pos_dist([[Pos,Dist]| T], MinPos, MinDist):-
    get_min_from_pos_dist_aux(T, Pos, Dist, MinPos, MinDist).

get_min_from_pos_dist_aux([], MinPos, MinDist, MinPos, MinDist).
get_min_from_pos_dist_aux([[Pos,Dist]| T], AccPos, AccDist, MinPos, MinDist):-
    min(Dist, AccDist, NewAccDist),
    NewAccDist = Dist,
    get_min_from_pos_dist_aux(T, Pos, NewAccDist, MinPos, MinDist).
get_min_from_pos_dist_aux([[Pos,Dist]| T], AccPos, AccDist, MinPos, MinDist):-
    min(Dist, AccDist, NewAccDist),
    NewAccDist \= Dist,
    get_min_from_pos_dist_aux(T, AccPos, NewAccDist, MinPos, MinDist).


% Distance between two points in 2D space
distance([X1, Y1], [X2, Y2], D) :-
    DX is abs(X2 - X1),
    DY is abs(Y2 - Y1),
    D is DX+DY.

%get_pos_distances(+Positions, +Target, -PosDistances)
%Creates a list with Positions and their distance to the target
get_pos_distances([], _, []).
get_pos_distances([Pos|Rest], Target, [[Pos, Distance]|RestDistances]) :-
    distance(Pos, Target, Distance),
    get_pos_distances(Rest, Target, RestDistances).

%get_distances(+Positions, +Target, -Distances)
%Gets the distances from the positions to the target
get_distances([], _, []).
get_distances([[X,Y]|T], [TargetX, TargetY], [Distance|Distances]):-
    Distance is abs(X - TargetX) + abs(Y - TargetY),
    get_distances(T, [TargetX, TargetY], Distances).
