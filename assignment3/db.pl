%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Koen van der Keijl - 10555900  %%%%
%% Cornelis Boon - 10561145       %%%%
%% Database voor opdracht 3       %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
:- op(800, fx, if).
:- op(700, xfx, then).
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

ziekteklasse(malaria).
ziekteklasse(darminfectie).
ziekteklasse(goedaardige_malaria).

%%% Ziektes %%%
%% Malaria
if koorts then ziekteklasse(malaria).
if ziekteklasse(malaria) and aanvallen(onregelmatig, _) then ziekteklasse(goedaardige_malaria).
if ziekteklasse(malaria) and aanvallen(regelmatig, _) then ziekte(malaria_tropica).
if ziekteklasse(goedaardige_malaria) and aanvallen(regelmatig, 2) then ziekte(ziektemalaria_tertiana).
if ziekteklasse(goedaardige_malaria) and aanvallen(regelmatig, 3) then ziekte(malaria_quartana).

%% Darminfectie
if diarree then ziekteklasse(darminfectie).
if darminfectie and ontlasting and slijm and bloed then dysenterie.
if darminfectie and geling then geelzucht.
if darminfectie and verlamming then polio.

%%%% Symptoms %%%
if temperature_hoog then koorts.

fact(temperature_hoog):-
    fact(temperature(Temperature)), Temperature >= 38.

% If koorts and malaria ask for 'aanvallen :regelmatig of onregelmatig)'
% If regelmatig, ask for periods (i.e. every 2 or 3 days) and assert aanvallen(regelmatig, Period).
% If onregelmatig, assert aanvallen(onregelmatig, -1). ?




