
moveOneToOther_3(Board, FromTable, TeaToken, NewBoard):-
	at(CountTable, FromTable, Board),
	count(CountTable, TeaToken, Total),
	Total > 2,

	%	write('Do you want to trigger special, move one piece to other table (y/n): '), nl,
	%	get_code(Permission),
	%	Permission ==  121, % 'y' character

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
	%	write('Elem is : '), write(Elem), nl,
	at(Token, Seat2, Elem),
	%	write('Token is : '), write(Token), nl,
	Token == '.',

	%	write('Going to erasing Tea'), nl,
	eraseTea(Board, FromTable, Seat, NewBoard1),
	%	write('Erased Tea'), nl,
	serveTea(NewBoard1, ToTable, Seat2, TeaToken, NewBoard).
	%	write('Served Tea'), nl.


moveOneToOther_3(Board,_,_,NewBoard):-
	%write('Couldnt trigger moveOneToOther_3.'), nl,
	assignValue(Board, NewBoard).


moveWaiterToOther_4(Board, FromTable, TeaToken, NewBoard, NewSeat):-
	at(CountTable, FromTable, Board),
	count(CountTable, TeaToken, Total),
	Total > 3,

	at(Elem, FromTable, Board),
	find('W', 0, WaiterIndex, Elem),

	write('WaiterIndex : '), write(WaiterIndex), nl,

	repeat,
	write('Triggered Special Move, Move Waiter To other Table: '), nl,
	get_code(Table1),
	ToTable is Table1 - 48,
	ToTable < 9,
	ToTable >= 0,
	get_code(_),

	at(NewTable, ToTable, Board),
	at(Token, WaiterIndex, NewTable),
	write(Token), nl,
	Token == '.',

	eraseWaiter(Board, 0, -1, NewBoard2),

	moveWaiter(NewBoard2, ToTable, WaiterIndex, NewBoard),

	assignValue(ToTable, NewSeat),

	write('NewSeat : '), write(NewSeat), nl.


	%moveWaiterToOther_4(Board, _, _, NewBoard):-
	%	assignValue(Board, NewBoard).


replaceTables_5(Board, FromTable, TeaToken, NewBoard) :-
	at(CountTable, FromTable, Board),
	count(CountTable, TeaToken, Total),
	Total > 4,

	repeat,
	write('Triggered Special Move, Move this Table To Unclaimed: '), nl,
	get_code(Table1),
	ToTable is Table1 - 48,
	ToTable < 9,
	ToTable >= 0,
	get_code(_),

	at(ToTableData, ToTable, Board),
	at(FromTableData, FromTable, Board),

	%assignValue(FromTable, FromTableBuffer),

	replace(FromTableData, ToTable, Board, NewBoard1),
	replace(ToTableData, FromTable, NewBoard1, NewBoard),

	write('Done Move Table'), nl.


replaceTables_5(Board, _, _, NewBoard) :-
	assignValue(Board, NewBoard).

eraseTea(Board, Table, Seat, NewBoard) :-
	at(Elem, Table, Board),
	write('Hello Elem: '), write(Elem), nl,
	replace('.', Seat, Elem, NewElem),
	replace(NewElem, Table, Board, NewBoard).
