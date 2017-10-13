%%%%%%%%%%%%%%%%%%%%% Main Menu %%%%%%%%%%%%%%%%%%%%%%%%%%
mainCliMenu :-
	clearScreen,
	printMainMenu,
	getChar(In),
	(
		In = '1' -> write('Chose to play\n'), playMenu;
		In = '2' -> write('Chose Info\n'), infoMenu;
		In = '3' -> write('Chose Exit\n');
	
		mainMenu
	).
	
%%%%%%%%%%%%%%%%%%%%% Play Menu %%%%%%%%%%%%%%%%%%%%%%%%%%
playMenu :-
	clearScreen,
	printPlayMenu,
	getChar(In),
	(
		In = '1' -> write('Chose to play Human vs Human\n'), startHumanVsHuman, playMenu;
		In = '2' -> write('Chose to play Human vs PC\n'), playMenu;
		In = '3' -> write('Chose to play PC vs PC\n'), playMenu;
		In = '4' -> write('Chose to Go back\n'), mainMenu;
		
		playMenu
	).
	
%%%%%%%%%%%%%%%%%%%%% Info Menu %%%%%%%%%%%%%%%%%%%%%%%%%%
infoMenu :-
	clearScreen,
	printInfoMenu,
	get_char(_),   % Waits for any input
	mainMenu.

	
%%%%%%%%%%%%%%%%%%%%%%%% Print MainMenu %%%%%%%%%%%%%%%%%%%%%	
printMenu :-
	write('======================================\n'),
	write('=                Oolong              =\n'),
	write('=             ============           =\n'),
	write('=                                    =\n'),
	write('=              1 - Start             =\n'),
	write('=              2 - Rules             =\n'),
	write('=              3 - Exit              =\n'),
	write('=                                    =\n'),
	write('=                                    =\n'),
	write('=  Goncalo Moreno        up201503871 =\n'),
	write('=  Joao Almeida          up201505866 =\n'),
	write('======================================\n').
	
%%%%%%%%%%%%%%% Clears the entire screen %%%%%%%%%%%%%%%%%%%
clearScreen :-
	printBlank(65).
	
%%%%%%%%%%%%%%% Blank line %%%%%%%%%%%%%%%%%%%
printBlank(A) :-
	A > 0,
	nl,
	A1 is A - 1,
	printBlank(A1).
	
printBlank(_).	
