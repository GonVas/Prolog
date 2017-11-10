:-include('utils.pl').
:-include('io.pl').
:-include('specials.pl').
:-include('create.pl').

moveWaiter(Board, Table, Seat, NewBoard) :-
	at(Elem, Table, Board),
	replace('W', Seat, Elem, NewElem),
	replace(NewElem, Table, Board, NewBoard).

play(Table, Seat, Board) :-
	getNumberInput(Seat),
	at(Elem, Table, Board),
	at(Token, Seat, Elem),
	Token == '.'.

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

%TODO waiter can be on top of tea, we need special tokens to symbolize that
eraseWaiter(Board, Index, -1, NewBoard) :-
	at(Elem, Index, Board),
	find('W', 0, WaiterIndex, Elem),
	Index1 is Index+1,
	eraseWaiter(Board, Index1, WaiterIndex, NewBoard).

handleWaiter(Board, Seat, NewBoard, NewSeat):-
	eraseWaiter(Board, 0, -1, NewBoard1),
	moveWaiter(NewBoard1, Seat, Seat, NewBoard),
	assignValue(Seat, NewSeat).

turn(TeaToken, Table, Board, NewBoard, NewTable) :-
	write('Player '), write(TeaToken), write(' turn: '), nl,
	play(Table, Seat, Board),
	serveTea(Board, Table, Seat, TeaToken, NewBoard1),
	handleWaiter(NewBoard1, Seat, NewBoard, NewSeat),
	assignValue(NewSeat, NewTable),
	drawBoard(NewBoard).

%============================Counting Tables ================================

countTokenTables(IsMajor,Total) :-
	Total > 4,
	IsMajor = 1.

countTokenTables(IsMajor, Total) :-
	Total =< 4,
	IsMajor = 0.

countMajorTables(_, Max, _, _) :-
	Max < 0.

countMajorTables(Board, Max, Total, Token, _) :-
	Max >= 0,
	at(Elem, Max, Board),
	count(Elem, Token, TableTotal),
	countTokenTables(IsMajor, TableTotal),
	Total1 is Total + IsMajor,
	Max1 is Max-1,
	countMajorTables(Board, Max1, Total1, Token, Total1).

%//============================Counting Tables ================================


endCondition(Board) :- %  For player X
	countMajorTables(Board, 8, 0, 'X', NewTotal),
	NewTotal > 4,
	write('Congratulations Player X you have won.'), nl.

endCondition(Board) :- %  For player O
	countMajorTables(Board, 8, 0, 'O', NewTotal),
	NewTotal > 4,
	write('Congratulations Player O you have won.'), nl.

gameLoop(_, _, Board) :-
	endCondition(Board).
gameLoop(End, Table, Board) :-
	repeat,
	turn('X', Table, Board, NewBoard1, NewTable),

	swapTables_5(NewBoard1, Table, 'X', NewBoard3),

	turn('O', NewTable, NewBoard3, NewBoard2, NewTable1),
	gameLoop(End, NewTable1, NewBoard2).

start :-
	createTables(Board,0,10),
	moveWaiter(Board, 0, 0, NewBoard),
	drawBoard(NewBoard),
	gameLoop(0, 0, NewBoard).
