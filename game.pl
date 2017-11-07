:-include('utils.pl').
:-include('io.pl').
:-include('specials.pl').


%==============specials moves, change to specials file========================

moveOneToOther_3(Board, FromTable, TeaToken, NewBoard):-
	at(CountTable, FromTable, Board),
	count(CountTable, TeaToken, Total),
	write('Total is : '), write(Total), nl, 
	Total > 2,

	write('Do you want to trigger special, move one piece to other table (y/n): '), nl,
	get_code(Permission),
	Permission ==  121, % 'y' character

	repeat,
	write('Triggered Special Move, change on piece to another Table, write first piece: '),
	get_code(Seat1),
	Seat is Seat1 - 48,
	Seat < 9,
	Seat >= 0,
	get_code(_),

	at(Elem1, FromTable, Board),
	at(Token1, Seat, Elem1),
	Token1 == TeaToken,

	write('Write To table : '),
	get_code(ToTable1),
	ToTable is ToTable1 - 48,
	ToTable < 9,
	ToTable >= 0,
	get_code(_),

	
	write('Write To seat : '),
	get_code(Seat3),
	Seat2 is Seat3 - 48,
	Seat2 < 9,
	Seat2 >= 0,
	get_code(_),

	at(Elem, ToTable, Board),
	write('Elem is : '), write(Elem), nl,
	at(Token, Seat2, Elem),
	write('Token is : '), write(Token), nl,
	Token == '.',

	write('Going to erasing Tea'), nl,
	eraseTea(Board, FromTable, Seat, NewBoard1),
	write('Erased Tea'), nl,
	serveTea(NewBoard1, ToTable, Seat2, TeaToken, NewBoard),
	write('Served Tea'), nl.


moveOneToOther_3(Board,_,_,NewBoard):-
	write('Couldnt trigger moveOneToOther_3.'), nl,
	assignValue(Board, NewBoard).

eraseTea(Board, Table, Seat, NewBoard) :-
	at(Elem, Table, Board),
	write('Hello Elem: '), write(Elem), nl,
	replace('.', Seat, Elem, NewElem),
	replace(NewElem, Table, Board, NewBoard).

%==============specials moves, change to specials file========================

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
	moveOneToOther_3(NewBoard, Table, 'X', NewBoard1), 
	turn('O', NewTable, NewBoard1, NewBoard2, NewTable1),
	gameLoop(End, NewTable1, NewBoard2).

start :-
	createTables(Board,0,9),
	moveWaiter(Board, 0, 0, NewBoard),
	drawBoard(NewBoard),
	gameLoop(0, 0, NewBoard).
