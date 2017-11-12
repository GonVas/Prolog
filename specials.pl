moveOneToOther_3(Board, FromTable, TeaToken, NewBoard, AI):-
	at(CountTable, FromTable, Board),
	countTokens(CountTable, TeaToken, Total),
	Total == 3,

	write('Triggered: \'Move Tea To Table\'!'), nl,
	write('Insert tea: '),
	getNumberInput(Seat, 0, 8, AI),

	at(Elem1, FromTable, Board),
	at(Token1, Seat, Elem1),
	Token1 == TeaToken,

	write('Write to table : '),
	getNumberInput(ToTable, 0, 8, AI),
	write('Write to seat : '),
	getNumberInput(Seat2, 0, 8, AI),

	at(Elem, ToTable, Board),
	at(Token, Seat2, Elem),
	Token == '.',

	eraseTea(Board, FromTable, Seat, NewBoard1),
	serveTea(NewBoard1, ToTable, Seat2, TeaToken, NewBoard).
moveOneToOther_3(Board,_,_,NewBoard, AI):-
	assignValue(Board, NewBoard).

moveWaiterToOther_4(Board, FromTable, TeaToken, NewBoard, NewSeat, AI):-
	at(CountTable, FromTable, Board),
	countTokens(CountTable, TeaToken, Total),
	Total == 4,

	at(Elem, FromTable, Board),
	find('W', 0, WaiterIndex, Elem),

	write('Triggered: \'Move Waiter To Table\'!'), nl,
	write('Insert table: '),
	getNumberInput(ToTable, 0, 8, AI),

	at(NewTable, ToTable, Board),
	at(Token, WaiterIndex, NewTable),
	write(Token), nl,
	Token == '.',

	eraseWaiter(Board, 0, -1, NewBoard2),
	moveWaiter(NewBoard2, ToTable, WaiterIndex, NewBoard),
	assignValue(ToTable, NewSeat),
	write('NewSeat : '), write(NewSeat), nl.

swapTables_5(Board, FromTable, TeaToken, NewBoard, AI) :-
	at(CountTable, FromTable, Board),
	countTokens(CountTable, TeaToken, Total),
	write('Total is = '), write(Total), nl,
	Total == 5,

	write('Triggered: \'Swap Claimed Table With Unclaimed\'!'), nl,
	write('Insert table: '),
	getUnclaimedTable(Board, ToTable, AI),
	at(FromTableData, FromTable, Board),
	at(ToTableData, ToTable, Board),

	replace(FromTableData, ToTable, Board, NewBoard1),
	replace(ToTableData, FromTable, NewBoard1, NewBoard).
swapTables_5(Board, _, _, NewBoard, AI) :-
	assignValue(Board, NewBoard).

swapTables_4(Board, FromTable, TeaToken, NewBoard, AI) :-
	at(CountTable, FromTable, Board),
	countTokens(CountTable, TeaToken, Total),
	write('Total is = '), write(Total), nl,
	Total == 4,

	write('Triggered: \'Swap Unclaimed Table With Unclaimed\'!'), nl,
	write('Insert table: '),
	getUnclaimedTable(Board, ToTable, AI),
	at(FromTableData, FromTable, Board),
	at(ToTableData, ToTable, Board),

	replace(FromTableData, ToTable, Board, NewBoard1),
	replace(ToTableData, FromTable, NewBoard1, NewBoard).
swapTables_4(Board, _, _, NewBoard, AI) :-
	assignValue(Board, NewBoard).

rotateTable_4(Board, Table, TeaToken, NewBoard, AI) :-
	at(TableElem, Table, Board),
	countTokens(TableElem, TeaToken, Total),
	Total == 4,

	write('Triggered: \'Rotate Table\'!'), nl,
	write('Insert number of counter-clockwise rotations: '),
	getNumberInput(NRot, 0, 7, AI),

	applyRotation(TableElem, NRot, RotatedTable),
	replace(RotatedTable, Table, Board, NewBoard).
rotateTable_4(Board, _, _, NewBoard, AI) :-
	assignValue(Board, NewBoard).

eraseTea(Board, TableNumber, SeatNumber, NewBoard) :-
	at(BoardTable, TableNumber, Board),
	at(Token, SeatNumber, BoardTable),
	removeTea(BoardTable, SeatNumber, Token, NewBoardTable),
	replace(NewBoardTable, TableNumber, Board, NewBoard).

removeTea(BoardTable, SeatNumber, 'O', NewBoardTable) :-
	replace('.', SeatNumber, BoardTable, NewBoardTable).
removeTea(BoardTable, SeatNumber, '@', NewBoardTable) :-
	replace('W', SeatNumber, BoardTable, NewBoardTable).
removeTea(BoardTable, SeatNumber, 'X', NewBoardTable) :-
	replace('.', SeatNumber, BoardTable, NewBoardTable).
removeTea(BoardTable, SeatNumber, '%', NewBoardTable) :-
	replace('W', SeatNumber, BoardTable, NewBoardTable).
