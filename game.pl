:-include('utils.pl').
:-use_module(library(clpfd)).
/*
start([1,1,3], [[4], [1,4], [2], [4]], [[], [3,1], [5], [4]], Result).
*/

start(SetNumbers, ColRestrictions, RowRestrictions, Result) :-
	length(ColRestrictions, ColNum),
	length(RowRestrictions, RowNum),
	startBoard(ColNum, RowNum, Result), !,
	addRowsRest(Result, RowRestrictions, SetNumbers),
	addColsRest(Result, ColNum, ColRestrictions, SetNumbers),
	labelAll(Result).


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

%Adds the necessary restrictions to the rows
addRowsRest([], [], _).
addRowsRest([Row | BoardRemainder], [RowRest | RestRemainder], SetNumbers) :-
	length(Row, RowSize),
	length(RowRest, RestSize),
	generateCardinality(SetNumbers, RestSize, RowSize, Cardinality, CardinalityLabel),
	labeling([], CardinalityLabel),
	write('\nAdding Row List Restrictions\n'),
	addListRest(Cardinality, RowRest, Row),
	addRowsRest(BoardRemainder, RestRemainder, SetNumbers).

%Adds the necessary restrictions to the columns
addColsRest(Board, ColNumber, ColRests, SetNumbers) :-
	addColsRest(Board, 0, ColNumber, ColRests, SetNumbers).
addColsRest(_, End, End, _, _).
addColsRest(Board, Index, End, [ColRest | RestRemainder], SetNumbers) :-
	Index < End,
	Inc is Index + 1,
	nthColumn(Board, Index, Column),
	length(Column, ColSize),
	length(ColRest, RestSize),
	generateCardinality(SetNumbers, RestSize, ColSize, Cardinality, CardinalityLabel),
	labeling([], CardinalityLabel),
	write('\nAdding Column List Restrictions\n'),
	addListRest(Cardinality, ColRest, Column),
	addColsRest(Board, Inc, End, RestRemainder, SetNumbers).


addListRest([], _).
addListRest(SetRest, SumRest, List) :-
	global_cardinality(List, SetRest),
	addSumRest(SumRest, List).

%Adds the restriction that list ListHead sum must be equal to RestHead
addSumRest([], _).
addSumRest(Restrictions, List) :-
	addSumRest(Restrictions, List, 0, -1).

addSumRest([], [], _, _).
addSumRest(Restrictions, [Splitter | ListTail], 0, Splitter) :-
	firstNotOf(ListTail, Splitter, NewListTail),
	addSumRest(Restrictions, NewListTail, 0, Splitter).
addSumRest([RestHead | RestTail], [ListHead | ListTail], Total, Splitter) :-
	ListHead #= Splitter,
	RestHead #= Total,
	addSumRest(RestTail, ListTail, 0, Splitter).
addSumRest(Restrictions, [ListHead | ListTail], Total, Splitter) :-
	Inc #= Total + ListHead,
	addSumRest(Restrictions, ListTail, Inc, Splitter).

% start([1,1,3], [[4], [1,4], [2], [4]], [[], [3,1], [5], [4]], Result).
