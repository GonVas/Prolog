
generateValidPlay(TableNumber, SeatNumber, Board) :-
	at(BoardTable, TableNumber, Board),
	repeat,
		random(0, 9, SeatNumber),
		at(Token, SeatNumber, BoardTable),
		Token == '.'.

aiTurn(TeaToken, TableNumber, Board, NewBoard, NewTableNumber) :-
	write('AI '), write(TeaToken), write(' turn:'),
	generateValidPlay(TableNumber, SeatNumber, Board),
	write(SeatNumber), nl,
	serveTea(Board, TableNumber, SeatNumber, TeaToken, NewBoard1),
	handleWaiter(NewBoard1, SeatNumber, NewBoard2, NewTableNumber),
	checkSpecials(NewBoard2, TableNumber, SeatNumber,  TeaToken, NewBoard, NewSeatNumber2, 1),
	drawBoard(NewBoard).
