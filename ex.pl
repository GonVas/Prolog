at(Elem,0,[Elem|_]).
at(Elem,Index,[_|Tail]) :-
	Index1 is Index-1,
	Index>0,
	at(Elem,Index1,Tail).

replace(New,0,[_|OldList],[New|OldList]).
replace(New,Index,[Head|OldList],[Head|NewList]):-
	Index > 0,
	Index1 is Index-1,
	replace(New,Index1,OldList,NewList).

createSeats([], M, M). 		%Stop if 2nd args = 3rd arg meaning max elems reached
%Creates the seats of a table
createSeats([H|T], N, M) :-
	N < M, 									%add elements until max elements is reached
	N1 is N+1, 							%keep track of added element
	H = 'O', 								%element to add
	createSeats(T,N1,M).  	%recursive call


createTables([], M, M). %Stop if 2nd args = 3rd arg meaning max elems reached
%Creates the tables of the game
createTables([H|T], N, M) :-
	N < M, 									%add elements until max elements is reached
	N1 is N+1, 							%keep track of added element
	createSeats(H,0,M),  		%add an empty list
	createTables(T, N1, M). %recursive call


drawSeatsTop(L) :-
	at(Token,3,L), write(Token).


drawSeatsTopMiddle(L) :-
	at(Token1,4,L), write(Token1),
	space(0,5), at(Token2,2,L), write(Token2).

drawSeatsMiddle(L) :-
	at(Token1,5,L), write(Token1),
	space(0,3), at(Token2,0,L), write(Token2),
	space(0,3), at(Token3,1,L), write(Token3).

drawSeatsBottomMiddle(L) :-
	at(Token1,6,L), write(Token1),
	space(0,5), at(Token2,8,L), write(Token2).

drawSeatsBottom(L) :-
	at(Token,7,L), write(Token).

drawBoard(Board) :-
	at(L1,3,Board),
	space(0,32), drawSeatsTop(L1), nl,
	space(0,29), drawSeatsTopMiddle(L1), nl,
	space(0,28), drawSeatsMiddle(L1), nl,
	space(0,29), drawSeatsBottomMiddle(L1), nl,
	space(0,32), drawSeatsBottom(L1), nl,

	at(L2,4,Board), at(L3,2,Board),
	space(0,14), drawSeatsTop(L2), space(0,33), drawSeatsTop(L3), nl,
	space(0,11), drawSeatsTopMiddle(L2), space(0,27), drawSeatsTopMiddle(L3), nl,
	space(0,10), drawSeatsMiddle(L2), space(0,25), drawSeatsMiddle(L3), nl,
	space(0,11), drawSeatsBottomMiddle(L2), space(0,27), drawSeatsBottomMiddle(L3), nl,
	space(0,14), drawSeatsBottom(L2), space(0,33), drawSeatsBottom(L3), nl,

	at(L4,5,Board), at(L5,0,Board), at(L6,1,Board),
	space(0,5), drawSeatsTop(L4), space(0,26), drawSeatsTop(L5), space(0,26), drawSeatsTop(L6), nl,
	space(0,2), drawSeatsTopMiddle(L4), space(0,20), drawSeatsTopMiddle(L5), space(0,20), drawSeatsTopMiddle(L6), nl,
	space(0,1), drawSeatsMiddle(L4), space(0,18), drawSeatsMiddle(L5), space(0,18), drawSeatsMiddle(L6), nl,
	space(0,2), drawSeatsBottomMiddle(L4), space(0,20), drawSeatsBottomMiddle(L5), space(0,20), drawSeatsBottomMiddle(L6), nl,
	space(0,5), drawSeatsBottom(L4), space(0,26), drawSeatsBottom(L5), space(0,26), drawSeatsBottom(L6), nl,

	at(L7,6,Board), at(L8,8,Board),
	space(0,14), drawSeatsTop(L7), space(0,33), drawSeatsTop(L8), nl,
	space(0,11), drawSeatsTopMiddle(L7), space(0,27), drawSeatsTopMiddle(L8), nl,
	space(0,10), drawSeatsMiddle(L7), space(0,25), drawSeatsMiddle(L8), nl,
	space(0,11), drawSeatsBottomMiddle(L7), space(0,27), drawSeatsBottomMiddle(L8), nl,
	space(0,14), drawSeatsBottom(L7), space(0,33), drawSeatsBottom(L8), nl,

	at(L9,7,Board),
	space(0,32), drawSeatsTop(L9), nl,
	space(0,29), drawSeatsTopMiddle(L9), nl,
	space(0,28), drawSeatsMiddle(L9), nl,
	space(0,29), drawSeatsBottomMiddle(L9), nl,
	space(0,32), drawSeatsBottom(L9), nl.

space(M,M).
space(I,M):-
  write(' '),
  N1 is I+1,
  space(N1,M).

serveTea(Board, T, S, NewBoard).

moveWaiter(Board, T, S).

activateAction(Board, T, P).

play(jogador2, Table, Seat) :-
	get_code(Table1),
	Table is Table1 - 48,
	get_code(Space),
	get_code(Seat1),
	Seat is Seat1 - 48.


play(jogador1, Table, Seat) :-
	get_code(Table1),
	Table is Table1-48,
	get_code(Space),
	get_code(Seat1),
	Seat is Seat1-48.

serveTea(Board, Table, Seat, j1, NewBoard) :-
	at(Elem, Table, Board),
	replace('G', Seat, Elem, NewElem),
	replace(NewElem, Table, Board, NewBoard).

serveTea(Board, Table, Seat, j2, NewBoard) :-
	at(Elem, Table, Board),
	replace('B', Seat, Elem, NewElem),
	replace(NewElem, Table, Board, NewBoard).


gameloop(Mer, Board) :-
	drawBoard(Board),
	play(jogador1, Table, Seat),
	serveTea(Board, Table, Seat, j1, NewBoard),
	drawBoard(NewBoard),

start(L) :-
	createTables(Board,0,9),
	drawBoard(Board),
	play(jogador1, Table, Seat),
	serveTea(Board, Table, Seat, j1,	 NewBoard),
	drawBoard(NewBoard).
