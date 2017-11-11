moveOneToOther_3(Board,_,_,NewBoard):-
	assignValue(Board, NewBoard).
moveOneToOther_3(Board, FromTable, TeaToken, NewBoard):-
	at(CountTable, FromTable, Board),
	count(CountTable, TeaToken, Total),
	Total > 2,

	write('Triggered: \'Move Tea To Table\'!'), nl,
	write('Insert table: '),
	getNumberInput(Seat, 0, 8),

	at(Elem1, FromTable, Board),
	at(Token1, Seat, Elem1),
	Token1 == TeaToken,

	write('Write To table : '),
	getNumberInput(ToTable, 0, 8),
	write('Write To seat : '),
	getNumberInput(Seat2, 0, 8),

	at(Elem, ToTable, Board),
	at(Token, Seat2, Elem),
	Token == '.',

	eraseTea(Board, FromTable, Seat, NewBoard1),
	serveTea(NewBoard1, ToTable, Seat2, TeaToken, NewBoard).


moveWaiterToOther_4(Board, FromTable, TeaToken, NewBoard, NewSeat):-
	at(CountTable, FromTable, Board),
	count(CountTable, TeaToken, Total),
	Total > 3,

	at(Elem, FromTable, Board),
	find('W', 0, WaiterIndex, Elem),

	write('Triggered: \'Move Waiter To Table\'!'), nl,
	write('Insert table: '),
	getNumberInput(ToTable, 0, 8),

	at(NewTable, ToTable, Board),
	at(Token, WaiterIndex, NewTable),
	write(Token), nl,
	Token == '.',

	eraseWaiter(Board, 0, -1, NewBoard2),
	moveWaiter(NewBoard2, ToTable, WaiterIndex, NewBoard),
	assignValue(ToTable, NewSeat),
	write('NewSeat : '), write(NewSeat), nl.

swapTables_5(Board, _, _, NewBoard) :-
	assignValue(Board, NewBoard).
swapTables_5(Board, FromTable, TeaToken, NewBoard) :-
	at(CountTable, FromTable, Board),
	count(CountTable, TeaToken, Total),
	Total > 4,

	write('Triggered: \'Swap Table With Unclaimed\'!'), nl,
	write('Insert table: '),
	getUnclaimedTable(Board, ToTable),
	at(FromTableData, FromTable, Board),
	at(ToTableData, ToTable, Board),

	replace(FromTableData, ToTable, Board, NewBoard1),
	replace(ToTableData, FromTable, NewBoard1, NewBoard).

swapTables_4(Board, _, _, NewBoard) :-
	assignValue(Board, NewBoard).
swapTables_4(Board, FromTable, TeaToken, NewBoard) :-
	at(CountTable, FromTable, Board),
	count(CountTable, TeaToken, Total),
	Total == 4,

	write('Triggered: \'Swap Table With Unclaimed\'!'), nl,
	write('Insert table: '),
	getUnclaimedTable(Board, ToTable),
	at(FromTableData, FromTable, Board),
	at(ToTableData, ToTable, Board),

	replace(FromTableData, ToTable, Board, NewBoard1),
	replace(ToTableData, FromTable, NewBoard1, NewBoard).

rotateTable_4(Board, _, _, NewBoard) :-
	assignValue(Board, NewBoard).
rotateTable_4(Board, Table, TeaToken, NewBoard) :-
	at(TableElem, Table, Board),
	count(TableElem, TeaToken, Total),
	Total==4,

	write('Triggered: \'Rotate Table\'!'), nl,
	write('Insert number of clockwise rotations: '),
	getNumberInput(NRot, 0, 7),

	applyRotation(TableElem, NRot, RotatedTable),
	replace(RotatedTable, Table, Board, NewBoard).


eraseTea(Board, Table, Seat, NewBoard) :-
	at(Elem, Table, Board),
	write('Hello Elem: '), write(Elem), nl,
	replace('.', Seat, Elem, NewElem),
	replace(NewElem, Table, Board, NewBoard).
