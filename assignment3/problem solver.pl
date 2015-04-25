/* --- Defining operators --- */

:- op(800, fx, if).
:- op(700, xfx, then).
:- op(200, xfy, and).

:- dynamic fact/1.
:- dynamic fact/2.
:- consult('db.pl').

ask_for_additional_wrapper:- ask_for_additional(start).

ask_for_additional(stop):- !.

ask_for_additional(start):-
	!,
	write('geef een andere symptoom aan, of zeg, stop: '), read(Info),
	process_info(Info),
	ask_for_additional(Info).

ask_for_additional(_):-
	!,
	write('geef een andere symptoom aan, of zeg, stop: '), read(Info),
	process_info(Info),
	ask_for_additional(Info).

process_info(stop):- !.
process_info(Info):-
	atomic_list_concat(L,' ', Info), L = [temperature,Waarde], !,
	atom_number(Waarde, TempValue), assert(fact(temperature(TempValue))).

process_info(Info):-
	!,
	assert(fact(Info, true)).


fact(nothing).

is_true( P ):-
    \+fact( P, false),
    fact( P, true ).

is_true(vraag(Symptom)):-
    fact(Symptom);
    (\+fact(Symptom),
    write('heeft u ook last van: '), write(Symptom),
    write('\n'), read(X),
    X = yes,
    assert(fact(Symptom))).

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
    fact( Condition ).

composed_fact( Condition1 and Condition2 ):-
    composed_fact( Condition1 ),
    composed_fact( Condition2 ).


