:-include('utils.pl').
:-include('io.pl').

createSeats([], M, M). 		%Stop if 2nd args = 3rd arg meaning max elems reached
%Creates the seats of a table
createSeats([H|T], N, M) :-
	N < M, 									%add elements until max elements is reached
	N1 is N+1, 							%keep track of added element
	H = '.', 								%element to add
	createSeats(T,N1,M).  	%recursive call


createTables([], M, M). %Stop if 2nd args = 3rd arg meaning max elems reached
%Creates the tables of the game
createTables([H|T], N, M) :-
	N < M, 									%add elements until max elements is reached
	N1 is N+1, 							%keep track of added element
	createSeats(H,0,M),  		%add an empty list
	createTables(T, N1, M). %recursive call

moveWaiter(Board, Table, Seat, NewBoard) :-
	at(Elem, Table, Board),
	replace('W', Seat, Elem, NewElem),
	replace(NewElem, Table, Board, NewBoard).

activateAction(Board, T, P).

% TODO change this fkin repeat
play(Table, Seat, Board) :-
	repeat,
	get_code(Seat1),
	Seat is Seat1 - 48,
	Seat < 9,
	Seat >= 0,
	get_code(Enter),
	at(Elem, Table, Board),
	at(Token, Seat, Elem),
	Token == '.'.
	% play(Table, Seat, Board, Token, ValidPosition).

serveTea(Board, Table, Seat, TeaToken, NewBoard) :-
	at(Elem, Table, Board),
	replace(TeaToken, Seat, Elem, NewElem),
	replace(NewElem, Table, Board, NewBoard).

eraseWaiter(_, -1, -1, _).
eraseWaiter(Board, Index, WaiterIndex, NewBoard) :-
	Index >= 0,
	WaiterIndex >= 0,
	Index1 is Index-1,

	at(Elem, Index1, Board),
	replace('.', WaiterIndex, Elem, NewElem),
	replace(NewElem, Index1, Board, NewBoard),
	eraseWaiter(-1,-1,-1,-1). %Return

eraseWaiter(Board, Index, -1, NewBoard) :-
	at(Elem, Index, Board),
	find('W', 0, WaiterIndex, Elem),
	Index1 is Index+1,
	eraseWaiter(Board, Index1, WaiterIndex, NewBoard).

turn(TeaToken, Table, Board, NewBoard, NewTable) :-
	play(Table, Seat, Board),
	write(Seat),
	nl,
	write(Table),
	nl,
	serveTea(Board, Table, Seat, TeaToken, NewBoard1),
	eraseWaiter(NewBoard1, 0, -1, NewBoard2),
	moveWaiter(NewBoard2, Seat, Seat, NewBoard),
	assignValue(Seat, NewTable),
	drawBoard(NewBoard).

gameLoop(1, _).
gameLoop(End, Table, Board) :-
	turn('X', Table, Board, NewBoard, NewTable),
	turn('O', NewTable, NewBoard, NewBoard1, NewTable1),
	gameLoop(End, NewTable1, NewBoard1).

start :-
	createTables(Board,0,9),
	moveWaiter(Board, 0, 0, NewBoard),
	drawBoard(NewBoard),
	gameLoop(0, 0, NewBoard).
