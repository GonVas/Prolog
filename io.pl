:-use_module(library(lists)).


printLine(ColNumber, ColNumber) :-
	write('--') , nl.
printLine(ColNumber, Start) :-
	Start < ColNumber,
	write('-----'),
	Inc is Start + 1,
	printLine(ColNumber, Inc).

addSpace(Num, MaxNum) :-
	Diff is MaxNum - Num,
	TotalSpaces is Diff * 2 + Diff,
	space(TotalSpaces).

printRows([], [], _, _).
printRows([Row | RowRemainder], [RowRest | RestRemainder], MaxRowRestNum, ColNumber) :-
	printRowRest(RowRest),
	length(RowRest, RestNum),
	addSpace(RestNum, MaxRowRestNum),
	write('|'),
	printRow(Row), nl,
	addSpace(0, MaxRowRestNum),
	printLine(ColNumber, 1),
	printRows(RowRemainder, RestRemainder, MaxRowRestNum, ColNumber).

printRow([]).
printRow([RowHead | RowTail]) :-
	RowHead \= -1,
	space(1), write(RowHead), write(' |'),
	printRow(RowTail).
printRow([-1 | RowTail]) :-
	space(1), write('#'), write(' |'),
	printRow(RowTail).

printRowRest([]).
printRowRest([RestHead | RestTail]) :-
	space(1), write(RestHead), space(1),
	printRowRest(RestTail).


printGame(Board, ColRest, RowRest, ColNumber, RowNumber) :-
	maxSize(ColRest, MaxColRestNum), maxSize(RowRest, MaxRowRestNum),
	printColRest(ColRest, MaxColRestNum, MaxRowRestNum),
	addSpace(0, MaxRowRestNum),
	printLine(ColNumber, 1),
	printRows(Board, RowRest, MaxRowRestNum, ColNumber).


printColRest(ColRest, MaxColRestNum, MaxRowRestNum) :-
	printColRestNums(ColRest, 0, MaxColRestNum, MaxRowRestNum).
printColRestNums(_, MaxColRestNums, MaxColRestNums, _).
printColRestNums(ColRest, Curr, MaxColRestNums, MaxRowRestNums) :-
	NSpaces is (MaxRowRestNums * 2),
	space(NSpaces),
	printColRestNum(ColRest, Curr, MaxColRestNums), nl,
	NewCurr is Curr + 1,
	printColRestNums(ColRest, NewCurr, MaxColRestNums, MaxRowRestNums).

printColRestNum([], _, _).
printColRestNum([RestHead | RestTail], Curr, MaxRestNum) :-
	Index is MaxRestNum - Curr,
	length(RestHead, HeadLen),
	HeadLen < Index,
	space(5),
	printColRestNum(RestTail, Curr, MaxRestNum).
printColRestNum([RestHead | RestTail], Curr, MaxRestNum) :-
	Index is MaxRestNum - Curr,
	length(RestHead, HeadLen),
	HeadLen >= Index,
	nth1(Index, RestHead, Num),
	space(2), write(Num), space(2),
	printColRestNum(RestTail, Curr, MaxRestNum).


maxSize(List, Max) :-
	maxSize(List, 0, 0, Max).
maxSize([], _, Max, Max).
maxSize([ListHead | ListTail], Previous, CurrMax, Max) :-
	Previous > CurrMax,
	length(ListHead, Len),
	maxSize(ListTail, Len, Previous, Max).

maxSize([ListHead | ListTail], Previous, CurrMax, Max) :-
	Previous =< CurrMax,
	length(ListHead, Len),
	maxSize(ListTail, Len, CurrMax, Max).


space(Num) :-
	space(0, Num).

space(Num, Num).
space(Curr, Num) :-
	Curr < Num,
	write(' '),
	NewCurr is Curr + 1,
	space(NewCurr, Num).
