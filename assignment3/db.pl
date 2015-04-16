%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Koen van der Keijl - 10555900  %%%%
%% Cornelis Boon - 10561145       %%%%
%% Database voor opdracht 3       %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
:- op(800, fx, if).
:- op(750, xfx, else).
:- op(700, xfx, then).
:- op(300, xfy, or).
:- op(200, xfy, and).

%Equality checker
oorzaak(Oorzaak, Oorzaak).

%Terminals
ziekte(malaria_tropica).
ziekte(malaria_tertiana).
ziekte(malaria_quartana).
ziekte(dysenterie).
ziekte(geelzucht).
ziekte(polio).

%%% Illnesses %%%
%% Malaria 
if oorzaak(Oorzaak ,muggensteek) and koorts then ziekteklasse(malaria).
if malaria and aanvallen(regelmatig, _) then goedaardige_malaria else malaria_tropica.
if goedaardige_malaria and aanvallen(regelmatig, 2) then malaria_tertiana.
if goedaardige_malaria and aanvallen(regelmatig, 3) then malaria_quartana.

%%darminfectie
if diarree then darminfectie.
if darminfectie and has(ontlatsting, bloed, slijm) then dysenterie.
if darminfectie and geling then geelzucht.
if darminfectie and verlamming then polio.

%%%% Symptoms %%%
if hoge(Lichaamstemperatuur) then koorts.
hoge(Lichaamstemperatuur) :-
	Lichaamstemperatuur >= 38.
% If koorts and malaria ask for 'aanvallen :regelmatig of onregelmatig)'
% If regelmatig, ask for periods (i.e. every 2 or 3 days) and assert aanvallen(regelmatig, Period).
% If onregelmatig, assert aanvallen(onregelmatig, -1). ?


