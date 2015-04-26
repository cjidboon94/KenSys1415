%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Koen van der Keijl - 10555900  %%%%
%% Cornelis Boon - 10561145       %%%%
%% Database voor opdracht 3       %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
:- op(800, fx, if).
:- op(700, xfx, then).
:- op(200, xfy, and).

%Terminals
ziekte(malaria_tropica).
ziekte(malaria_tertiana).
ziekte(malaria_quartana).
ziekte(dysenterie).
ziekte(geelzucht).
ziekte(polio).

ziekteklasse(malaria).
ziekteklasse(darminfectie).
ziekteklasse(goedaardige_malaria).

%%% Ziektes %%%
%% Malaria
if koorts then ziekteklasse(malaria).
if ziekteklasse(malaria) and vraag(aanvallen, regelmatig) then ziekteklasse(goedaardige_malaria).
if ziekteklasse(malaria) and vraag(aanvallen, onregelmatig) then ziekte(malaria_tropica).
if ziekteklasse(goedaardige_malaria) and vraag(aanvallen, 2) then ziekte(malaria_tertiana).
if ziekteklasse(goedaardige_malaria) and vraag(aanvallen, 3) then ziekte(malaria_quartana).

%% Darminfectie
if diarree then ziekteklasse(darminfectie).
if ziekteklasse(darminfectie) and vraag(ontlasting) and vraag(slijm) and vraag(bloed) then ziekte(dysenterie).
if ziekteklasse(darminfectie) and vraag(geling) then ziekte(geelzucht).
if ziekteklasse(darminfectie) and vraag(verlamming) then ziekte(polio).

%%%% Symptomen Abstractie %%%
if (temperatuur, hoog) then koorts.

is_abtract(tempertuur, hoog).
is_abstract(aanvallen, regelmatig).
is_abstract(aanvallen, onregelmatig).

convert_to_value(Waarde, IntWaarde):-
	\+number(Waarde), atom_number(Waarde, IntWaarde).

convert_to_value(Waarde, Waarde):- number(Waarde).

fact_from_abstract(temperatuur, hoog):-
	fact(temperatuur, Waarde),
	convert_to_value(Waarde, IntWaarde),
	IntWaarde >= 38.

fact_from_abstract(aanvallen, regelmatig):-
	fact(aanvallen, Waarde),
	convert_to_value(Waarde, IntWaarde),
	IntWaarde > 1.

fact_from_abstract(aanvallen, onregelmatig):-
	fact(aanvallen, Waarde),
	convert_to_value(Waarde, IntWaarde),
	IntWaarde =< 0.

% If koorts and malaria ask for 'aanvallen :regelmatig of onregelmatig)'
% If regelmatig, ask for periods (i.e. every 2 or 3 days) and assert aanvallen(regelmatig, Period).
% If onregelmatig, assert aanvallen(onregelmatig, -1). ?




