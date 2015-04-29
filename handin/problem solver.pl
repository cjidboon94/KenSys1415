%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Koen van der Keijl - 10555900  %%%%
%% Cornelis Boon - 10561145       %%%%
%% Problem Solver voor opdracht 3 %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
:- op(800, fx, if).
:- op(700, xfx, then).
:- op(200, xfy, and).

:- dynamic fact/2.
:- consult('db.pl').


/* Main predicate */
go:-
	retractall(fact(_,_)),
	write('Welkom bij het ziekte diagnose systeem\n'),
	ask_for_additional_wrapper, !,
	((is_true(ziekte(X), Rules), write('U heeft '), write(X),
	 nl,nl, write('Regels en feiten gebruikt voor afleiding:'), nl,
	 pretty_rules_print(Rules, 1), !);
	 write('Geen ziekte gevonden.')).

/* Predicate with instructions for diagnosing malaria */
go1:-
	write('Voer \'temperatuur 45\' in als symptoom, en vervolgens stop.'), nl,
	write('Als gevraagd wordt naar of u last heeft van aanvallen'), nl,
	write('Voer dan 2 of 3 in.'), nl, write('Dan zal malaria_tertiana of malaria_quartana gediagnosticeerd worden.'),
	nl, nl, go.

/* Predicate with instructions for diagnosing dysenteria */
go2:-
	write('Voer \'ontlasting waterig\' in als symptoom, en vervolgens stop.'), nl,
	write('Als gevraagd wordt naar of u last heeft van bloed of slijm,'), nl,
	write('Voer dan true in.'), nl, write('Dan zal dysenterie gediagnosticeerd worden.'),
	nl, nl, go.


/* Formats the rules used to get a diagnosis into neat lines */
pretty_rules_print([], _).

pretty_rules_print([Rule|Rules], X):-
	write('Regel '), write(X), write(': '), pretty_rule_print(Rule), nl,
	Y is X +1,
	pretty_rules_print(Rules, Y).

pretty_rule_print(Condition then P):-
	print_part(Condition), write(' dan '), write(P).


print_part(vraag(X,Y,_) and Z):- write((X,Y)), write(' en '), print_part(Z).
print_part(vraag(X,_) and Z):- write(X), write(' en '), print_part(Z).
print_part(K and Z):- write(K), write(' en '), print_part(Z).
print_part((X,Y) and Z):- write('('), write((X,Y)), write(') en '), print_part(Z).
print_part((X,Y)):- write('('), write((X,Y)), write(')').
print_part(vraag(X,Y,_)):- write('('), write((X,Y)), write(')').
print_part(vraag(X,_)):- write(X).
print_part(X):- write(X).


ask_for_additional_wrapper:- ask_for_additional(start).

/*** Loops and reads symptoms ***/

ask_for_additional(stop):- !.
ask_for_additional(_):-
	!,
	write('Voer een ander symptoom in, of type stop: '), read(Info),
	process_info(Info),
	ask_for_additional(Info).

/* Processes the symptom initially provided */
process_info(stop):- !.
process_info(Info):-
	atomic_list_concat(L,' ', Info), L = [Attribute,Waarde], !,
        ((convert_to_value(Waarde, Intwaarde),
	assert(fact(Attribute, Intwaarde)));
	assert(fact(Attribute, Waarde))).

process_info(Info):-
	!,
	assert(fact(Info, true)).

/* Check whether any of the values for the symtpom are not abstract */
has_non_abstract(Symptom):-
   bagof(_, (fact(Symptom, W), \+is_abstract(Symptom, W)), _).



/***** Backward chaining *****/

/* Check whether something is true based on fact or abstraction */
is_true((X,Y), []):-
   fact(X,Y);
   fact_from_abstract(X,Y).

is_true(P, []):-
    fact( P, true ).


/* Asks a question if data is not present */
is_true(vraag(Symptom, Value, Question), _):-
    is_abstract(Symptom, Value),
    (fact(Symptom, Value);
    fact_from_abstract(Symptom, Value));
    (\+fact_from_abstract(Symptom, _),
     \+fact(Symptom, _),
     write(Question),
     nl, read(X),
     assert(fact(Symptom, X)),
     (fact(Symptom, Value);
     fact_from_abstract(Symptom, Value))).

is_true(vraag(Symptom, Value, Question), _):-
    \+is_abstract(Symptom, Value),
    (fact(Symptom, Value);
    (\+has_non_abstract(Symptom),
    write(Question),
    nl, read(X),
    assert(fact(Symptom, X)),
    fact(Symptom, Value))).

is_true(vraag(Symptom, Q), OldCondition):-
    is_true(vraag(Symptom, true, Q), OldCondition).


/* Check whether something is true based on if then rules */
is_true(P, Conditions):-
    if Condition then P,
    is_true(Condition, OldCondition),
    append(OldCondition, [Condition then P], Conditions).

/* Handles and */
is_true( P1 and P2, OldCondition ):-
    is_true( P1, OldCondition ),
    is_true( P2, OldCondition ).


/***** Forward chaining *****/

/* asserts facts that can be derived from a rule */
forward:-
    new_derived_fact( P ),
    !,
    assert( fact( P, true )),
    forward
    ;
    !.

/* checks given conclusion */
new_derived_fact( Conclusion ):-
    if Condition then Conclusion,
    \+fact( Conclusion, _ ),
    composed_fact( Condition ).

/* check for explicit true/false fact */
composed_fact( Condition ):-
    fact( Condition, true).

/* checks fact based on explicit fact or abstraction */
composed_fact((Condition,Value)):-
    fact( Condition, Value);
    fact_from_abstract( Condition, Value).

/** Handles and **/
composed_fact( Condition1 and Condition2 ):-
    composed_fact( Condition1 ),
    composed_fact( Condition2 ).
