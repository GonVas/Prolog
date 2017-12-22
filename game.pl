:-include('utils.pl').
:-include('io.pl').
:-use_module(library(clpfd)).
:-use_module(library(random)).
:-use_module(library(lists)).

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
	labelAll(Result, CardinalityLabel, []),
	printGame(Result, ColRestrictions, RowRestrictions, ColNum, RowNum).


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


addSumRest([], [], _, _). 	% When restrictions are over and list is over
addSumRest([Total | []], [], Total, _). 	% When the list ends case 1

%When a splitter is found in the list check its current sum
addSumRest([Total | RestTail], [Splitter | ListTail], Total, Splitter) :-
	firstNotOf(ListTail, Splitter, NewListTail),
	addSumRest(RestTail, NewListTail, 0, Splitter).

% While no splitter is found within the list
addSumRest(Restrictions, [ListHead | ListTail], Total, Splitter) :-
	ListHead #\= Splitter,
	Restrictions \= [],
	Inc #= Total + ListHead,
	addSumRest(Restrictions, ListTail, Inc, Splitter).



reset_timer :- statistics(walltime,_).
print_time :-
	statistics(walltime,[_,T]),
	TS is ((T//10)*10)/1000,
	nl, write('Time: '), write(TS), write('s'), nl, nl.

% Label the Result
labelAll([], [], Result) :-
	reset_timer,
	labeling([], Result),
	print_time,
	fd_statistics.

% Add Cardinality Occurrences to the label list
labelAll([], [CardHead|CardTail], Result) :-
	append(Result, CardHead, NewResult),
	labelAll([], CardTail, NewResult).

% Add board variables to the label list
labelAll([ListHead|ListTail], Cardinality, Result) :-
	append(Result, ListHead, NewResult),
	labelAll(ListTail, Cardinality, NewResult).


generate_puzzle(SetNumbers, Size, Result):-
	Size > 2,
	length(SetNumbers, L),
	L > 2,
	repeat,
	generateRest(SetNumbers, Size, RowRes),
	generateRest(SetNumbers, Size, ColumnRest),
	start(SetNumbers, ColumnRest, RowRes, Result), !.

generateRest(SetNumbers, Size, Result):-
    length( Result, Size),
    maplist( generateInsideRest(SetNumbers, Size), Result).

generateInsideRest(SetNumbers, Size, Rest):-
	list_min(SetNumbers, Min),
	list_max(SetNumbers, Max),
	length(SetNumbers, SetLength),
   	Place is SetLength-2,
	nth0(Place, SetNumbers, Elem),

	random(0, Size, NumberRests),

	%Erase this part and use only NumberRest if you want more restrictions, but it will take alot of time for size > 4
	random(0, 2, SubRests),
	NumberRests1 is max(0, NumberRests-SubRests),

	length(Rest, NumberRests1),
    MaxRandom is Max+Elem,
	maplist(random(Min, MaxRandom), Rest).

%generate_puzzle([1,2,3,4,5], 4, Result).

/*

example puzzles:

(4x4)
start( [0,1,2,3], [[6], [0,3], [3], [4,2]], [[3,1], [1,5], [2,1], [5]], Result).
0,1,2,3

	  0   4
	6 3 3 2
3 1 3 0 # 1
1 5	1 # 2 3
2 1 2 # 1 #
  5 # 3 0 2


(6x6)
start( [1,2,3,4], [[], [1,3,6], [2,4,4], [10], [5,5], []], [[10], [4,6], [10], [10], [5,5], []], Result).
           6    4
           3    4         5
           1    2    10    5
      ---------------------------
 10    | # | 1 | 2 | 3 | 4 | # |
      ---------------------------
 4  6 | 4 | # | # | 2 | 1 | 3 |
      ---------------------------
 10    | 2 | 3 | 1 | 4 | # | # |
      ---------------------------
 10    | # | # | 3 | 1 | 2 | 4 |
      ---------------------------
 5  5 | 1 | 4 | # | # | 3 | 2 |
      ---------------------------
      | # | 2 | 4 | # | # | # |
      ---------------------------


(7x7)
start( [1,2,3,4,5,6,7,8,9], [[4,21], [8,8,7], [10,16], [9,1], [13, 11], [1,9,11], [13, 8]], [[8,16], [6,4,9], [], [22, 6, 3], [], [5,7,14], [16,8]], Result).
1,2,3,4,5,6,7,8,9

		  8         1
	   4  8 10 9 13 9  13
	   21 7 16 1 11 11 8
  8 16 3  5 #  9 2  1  4
6 4 9  1  3 2  # 4  #  9
       #  # 3  # 1  9  #
22 6 3 9  8 5  # 6  #  3
       7  # #  1 #  #  5
5 7 14 5  # 7  # 8  6  #
  16 8 #  7 9  # 3  5  #
*/