at(Elem,0,[Elem|_]).
at(Elem,Index,[_|Tail]) :-
	Index1 is Index - 1,
	Index > 0,
	at(Elem,Index1,Tail).

assignValue(V1, V1).
assignValue(V1, V2) :-
	V1 \= V2,
	assignValue(V1, V1).

find(_, _, Start1, []) :-
	Start1 = -1.
find(Elem, Start, Start1, [Elem|_]) :-
	Start1 = Start.
find(ElemToFind, Start, End, [_|Tail]) :-
	Index1 is Start+1,
	find(ElemToFind, Index1, End, Tail).


count([],_,0).
count([Head|Tail], Head, Total) :-
	count(Tail, Head, Total1),
	Total is 1+Total1.
count([Head|Tail], Elem, Total) :-
	Head \= Elem,
	count(Tail, Elem, Total).

%countTableToken(TeaToken, Table, InitCount, Total):-

replace(New,0,[_|OldList],[New|OldList]).
replace(New,Index,[Head|OldList],[Head|NewList]):-
	Index > 0,
	Index1 is Index-1,
	replace(New,Index1,OldList,NewList).


%Gets a number from user that must be within [Min, Max]
getNumberInput(Input, Min, Max) :-
	repeat,
		get_code(Input1),
		peek_code(Enter),
		skip_line,
		Enter == 10,
		Input is Input1 - 48,
		Input @>= Min,
		Input @=< Max.

%asks for an unclaimed table
getUnclaimedTable(Board, BoardTable) :-
	write('Input an unclaimed table: '),
	repeat,
		getNumberInput(Table),
		at(BoardTable, Table, Board),
		count(BoardTable, 'O', TotalO),
		count(BoardTable, 'X', TotalX),
		TotalO @=< 4,
		TotalX @=< 4.

applyRotation(Table, NRotations, NewTable) :-
	applyRotation(Table, Table, NRotations, NewTable, 1).

applyRotation(Table, TableCopy, NRotations, NewTable, Index) :-
	Index \= 9,
	FinalIndex is ((Index + NRotations) mod 8),
	Index1 is Index + 1,
	at(Elem, Index, TableCopy),
	rotate(Table, Elem, FinalIndex, NewTable1),
	applyRotation(NewTable1, TableCopy, NRotations, NewTable, Index1).

applyRotation(Table, _, _, NewTable, 9) :-
	assignValue(Table, NewTable).

%Needed because the 0 position does not rotate
rotate(Table, BoardTable, 0, NewTable) :-
	replace(BoardTable, 8, Board, NewTable).
rotate(Table, BoardTable, FinalIndex, NewTable) :-
	FinalIndex \= 0,
	replace(BoardTable, FinalIndex, Board, NewTable).
