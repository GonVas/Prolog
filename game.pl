:-include('utils.pl').
:-use_module(library(clpfd)).
/*
start([1,1,3], [[4], [1,4], [2], [4]], [[], [3,1], [5], [4]], Result).
*/

start(SetNumbers, ColRestrictions, RowRestrictions, Result) :-
	length(ColRestrictions, ColNum),
	length(RowRestrictions, RowNum),
	startBoard(ColNum, RowNum, Result),
	addRowsRest(Result, RowRestrictions, SetNumbers),
	write('Added Row Restrictions\n'),
	addColsRest(Result, ColNum, ColRestrictions, SetNumbers),
	write('Added Column Restrictions\nStarting Labeling!\n'),
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
	write('Iteration '), write(RowRest), nl,
	generateCardinality(SetNumbers, Cardinality),
	addListRest(Cardinality, RowRest, Row),
	addRowsRest(BoardRemainder, RestRemainder, SetNumbers).

%Adds the necessary restrictions to the columns
addColsRest(Board, ColNumber, ColRests, SetNumbers) :-
	addColsRest(Board, 0, ColNumber, ColRests, SetNumbers).
addColsRest(_, End, End, _, _).
addColsRest(Board, Index, End, [ColRest | RestRemainder], SetNumbers) :-
	Index < End,
	Inc is Index + 1,
	generateCardinality(SetNumbers, Cardinality),
	nthColumn(Board, Index, Column),
	addListRest(Cardinality, ColRest, Column),
	addColsRest(Board, Inc, End, RestRemainder, SetNumbers).

/**
 * @param SetRest List containing the restrictions of the set, should be of type [num1-ocurrences, num2-ocurrences, -1-ocurrences]
 * @param ColRest List of type [num1, num2, num3, ...]
 * @param List A list of type [num1, num2, num3, ...]
 */
addListRest([], _).
addListRest(SetRest, SumRest, List) :-
	write('Cardinality = '), write(SetRest), nl,nl,
	global_cardinality(List, SetRest),
	addSumRest(SumRest, List).

%Adds the restriction that list ListHead sum must be equal to RestHead
addSumRest([], _).
addSumRest(Restrictions, List) :-
	write('addSumRest('), write(Restrictions), write(', '), write(List), write(') \n'),
	firstNotOf(List, -1, NewList),
	addSumRest(Restrictions, NewList, 0, -1).


addSumRest([], [], _, _).
addSumRest(_, [], _, _).
addSumRest([RestHead|RestTail], [Splitter|ListTail], Total, Splitter) :-
	RestHead #= Total,
	firstNotOf(ListTail, Splitter, NewListTail),
	addSumRest(RestTail, NewListTail, 0, Splitter).

addSumRest(Restrictions, [ListHead|ListTail], Total, Splitter) :-
	Inc #= Total + ListHead,
	addSumRest(Restrictions, ListTail, Inc, Splitter).
