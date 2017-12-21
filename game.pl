:-include('utils.pl').
:-use_module(library(clpfd)).
/*
	start([1,1,3], [[4], [1,4], [2], [4]], [[], [3,1], [5], [4]], Result).
*/

printAll :-
	findall(Result, start([1,1,3], [[4], [1,4], [2], [4]], [[], [3,1], [5], [4]], Result), List),
	printAll(List).

printAll([]).
printAll([Head|Tail]) :-
	write(Head), nl,
	printAll(Tail).

%Instantiates the board with the given number of columns and rows
startBoard(_, 0, []).
startBoard(ColNum, RowNum, [RowsHead|RowsTail]) :-
	startRow(ColNum, RowsHead),
	domain(RowsHead, -1, 9),
	Decrement is RowNum - 1,
	startBoard(ColNum, Decrement, RowsTail).
startRow(0, []).
startRow(RowNum, [RowHead|RowTail]) :-
	RowHead #= _,
	Decrement is RowNum - 1,
	startRow(Decrement, RowTail).

start(SetNumbers, ColRestrictions, RowRestrictions, Result) :-
	length(ColRestrictions, ColNum),
	length(RowRestrictions, RowNum),
	startBoard(ColNum, RowNum, Result), !,
	addRowsRest(Result, RowRestrictions, SetNumbers, CardinalityLabel1),
	addColsRest(Result, 0, ColNum, ColRestrictions, SetNumbers, CardinalityLabel2),
	append(CardinalityLabel1, CardinalityLabel2, CardinalityLabel),
	labelAll(Result, CardinalityLabel, []).


%Adds the necessary restrictions to the rows
addRowsRest([], [], _, []).
addRowsRest([Row | BoardRemainder], [RowRest | RestRemainder], SetNumbers, [CardHead|CardTail]) :-
	length(Row, RowSize),
	length(RowRest, RestSize),
	generateCardinality(SetNumbers, RestSize, RowSize, Cardinality, CardHead),
	addListRest(Cardinality, RowRest, Row),
	addRowsRest(BoardRemainder, RestRemainder, SetNumbers, CardTail).


addColsRest(_, End, End, _, _, []).
addColsRest(Board, Index, End, [ColRest | RestRemainder], SetNumbers, [CardHead|CardTail]) :-
	Index < End,
	Inc is Index + 1,
	nthColumn(Board, Index, Column),
	length(Column, ColSize),
	length(ColRest, RestSize),
	generateCardinality(SetNumbers, RestSize, ColSize, Cardinality, CardHead),
	addListRest(Cardinality, ColRest, Column),
	addColsRest(Board, Inc, End, RestRemainder, SetNumbers, CardTail).


addListRest([], _, _, _).
addListRest(SetRest, SumRest, List) :-
	global_cardinality(List, SetRest),
	addSumRest(SumRest, List).


%Adds the restriction that list ListHead sum must be equal to RestHead
addSumRest([], _).
addSumRest(Restrictions, List) :-
	firstNotOf(List, -1, NewList),  % In case list starts in -1
	addSumRest(Restrictions, NewList, 0, -1).

% When restrictions are over and list is over
addSumRest([], [], _, _).

% When the list ends case 1
addSumRest([RestHead | []], [], Total, _) :-
	RestHead #= Total,
	write('List Ended case 1, tot = '), write(Total), nl.

% When the list ends case 2
addSumRest([RestHead | []], [Splitter | []], Total, Splitter) :-
	RestHead #= Total,
	write('List Ended case 2, tot = '), write(Total), nl.

addSumRest([Total | RestTail], [Splitter | ListTail], Total, Splitter) :- %When a splitter is found in the list check its current sum
	write('Total '), write(Total), nl,
	firstNotOf(ListTail, Splitter, NewListTail),
	addSumRest(RestTail, NewListTail, 0, Splitter).

addSumRest(Restrictions, [ListHead | ListTail], Total, Splitter) :- % While no splitter is found within the list
	Inc #= Total + ListHead,
	addSumRest(Restrictions, ListTail, Inc, Splitter).



% Add SumLabel to the label list
labelAll([], [], Result) :-
	labeling([], NewResult).

% Add Cardinality Occurrences to the label list
labelAll([], [CardHead|CardTail], Result) :-
	append(Result, CardHead, NewResult).
	% labelAll([], CardTail, SumLabel, NewResult).

% Add board variables to the label list
labelAll([ListHead|ListTail], Cardinality, Result) :-
	append(Result, ListHead, NewResult),
	labelAll(ListTail, Cardinality, NewResult).


% start([1,1,3], [[4], [1,4], [2], [4]], [[], [3,1], [5], [4]], Result).
