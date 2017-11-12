:-include('utils.pl').
:-include('io.pl').
:-include('specials.pl').
:-include('create.pl').
:-include('waiter.pl').
:-include('ai.pl').
:-use_module(library(system)).


normalPlay(TableNumber, SeatNumber, TeaToken, Board) :-
	write('Player '), write(TeaToken), write(' turn: '),
	repeat,
		getNumberInput(SeatNumber, 0, 8),
		at(Elem, TableNumber, Board),
		at(Token, SeatNumber, Elem),
		Token == '.'.

endPlay(SeatNumber, TeaToken, Board) :-
	write('Player '), write(TeaToken),
	write('Targetted table full!'), nl,
	repeat,
		write('Insert table: '),
		getNumberInput(TableNumber, 0, 8), nl,
		at(BoardTable, TableNumber, Board),
		find('.', 0, Index, BoardTable),
		Index \= -1,
		repeat,
			write('Insert seat: '),
			getNumberInput(SeatNumber, 0, 8), nl,
			at(SeatToken, SeatNumber, BoardTable),
			SeatToken == '.'.

play(TableNumber, SeatNumber, TeaToken, Board) :-
	at(BoardTable, TableNumber, Board),
	find('.', 0, FreeIndex, BoardTable),
	(
	FreeIndex \= -1 ->
		normalPlay(TableNumber, SeatNumber, TeaToken, Board)
		;
		endPlay(SeatNumber, TeaToken, Board)
	).

serveTea(Board, Table, Seat, TeaToken, NewBoard) :-
	at(Elem, Table, Board),
	replace(TeaToken, Seat, Elem, NewElem),
	replace(NewElem, Table, Board, NewBoard).

turn(TeaToken, TableNumber, Board, NewBoard, NewTableNumber) :-
	play(TableNumber, SeatNumber, TeaToken, Board),
	serveTea(Board, TableNumber, SeatNumber, TeaToken, NewBoard1),
	checkSpecials(NewBoard1, TableNumber, SeatNumber, TeaToken, NewBoard, NewTableNumber, 0),
	drawBoard(NewBoard).

/*  ----------------- SPECIALS ----------------------
	0 -> X Player move tea (XMT)
	1 -> O Player move tea (OMT)
	2 -> X Player move Waiter (XMW)
	3 -> O Player move Waiter (OMW)
	4 -> Rotate table (ROT)
	5 -> Rotate table (ROT)
	6 -> Swap both not claimed (SUU)
	7 -> Swap claimed with unclaimed (SCU)
*/
checkSpecial(Board, Table, Seat, 0, TeaToken, NewBoard, NewSeatNumber, AI) :-
	TeaToken == 'X',
	moveOneToOther_3(Board, Table, TeaToken, NewBoard1, AI),
	handleWaiter(NewBoard1, Seat, NewBoard, NewSeatNumber).

checkSpecial(Board, Table, Seat, 1, TeaToken, NewBoard, NewSeatNumber, AI) :-
	TeaToken == 'O',
	moveOneToOther_3(Board, Table, TeaToken, NewBoard1, AI),
	handleWaiter(NewBoard1, Seat, NewBoard, NewSeatNumber).

checkSpecial(Board, Table, _, 	 2, TeaToken, NewBoard, NewSeatNumber, AI) :-
	TeaToken == 'X',
	moveWaiterToOther_4(Board, Table, TeaToken, NewBoard, NewSeatNumber, AI).

checkSpecial(Board, Table, _, 	 3, TeaToken, NewBoard, NewSeatNumber, AI) :-
	TeaToken == 'O',
	moveWaiterToOther_4(Board, Table, TeaToken, NewBoard, NewSeatNumber, AI).

checkSpecial(Board, Table, Seat, 4, TeaToken, NewBoard, NewSeatNumber, AI) :-
	rotateTable_4(Board, Table, TeaToken, NewBoard1, AI),
	handleWaiter(NewBoard1, Seat, NewBoard, NewSeatNumber).

checkSpecial(Board, Table, Seat, 5, TeaToken, NewBoard, NewSeatNumber, AI) :-
	rotateTable_4(Board, Table, TeaToken, NewBoard1, AI),
	handleWaiter(NewBoard1, Seat, NewBoard, NewSeatNumber).

checkSpecial(Board, Table, Seat, 6, TeaToken, NewBoard, NewSeatNumber, AI) :-
	swapTables_4(Board, Table, TeaToken, NewBoard1, AI),
	handleWaiter(NewBoard1, Seat, NewBoard, NewSeatNumber).

checkSpecial(Board, Table, Seat, 7, TeaToken, NewBoard, NewSeatNumber, AI) :-
	swapTables_5(Board, Table, TeaToken, NewBoard1, AI),
	handleWaiter(NewBoard1, Seat, NewBoard, NewSeatNumber).

