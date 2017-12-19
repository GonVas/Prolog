:-use_module(library(clpfd)).
:-use_module(library(lists)).



generateCardinality(SetNumbers, RestNumber, MaxSize, [ResultHead | ResultTail], [LabelHead | LabelTail]) :-
	addWallsCardinality(RestNumber, MaxSize, ResultHead, LabelHead),
	addNumbersCardinality(SetNumbers, ResultTail, LabelTail, []).

addWallsCardinality(0, MaxSize, Restriction, Label) :-
	Range in 0..MaxSize,
	Label #= Range,
	Restriction = -1-Range.
addWallsCardinality(RestNumber, MaxSize, Restriction, Label) :-
	RestNumber \= 0,
	Minimum is RestNumber - 1,
	Maximum is MaxSize - Minimum - 1,
	Range in Minimum..Maximum,
	Label #= Range,
	Restriction = -1-Range.

addNumbersCardinality([], [], [], _).
addNumbersCardinality([SetNumbersHead|SetNumbersTail], [ResHead|ResTail], [LabelHead | LabelTail], Parsed) :-
	\+ member(SetNumbersHead, Parsed),
	count([SetNumbersHead|SetNumbersTail], SetNumbersHead, Maximum),
	Occurrences in 0..Maximum,
	ResHead = SetNumbersHead-Occurrences,
	LabelHead #= Occurrences,
	append([SetNumbersHead], Parsed, NewParsed),
	addNumbersCardinality(SetNumbersTail, ResTail, LabelTail, NewParsed).
addNumbersCardinality([SetNumbersHead|SetNumbersTail], Res, Label, Parsed) :-
	member(SetNumbersHead, Parsed),
	addNumbersCardinality(SetNumbersTail, Res, Label, Parsed).

%Counts the number of occurrences of Token in List
count([], _, 0).
count([Token | ListTail], Token, Result) :-
	count(ListTail, Token, Total),
	Result is Total + 1.
count([ListHead | ListTail], Token, Result) :-
	ListHead \= Token,
	count(ListTail, Token, Total),
	Result = Total.

firstNotOf([ListHead | ListTail], Elem, Result) :-
	ListHead #\= Elem,
	Result = [ListHead|ListTail].
firstNotOf([Elem | ListTail], Elem, Result) :-
	firstNotOf(ListTail, Elem, Result).

nthElement([], Index, _) :-
	Index > 0,
	write('Error nthElement(), accessing '), write(Index), write('element out of bounds!\n'),
	fail.
nthElement([Head | _], 0, Element) :-
	Element = Head.
nthElement([_ | ListTail], Index, Element) :-
	Index >= 0,
	Dec is Index - 1,
	nthElement(ListTail, Dec, Element).


nthColumn([], _, []).
nthColumn([Row | Remainder], Index, [ResHead | ResTail]) :-
	nth0(Index, Row, ResHead),
	nthColumn(Remainder, Index, ResTail).

sumElems([], 0).
sumElems([ListHead|ListTail], Total) :-
	sumElems(ListTail, Rest),
	Total #= (ListHead + Rest).

labelAll([]).
labelAll([ListHead|ListTail]) :-
	labeling([], ListHead),
	labelAll(ListTail).
