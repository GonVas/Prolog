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
count([X|T],X,Y):- count(T,X,Z), Y is 1+Z.
count([X1|T],X,Z):- X1\=X,count(T,X,Z).

%countTableToken(TeaToken, Table, InitCount, Total):-

replace(New,0,[_|OldList],[New|OldList]).
replace(New,Index,[Head|OldList],[Head|NewList]):-
	Index > 0,
	Index1 is Index-1,
	replace(New,Index1,OldList,NewList).
