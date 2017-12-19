:-use_module(library(clpfd)).


/**
 * @brief Generates a list capable of being passed as an argument to global_cardinality
 * @param SetNumbers The received set numbers from the user
 * @param StartNumber The number of -1 to put on the end list (corresponds to the number of subdivisions of the list)
 * 				Can be easily calculated according to the list length of the columns and row restrictions
 */
generateCardinality(SetNumbers, [ResHead | ResTail]) :-
	ResHead = -1-_,
	generateCardinality(SetNumbers, ResTail, []).

generateCardinality([], [], _).
generateCardinality([SetNumbersHead|SetNumbersTail], [ResHead|ResTail], Parsed) :-
	\+ member(SetNumbersHead, Parsed),
	count([SetNumbersHead|SetNumbersTail], SetNumbersHead, Maximum),
	Occurrences in 0..Maximum,
	ResHead = SetNumbersHead-Occurrences,
	append([SetNumbersHead], Parsed, NewParsed),
	generateCardinality(SetNumbersTail, ResTail, NewParsed).
generateCardinality([SetNumbersHead|SetNumbersTail], Res, Parsed) :-
	member(SetNumbersHead, Parsed),
	generateCardinality(SetNumbersTail, Res, Parsed).

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
nthElement([Element | _], 0, Element).
nthElement([_ | ListTail], Index, Element) :-
	Dec is Index - 1,
	nthElement(ListTail, Dec, Element).

nthColumn([], _, []).
nthColumn([Row | Remainder], Index, [ResHead | ResTail]) :-
	nthElement(Row, Index, ResHead),
	nthColumn(Remainder, Index, ResTail).

sumElems([], 0).
sumElems([ListHead|ListTail], Total) :-
	sumElems(ListTail, Rest),
	Total #= (ListHead + Rest).

labelAll([]).
labelAll([ListHead|ListTail]) :-
	labeling([], ListHead),
	labelAll(ListTail).
