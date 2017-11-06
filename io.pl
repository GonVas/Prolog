
drawSeatsTop(L) :-
	at(Token,3,L),
	write(Token).

drawSeatsTopMiddle(L) :-
	at(Token1,4,L), write(Token1),
	space(0,5), at(Token2,2,L), write(Token2).

drawSeatsMiddle(L) :-
	at(Token1,5,L), write(Token1),
	space(0,3), at(Token2,0,L), write(Token2),
	space(0,3), at(Token3,1,L), write(Token3).

drawSeatsBottomMiddle(L) :-
	at(Token1,6,L), write(Token1),
	space(0,5), at(Token2,8,L), write(Token2).

drawSeatsBottom(L) :-
	at(Token,7,L), write(Token).

drawBoard(Board) :-
	at(L1,3,Board),
	space(0,32), drawSeatsTop(L1), nl,
	space(0,29), drawSeatsTopMiddle(L1), nl,
	space(0,28), drawSeatsMiddle(L1), nl,
	space(0,29), drawSeatsBottomMiddle(L1), nl,
	space(0,32), drawSeatsBottom(L1), nl,

	at(L2,4,Board), at(L3,2,Board),
	space(0,14), drawSeatsTop(L2), space(0,33), drawSeatsTop(L3), nl,
	space(0,11), drawSeatsTopMiddle(L2), space(0,27), drawSeatsTopMiddle(L3), nl,
	space(0,10), drawSeatsMiddle(L2), space(0,25), drawSeatsMiddle(L3), nl,
	space(0,11), drawSeatsBottomMiddle(L2), space(0,27), drawSeatsBottomMiddle(L3), nl,
	space(0,14), drawSeatsBottom(L2), space(0,33), drawSeatsBottom(L3), nl,

	at(L4,5,Board), at(L5,0,Board), at(L6,1,Board),
	space(0,5), drawSeatsTop(L4), space(0,26), drawSeatsTop(L5), space(0,26), drawSeatsTop(L6), nl,
	space(0,2), drawSeatsTopMiddle(L4), space(0,20), drawSeatsTopMiddle(L5), space(0,20), drawSeatsTopMiddle(L6), nl,
	space(0,1), drawSeatsMiddle(L4), space(0,18), drawSeatsMiddle(L5), space(0,18), drawSeatsMiddle(L6), nl,
	space(0,2), drawSeatsBottomMiddle(L4), space(0,20), drawSeatsBottomMiddle(L5), space(0,20), drawSeatsBottomMiddle(L6), nl,
	space(0,5), drawSeatsBottom(L4), space(0,26), drawSeatsBottom(L5), space(0,26), drawSeatsBottom(L6), nl,

	at(L7,6,Board), at(L8,8,Board),
	space(0,14), drawSeatsTop(L7), space(0,33), drawSeatsTop(L8), nl,
	space(0,11), drawSeatsTopMiddle(L7), space(0,27), drawSeatsTopMiddle(L8), nl,
	space(0,10), drawSeatsMiddle(L7), space(0,25), drawSeatsMiddle(L8), nl,
	space(0,11), drawSeatsBottomMiddle(L7), space(0,27), drawSeatsBottomMiddle(L8), nl,
	space(0,14), drawSeatsBottom(L7), space(0,33), drawSeatsBottom(L8), nl,

	at(L9,7,Board),
	space(0,32), drawSeatsTop(L9), nl,
	space(0,29), drawSeatsTopMiddle(L9), nl,
	space(0,28), drawSeatsMiddle(L9), nl,
	space(0,29), drawSeatsBottomMiddle(L9), nl,
	space(0,32), drawSeatsBottom(L9), nl.

space(M,M).
space(I,M):-
  write(' '),
  N1 is I+1,
  space(N1,M).
