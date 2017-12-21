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
	addRowsRest(Result, RowRestrictions, SetNumbers, CardinalityLabel1, SumLabel1),
	addColsRest(Result, 0, ColNum, ColRestrictions, SetNumbers, CardinalityLabel2, SumLabel2),
	append(CardinalityLabel1, CardinalityLabel2, CardinalityLabel),
	append(SumLabel1, SumLabel2, SumLabel),
	labelAll(Result, CardinalityLabel, SumLabel, []).


%Adds the necessary restrictions to the rows
addRowsRest([], [], _, [], _).
addRowsRest([Row | BoardRemainder], [RowRest | RestRemainder], SetNumbers, [CardHead|CardTail], SumLabel) :-
	length(Row, RowSize),
	length(RowRest, RestSize),
	generateCardinality(SetNumbers, RestSize, RowSize, Cardinality, CardHead),
	addListRest(Cardinality, RowRest, Row, SumLabel),
	addRowsRest(BoardRemainder, RestRemainder, SetNumbers, CardTail, SumLabel).


addColsRest(_, End, End, _, _, [], _).
addColsRest(Board, Index, End, [ColRest | RestRemainder], SetNumbers, [CardHead|CardTail], SumLabel) :-
	Index < End,
	Inc is Index + 1,
	nthColumn(Board, Index, Column),
	length(Column, ColSize),
	length(ColRest, RestSize),
	generateCardinality(SetNumbers, RestSize, ColSize, Cardinality, CardHead),
	addListRest(Cardinality, ColRest, Column, SumLabel),
	addColsRest(Board, Inc, End, RestRemainder, SetNumbers, CardTail, SumLabel).


addListRest([], _, _, _).
addListRest(SetRest, SumRest, List, SumLabel) :-
	global_cardinality(List, SetRest),
	addSumRest(SumRest, List, SumLabel).


%Adds the restriction that list ListHead sum must be equal to RestHead
addSumRest([], _, _).
addSumRest(Restrictions, List, SumLabel) :-
	firstNotOf(List, -1, NewList),  % In case list starts in -1
	addSumRest(Restrictions, NewList, 0, -1, SumLabel).

% When restrictions are over
addSumRest([], _, _, _, _).

% addSumRest([RestHead | []], [], Total, _, _) :-
% 	nl, write('Rest Head = '), write(RestHead), nl,
% 	fail.

% When the list ends
addSumRest([RestHead | []], [], Total, _,  SumLabel) :-
	RestHead #= Total,
	SumHead #= Total,
	SumTail = [],
	write('\nIm here\n').

% When the list ends
addSumRest([Total | []], [Splitter | []], Total, Splitter,  [Total | []]) :-
	write('Total '), write(Total), nl.

addSumRest([Total | RestTail], [Splitter | ListTail], Total, Splitter, [Total|SumTail]) :- %When a splitter is found in the list check its current sum
	write('Total '), write(Total), nl,
	firstNotOf(ListTail, Splitter, NewListTail),
	addSumRest(RestTail, NewListTail, 0, Splitter, SumTail).

addSumRest(Restrictions, [ListHead | ListTail], Total, Splitter, SumLabel) :- % While no splitter is found within the list
	Inc #= Total + ListHead,
	addSumRest(Restrictions, ListTail, Inc, Splitter, SumLabel).



% Add SumLabel to the label list
labelAll([], [], SumLabel, Result) :-
	append(Result, SumLabel, NewResult),
	labeling([], NewResult).

% Add Cardinality Occurrences to the label list
labelAll([], [CardHead|CardTail], SumLabel, Result) :-
	append(Result, CardHead, NewResult).
	% labelAll([], CardTail, SumLabel, NewResult).

% Add board variables to the label list
labelAll([ListHead|ListTail], Cardinality, SumLabel, Result) :-
	append(Result, ListHead, NewResult),
	labelAll(ListTail, Cardinality, SumLabel, NewResult).


% start([1,1,3], [[4], [1,4], [2], [4]], [[], [3,1], [5], [4]], Result).