%fail case
checkSpecial(Board, _, Seat, _, _, NewBoard, NewSeatNumber, _) :-
	handleWaiter(Board, Seat, NewBoard, NewSeatNumber).

% ------------------- END SPECIALS ------------------

checkSpecials(Board, Table, Seat, TeaToken, NewBoard, NewSeatNumber, AI) :-
	Table \= 0,
	at(Specials, 9, Board),
	Table1 is Table - 1,
	at(Special, Table1, Specials),
	checkSpecial(Board, Table, Seat, Special, TeaToken, NewBoard, NewSeatNumber, AI).

checkSpecials(Board, 0, Seat, _, NewBoard, NewSeatNumber, _) :-
	handleWaiter(Board, Seat, NewBoard, NewSeatNumber),
	write('Check Specials, New Seat Number = '), write(NewSeatNumber), nl.

endCondition(Board, TeaToken) :- %  For player X
	countMajorTables(Board, TeaToken, 0, 0, Total),
	Total > 4,
	write('Congratulations Player'), write(TeaToken), write(' you have won.'), nl,
	halt.

gameLoop(End, Table, Board, 0) :- % Human Version
	turn('X', Table, Board, NewBoard1, NewTable),
	turn('O', NewTable, NewBoard1, NewBoard2, NewTable1),
	gameLoop(End, NewTable1, NewBoard2, 0).

gameLoop(End, Table, Board, 1) :- % Ai Version human becomes 'X'
  turn('X', Table, Board, NewBoard1, NewTable),
  aiTurn('O', NewTable, NewBoard1, NewBoard2, NewTable1),
  gameLoop(End, NewTable1, NewBoard2, 1).

gameLoop(End, Table, Board, 2) :- % AI vs AI Version
  aiTurn('X', Table, Board, NewBoard1, NewTable),
	\+ endCondition(NewBoard1, 'X'),
  sleep(2),
  aiTurn('O', NewTable, NewBoard1, NewBoard2, NewTable1),
	\+ endCondition(NewBoard2, 'O'),
  sleep(2),
  gameLoop(End, NewTable1, NewBoard2, 2).

start(AI) :-
	clearScreen,
	createTables(Board,0,10),
	moveWaiter(Board, 0, 0, NewBoard),
	drawBoard(NewBoard),
	gameLoop(0, 0, NewBoard, AI).

playMenu :-
	clearScreen,
	printPlayMenu,
	getNumberInput(Option, 1, 4),
	(
		Option == 1 -> write('Starting Human vs Human \n'), start(0), startMenu;
		Option == 2 -> write('Starting Ai vs Human \n'), start(1), startMenu;
		Option == 3 -> write('Starting Ai vs Ai \n'), start(2), startMenu;
		startMenu
	).

startMenu :-
	clearScreen,
	printMenu,
	getNumberInput(Option, 1, 3),
	(
		Option = 1 -> clearScreen, playMenu, startMenu;
		Option = 2 -> clearScreen, printInfoMenu, get_code(_), startMenu
	).

play :-
	startMenu.

%============================Counting Tables ================================
xPiece('X',1).	oPiece('X', 0).
xPiece('%',1).	oPiece('%', 0).
xPiece('O',0).	oPiece('O', 1).
xPiece('@',0).	oPiece('@', 1).
xPiece('W',0).	oPiece('W', 0).
xPiece('.',0).	oPiece('.', 0).

countTableTokens(_, _, 9, PreviousTotal, NewTotal) :-
	NewTotal = PreviousTotal.
countTableTokens(BoardTable, 'X', Index, PreviousTotal, NewTotal) :-
	Index1 is Index+1,
	at(Token, Index, BoardTable),
	xPiece(Token, Inc),
	NextTotal is PreviousTotal + Inc,
	countTableTokens(BoardTable, 'X', Index1, NextTotal, NewTotal).
countTableTokens(BoardTable, 'O', Index, PreviousTotal, NewTotal) :-
	Index1 is Index+1,
	at(Token, Index, BoardTable),
	oPiece(Token, Inc),
	NextTotal is PreviousTotal + Inc,
	countTableTokens(BoardTable, 'O', Index1, NextTotal, NewTotal).

countMajorTables(_, _, 9, PreviousTotal, NewTotal) :-
	NewTotal = PreviousTotal.
countMajorTables(Board, TeaToken, Index, PreviousTotal, NewTotal) :-
	Index1 is Index+1,
	at(BoardTable, Index, Board),
	countTableTokens(BoardTable, TeaToken, 0, 0, Total),
	(Total > 4 -> NextTotal is PreviousTotal+1 ; NextTotal is PreviousTotal+0),
	countMajorTables(Board, TeaToken, Index1, NextTotal, NewTotal).

%//============================Counting Tables ================================
