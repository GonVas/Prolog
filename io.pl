specToChar(0, 'XMT').
specToChar(1, 'OMT').
specToChar(2, 'XMW').
specToChar(3, 'OMW').
specToChar(4, 'ROT').
specToChar(5, 'ROT').
specToChar(6, 'SUU').
specToChar(7, 'SCU').

%draws top seats
drawST(L) :-
	at(Token,3,L),
	write(Token).
%draws top middle seats
drawSTM(L) :-
	at(Token1,4,L), write(Token1),
	space(5), at(Token2,2,L), write(Token2).
%draws middle seats
drawSM(L) :-
	at(Token1,5,L), write(Token1),
	space(3), at(Token2,0,L), write(Token2),
	space(3), at(Token3,1,L), write(Token3).
%draws bottom middle seats
drawSBM(L) :-
	at(Token1,6,L), write(Token1),
	space(5), at(Token2,8,L), write(Token2).
%draws bottom seats
drawSB(L) :-
	at(Token,7,L), write(Token).

%draws special top
drawSpecT(L) :-
	at(Temp, 2, L), specToChar(Temp, Token),
	write(Token).
%draws special top middle
drawSpecTM(L) :-
	at(Temp1, 3, L), at(Temp2, 1, L),
	specToChar(Temp1, Token1), specToChar(Temp2, Token2),
	write(Token1), space(3), write(Token2).
%draws special middle
drawSpecM(L) :-
	at(Temp1, 4, L), at(Temp2, 0, L),
	specToChar(Temp1, Token1), specToChar(Temp2, Token2),
	write(Token1), space(5), write(Token2).
%draws special bottom middle
drawSpecBM(L) :-
	at(Temp1, 5, L), at(Temp2, 7, L),
	specToChar(Temp1, Token1), specToChar(Temp2, Token2),
	write(Token1), space(3), write(Token2).
%draws special bottom
drawSpecB(L) :-
	at(Temp, 6, L), specToChar(Temp, Token), write(Token).


drawBoard(Board) :-
	Example = [0,1,2,3,4,5,6,7,8],
	at(L1,3,Board),
	at(Specials, 9, Board),
	space(4), drawST(Example), space(27), drawST(L1), space(25), drawSpecT(Specials), nl,
	space(1), drawSTM(Example), space(21), drawSTM(L1), space(19), drawSpecTM(Specials), nl,
	drawSM(Example), space(19), drawSM(L1), space(17), drawSpecM(Specials), nl,
	space(1), drawSBM(Example), space(21), drawSBM(L1), space(19), drawSpecBM(Specials), nl,
	space(4), drawSB(Example), space(27), drawSB(L1), space(25), drawSpecB(Specials), nl,

	at(L2,4,Board), at(L3,2,Board),
	space(14), drawST(L2), space(33), drawST(L3), nl,
	space(11), drawSTM(L2), space(27), drawSTM(L3), nl,
	space(10), drawSM(L2), space(25), drawSM(L3), nl,
	space(11), drawSBM(L2), space(27), drawSBM(L3), nl,
	space(14), drawSB(L2), space(33), drawSB(L3), nl,

	at(L4,5,Board), at(L5,0,Board), at(L6,1,Board),
	space(9), drawST(L4), space(22), drawST(L5), space(22), drawST(L6), nl,
	space(6), drawSTM(L4), space(16), drawSTM(L5), space(16), drawSTM(L6), nl,
	space(5), drawSM(L4), space(14), drawSM(L5), space(14), drawSM(L6), nl,
	space(6), drawSBM(L4), space(16), drawSBM(L5), space(16), drawSBM(L6), nl,
	space(9), drawSB(L4), space(22), drawSB(L5), space(22), drawSB(L6), nl,

	at(L7,6,Board), at(L8,8,Board),
	space(14), drawST(L7), space(33), drawST(L8), nl,
	space(11), drawSTM(L7), space(27), drawSTM(L8), nl,
	space(10), drawSM(L7), space(25), drawSM(L8), nl,
	space(11), drawSBM(L7), space(27), drawSBM(L8), nl,
	space(14), drawSB(L7), space(33), drawSB(L8), nl,

	at(L9,7,Board),
	space(32), drawST(L9), nl,
	space(29), drawSTM(L9), nl,
	space(28), drawSM(L9), nl,
	space(29), drawSBM(L9), nl,
	space(32), drawSB(L9), nl.

space(End,End).
space(Start,End):-
  write(' '),
  Start1 is Start+1,
  space(Start1,End).

space(Number) :-
	space(0, Number).
