/* --- Defining operators --- */

:- op(800, fx, if).
:- op(700, xfx, then).
:- op(200, xfy, and).

:- dynamic fact/2.
:- consult('db.pl').

go:-
	retractall(fact(_,_)),
	write('Welkom bij het ziekte diagnose systeem\n'),
	ask_for_additional_wrapper,
	is_true(ziekte(X)), write(X).

ask_for_additional_wrapper:- ask_for_additional(start).

ask_for_additional(stop):- !.

ask_for_additional(start):-
	!,
	write('Voer symptoom in, of type stop: '), read(Info),
	process_info(Info),
	ask_for_additional(Info).

ask_for_additional(_):-
	!,
	write('Voer een ander symptoom in, of type stop: '), read(Info),
	process_info(Info),
	ask_for_additional(Info).

process_info(stop):- !.
process_info(Info):-
	atomic_list_concat(L,' ', Info), L = [Attribute,Waarde], !,

	assert(fact(Attribute, Waarde)).

process_info(Info):-
	!,

	assert(fact(Info, true)).


has_non_abstract(Symptom):-
   bagof(_, (fact(Symptom, W), \+is_abstract(Symptom, W)), _).

is_true((X,Y)):-
   fact(X,Y);
   fact_from_abstract(X,Y).

is_true( P ):-
    fact( P, true ).

is_true(vraag(Symptom, Value)):-
    is_abstract(Symptom, Value),
    (fact(Symptom, Value);
    fact_from_abstract(Symptom, Value));
    (\+fact_from_abstract(Symptom, _),
     \+fact(Symptom, _),
     write('heeft u ook last van: '), write(Symptom),
     write('\n'), read(X),
     assert(fact(Symptom, X)),
     (fact(Symptom, Value);
     fact_from_abstract(Symptom, Value))).

is_true(vraag(Symptom, Value)):-
    \+is_abstract(Symptom, Value),
    (fact(Symptom, Value);
    (\+has_non_abstract(Symptom),
    write(Symptom), write(' (specifiek): '),
    write('\n'), read(X),
    assert(fact(Symptom, X)),
    fact(Symptom, Value))).

is_true( P ):-
    if Condition then P,
    is_true( Condition ).

is_true( P1 and P2 ):-
    is_true( P1 ),
    is_true( P2 ).


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


