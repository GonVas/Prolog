:-include('utils.pl').
:-include('io.pl').
:-include('specials.pl').
:-include('create.pl').
:-include('waiter.pl').
:-include('ai.pl').

play(Table, Seat, Board) :-
	repeat,
		getNumberInput(Seat, 0, 8),
		at(Elem, Table, Board),
		at(Token, Seat, Elem),
		Token == '.'.

serveTea(Board, Table, Seat, TeaToken, NewBoard) :-
	at(Elem, Table, Board),
	replace(TeaToken, Seat, Elem, NewElem),
	replace(NewElem, Table, Board, NewBoard).

turn(TeaToken, Table, Board, NewBoard, NewTable) :-
	write('Player '), write(TeaToken), write(' turn: '),
	play(Table, Seat, Board),
	serveTea(Board, Table, Seat, TeaToken, NewBoard1),
	checkSpecials(NewBoard1, Table, Seat, TeaToken, NewBoard, NewTable, 0),
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

checkSpecials(Board, 0, Seat, _, NewBoard, NewSeatNumber, AI) :-
	handleWaiter(Board, Seat, NewBoard, NewSeatNumber),
	write('Check Specials, New Seat Number = '), write(NewSeatNumber), nl.

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
	turn('O', NewTable, NewBoard1, NewBoard2, NewTable1),
	gameLoop(End, NewTable1, NewBoard2).

start :-
	clearScreen,
	createTables(Board,0,10),
	moveWaiter(Board, 0, 0, NewBoard),
	drawBoard(NewBoard),
	gameLoop(0, 0, NewBoard).


playMenu :-
	clearScreen,
	printPlayMenu,
	getNumberInput(Option, 1, 4),
	(
		Option = 1 -> write('Starting Human vs Human \n'), start, startMenu;
		Option = 2 -> write('Starting Ai vs Human \n'), startMenu;
		Option = 3 -> write('Starting Ai vs Ai \n'), startMenu;
		startMenu
	).

startMenu :-
	clearScreen,
	printMenu,
	getNumberInput(Option, 1, 3),
	(
		Option = 1 -> clearScreen, playMenu, startMenu;
		Option = 2 -> clearScreen, printInfoMenu, get_code(Char), startMenu
	).

play :-
	startMenu.
  
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

