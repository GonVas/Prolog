:-include('utils.pl').
:-include('io.pl').
:-include('specials.pl').
:-include('create.pl').
:-include('waiter.pl').

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
	handleWaiter(NewBoard1, Seat, NewBoard2, NewTable),
	checkSpecials(NewBoard2, Table, TeaToken, NewBoard),
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
checkSpecial(Board, Table, 0, TeaToken, NewBoard) :-
	TeaToken == 'X',
	moveOneToOther_3(Board, Table, TeaToken, NewBoard).
checkSpecial(Board, Table, 1, TeaToken, NewBoard) :-
	TeaToken == 'O',
	moveOneToOther_3(Board, Table, TeaToken, NewBoard).
checkSpecial(Board, Table, 2, TeaToken, NewBoard) :-
	TeaToken == 'X',
	moveWaiterToOther_4(Board, Table, TeaToken, NewBoard, _).
checkSpecial(Board, Table, 3, TeaToken, NewBoard) :-
	TeaToken == 'O',
	moveWaiterToOther_4(Board, Table, TeaToken, NewBoard, _).
checkSpecial(Board, Table, 4, TeaToken, NewBoard) :-
	rotateTable_4(Board, Table, TeaToken, NewBoard).
checkSpecial(Board, Table, 5, TeaToken, NewBoard) :-
	rotateTable_4(Board, Table, TeaToken, NewBoard).
checkSpecial(Board, Table, 6, TeaToken, NewBoard) :-
	swapTables_4(Board, Table, TeaToken, NewBoard).
checkSpecial(Board, Table, 7, TeaToken, NewBoard) :-
	swapTables_5(Board, Table, TeaToken, NewBoard).
% ------------------- END SPECIALS ------------------

checkSpecial(Board, 0, _, _, NewBoard) :-
	assignValue(Board, NewBoard).

endCondition(Board) :- %  For player X
	countMajorTables(Board, 8, 0, 'X', NewTotal),
	NewTotal > 4,
	write('Congratulations Player X you have won.'), nl.

endCondition(Board) :- %  For player O
	countMajorTables(Board, 8, 0, 'O', NewTotal),
	NewTotal > 4,
	write('Congratulations Player O you have won.'), nl.

checkSpecials(Board, Table, TeaToken, NewBoard) :-
	Table \= 0,
	at(Specials, 9, Board),
	Table1 is Table - 1,
	at(Special, Table1, Specials),
	checkSpecial(Board, Table, Special, TeaToken, NewBoard).

checkSpecials(Board, _, _, NewBoard) :-
	assignValue(Board, NewBoard).

gameLoop(_, _, Board) :-
	endCondition(Board).
gameLoop(End, Table, Board) :-
	repeat,
	turn('X', Table, Board, NewBoard1, NewTable),
	turn('O', NewTable, NewBoard1, NewBoard2, NewTable1),
	gameLoop(End, NewTable1, NewBoard2).

start :-
	createTables(Board,0,10),
	moveWaiter(Board, 0, 0, NewBoard),
	drawBoard(NewBoard),
	gameLoop(0, 0, NewBoard).


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
