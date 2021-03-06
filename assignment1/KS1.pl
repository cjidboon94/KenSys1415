% Authors:
% Koen van der Keijl (10555900)
% Cornelis Boon (10561145)
%
% Date: 5-4-2015
:- consult('database.pl').

%Finds all attributes.
has_all(Concept, Content):-
	setof([Value,Type], has(Concept, Value, Type), Content), !.

has_all(_, []).

%%%%%%%%%%%%%%%%%%%
% inheritance rules
%%%%%%%%%%%%%%%%%%%
is_a_rec(Child,Parent):-
    concept(Child), concept(Parent),
    is_a(Child, Parent).

is_a_rec(Child,Parent):-
    concept(Parent),
    concept(Child), is_a(Child, Z),
    is_a_rec(Z, Parent), concept(Z).


% wrapper rule for is_a
is_a_wrapper(Child, Parent):-
    concept(Child), concept(Parent),
    \+is_a_rec(Parent, Child),
    is_a_rec(Child, Parent).

is_a_wrapper(Child, Parent):-
    concept(Child), concept(Parent),
    \+is_a_rec(Parent, Child),
    Parent \= Child,
    setof([Type,Value], has(Parent, Type, Value), ParentAtributes),
    is_a2(Child, ParentAtributes).

% base case, all atributes have been checked
is_a2(_, []):- !.

% checks for all the properties in the parent whether the child has the
% same value for the properties
is_a2(Child, [[Type,Value]|Tail]):-
    has(Child, Type, Value), !,
    is_a2(Child, Tail).

% specific rule inheritance rule for ranges
is_a2(Child, [[Type,between(LowerValue, UpperValue)]|Tail]):-
    has(Child, Type, Value),
    between(LowerValue, UpperValue, Value), !,
    is_a2(Child, Tail).

is_all(Concept, Content):-
    setof(Parent, is_a_wrapper(Concept, Parent), Content), !.

is_all(_, []).


is_child(Concept, Parent):-
    concept(Concept), concept(Parent),
    is_all(Concept, Content),
    member(Parent, Content),
    has_most_wrapper(Content, Parent).

has_most_wrapper(Content, Parent):-
   has_most(Content, _, -1, Parent).

has_most([], Result, _, Result):- !.

has_most([Ancestor|OtherContent], _, CurrentLen, Result):-
   has_all(Ancestor, Content2),
   length(Content2, Len),
   CurrentLen < Len, !,
   has_most(OtherContent, Ancestor, Len, Result).

has_most([_|OtherContent], Parent, CurrentLen, Result):-
   !, has_most(OtherContent, Parent, CurrentLen, Result).


%%%%%%%%%%%%%%%%%%%%%
% database operations
%%%%%%%%%%%%%%%%%%%%%

% shows the content of a concept
show(Concept):-
	print('Concept: '), print(Concept), nl,nl,
    has_all(Concept, Content),
    is_all(Concept, Content2),
    print('Attributes: '), nl, show_attributes(Content),nl,
    print('Ancestors: '), nl, show_ancestors(Content2),nl,
    print('Parent: '), (is_child(Concept,Parent), print(Parent), nl, nl); (print('none'), nl), !.

%Shows everything in the database.
show:-
    findall(Concept, concept(Concept), Concepts),
    show(Concepts, _), !.

%Prints everything prolog knows about the concepts in the list.
show([], []).

show([Concept|Concepts], MoreConcepts):-
    print('Concept: '), print(Concept), nl,nl,
    show(Concept),
    print('======================='), nl,
    show(Concepts, MoreConcepts).


show_attributes([]).

show_attributes([[Type, Value]|OtherContent]):-
    print(Type), print(': '), print(Value), print('\n'),
    show_attributes(OtherContent).


show_ancestors([]).

show_ancestors([Ancestor|OtherContent]):-
    print(Ancestor), print('\n'),
    show_ancestors(OtherContent).


% adds a new rule
add_concept(Concept):-
    \+concept(Concept),
    assert(concept(Concept)),
    assert(is_a(Concept, thing)).


add_relation(Child, Parent):-
    \+is_a_rec(Child, Parent),
    \+is_a_rec(Parent, Child),
    facts_match_wrapper(Child, Parent),
    assert(is_a(Child, Parent)).

facts_match_wrapper(Child, Parent):-
    has_all(Child, Content),
    facts_match(Content, Parent).

facts_match([], _).

facts_match([[Type, _]|OtherFacts], Parent):-
    \+has(Parent, Type, _), !,
    facts_match(OtherFacts, Parent).

facts_match([[Type, Value]|OtherFacts], Parent):-
    has(Parent, Type, Value), !,
    facts_match(OtherFacts, Parent).

facts_match([[Type, Value]|OtherFacts], Parent):-
    has(Parent, Type, between(Min, Max)),
    between(Min, Max, Value),
    facts_match(OtherFacts, Parent).

% adds a new attribute
add_attribute(Concept, Type, Value):-
    \+has(Concept, Type, _),
    assert(has(Concept, Type, Value)).

add_attribute(Concept, Type, Value):-
     has(Concept, Type, between(Min, Max)), between(Min, Max, Value),
     (retract(has(Concept, Type, between(Min, Max))); \+retract(has(Concept, Type, between(Min, Max)))),
     assert(has(Concept, Type, Value)).

%%%%%%%%%%%%%%%%%%%%%
% shortcuts
%%%%%%%%%%%%%%%%%%%%%

% Adds a fully new concept
go1:-
    add_concept(plant),
    show(plant), !.

%Adds a fully subsumed concept
go2:-
	add_concept(ape),

	add_relation(ape, mammal),
	add_attribute(ape, limbs, 4),
	show(ape), !.
%Adds another fully subsumed concept.
go3:-
	add_concept(tit),
	add_attribute(tit, wings, true),
	add_attribute(tit, temperature, constant),
	add_attribute(tit, cells, animal_cells),
	add_attribute(tit, biological_processes, true),
	show(tit), !.
%Adds a concept with missing attributes but inherits everything.
go4:- 
	((go1, print('=================='), nl) ; \+ go1),
	add_attribute(plant, cells, plant_cells),
	add_attribute(plant, biological_processes, true),
	add_concept(flower),
	add_relation(flower, plant), 
	show(flower), !.
%Adds a fully new concept.
go5:-
	add_concept(object),
	show(object), !.
