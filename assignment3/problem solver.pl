/* --- Defining operators --- */

:- op(800, fx, if).
:- op(700, xfx, then).
:- op(200, xfy, and).

:- dynamic fact/2.
:- consult('db.pl').

go:-
	retractall(fact(_,_)),
	write('Welkom bij het ziekte diagnose systeem\n'),
	ask_for_additional_wrapper, !,
	((is_true(ziekte(X), Rules), write('U heeft '), write(X),
	 nl,nl, write('Regels en feiten gebruikt voor afleiding:'), nl,
	 pretty_rules_print(Rules, 1), !);
	 write('Geen ziekte gevonden.')).

go1:-
	write('Voer koorts in als symptoom, en vervolgens stop'), nl,
	write('Als gevraagd wordt naar of u last heeft van aanvallen'), nl,
	write('Voer dan 2 of 3 in'), nl, write('dan zal malaria_tertiana of malaria_quartana gediagnosticeerd worden'),
	nl, go.

go2:-
	write('Voer diarree in als symptoom, en vervolgens stop'), nl,
	write('Als gevraagd wordt naar of u last heeft van bloed of slijm'), nl,
	write('Voer dan true'), nl, write('dan zal dysenterie gediagnosticeerd worden'),
	nl, go.

pretty_rules_print([], _)

pretty_rules_print([Rule|Rules], X):-
	write('Regel '), write(X), write(': '), pretty_rule_print(Rule), nl,
	Y is X +1,
	pretty_rules_print(Rules, Y).

pretty_rule_print(Condition then P):-
	print_part(Condition), write(' dan '), write(P).

print_part(vraag(X,Y) and Z):- write((X,Y)), write(' en '), print_part(Z).
print_part(K and Z):- write(K), write(' en '), print_part(Z).
print_part((X,Y) and Z):- write('('), write((X,Y)), write(') en '), print_part(Z).
print_part((X,Y)):- write('('), write((X,Y)), write(')').
print_part(vraag(X,Y)):- write('('), write((X,Y)), write(')').
print_part(X):- write(X).


ask_for_additional_wrapper:- ask_for_additional(start).

ask_for_additional(stop):- !.

ask_for_additional(_):-
	!,
	write('Voer een ander symptoom in, of type stop: '), read(Info),
	process_info(Info),
	ask_for_additional(Info).

process_info(stop):- !.
process_info(Info):-
	atomic_list_concat(L,' ', Info), L = [Attribute,Waarde], !,
        ((convert_to_value(Waarde, Intwaarde),
	assert(fact(Attribute, Intwaarde)));
	assert(fact(Attribute, Waarde))).

process_info(Info):-
	!,
	assert(fact(Info, true)).


has_non_abstract(Symptom):-
   bagof(_, (fact(Symptom, W), \+is_abstract(Symptom, W)), _).

is_true((X,Y), []):-
   fact(X,Y);
   fact_from_abstract(X,Y).

is_true(P, []):-
    fact( P, true ).

is_true(vraag(Symptom, Value), _):-
    is_abstract(Symptom, Value),
    (fact(Symptom, Value);
    fact_from_abstract(Symptom, Value));
    (\+fact_from_abstract(Symptom, _),
     \+fact(Symptom, _),
     write('heeft u ook last van: '), write(Symptom),
     nl, read(X),
     assert(fact(Symptom, X)),
     (fact(Symptom, Value);
     fact_from_abstract(Symptom, Value))).

is_true(vraag(Symptom, Value), _):-
    \+is_abstract(Symptom, Value),
    (fact(Symptom, Value);
    (\+has_non_abstract(Symptom),
    write(Symptom), write(' (specifiek): '),
    nl, read(X),
    assert(fact(Symptom, X)),
    fact(Symptom, Value))).

is_true(vraag(Symptom), OldCondition):-
    is_true(vraag(Symptom, true), OldCondition).

is_true(P, Conditions):-
    if Condition then P,
    is_true(Condition, OldCondition),
    append(OldCondition, [Condition then P], Conditions).

is_true( P1 and P2, OldCondition ):-
    is_true( P1, OldCondition ),
    is_true( P2, OldCondition ).


/* --- A simple forward chaining rule interpreter --- */

forward:-
    new_derived_fact( P ),
    !,
    write( 'Derived:' ), write_ln( P ),
    assert( fact( P )),
    forward
    ;
    write_ln( 'No more facts' ).

new_derived_fact( Conclusion ):-
    if Condition then Conclusion,
    not( fact( Conclusion ) ),
    composed_fact( Condition ).

composed_fact( Condition ):-
    fact( Condition).

composed_fact( Condition1 and Condition2 ):-
    composed_fact( Condition1 ),
    composed_fact( Condition2 ).