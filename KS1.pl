% Authors:
% Koen van der Keijl (10555900)
% Cornelis Boon
%
% Date: 31-3-2015

% concepts
:- dynamic concept/1.

concept(mammal).
concept(bird).
concept(thing).
concept(blahtje).
concept(something).

% attributes of a mammal
:- dynamic has/3.

has(mammal, reproduction, birth).
has(mammal, skintype, hair).
has(mammal, limbcount, between(2,4)).
has(mammal, breathing, lungs).

has(something, reproduction, birth).
has(something, skintype, hair).
has(something, limbcount, between(2,4)).
has(something, breathing, lungs).

% attributes of a bird
has(bird, breathing , lungs).
has(bird, wings, true).

has(thingy, wings, true).

has(Child, Value, Type):- concept(Child), is_a_rec(Child, Parent), concept(Parent), has(Parent, Value, Type).

has_all(Concept, Content):- setof([Value,Type], has(Concept, Value, Type), Content), !.
has_all(_, []).

is_a(blahtje, mammal).


%%%%%%%%%%%%%%%%%%%
% inheritance rules
%%%%%%%%%%%%%%%%%%%
is_a_rec(Child,Parent):- is_a(Child, Parent).
is_a_rec(Child,Parent):-
    concept(Parent),
    concept(Child), is_a(Child, Z),
    is_a_rec(Z, Parent), concept(Z).

% wrapper rule for is_a
is_a_wrapper(Child, Parent):-
    \+is_a_rec(Parent, Child),
    is_a_rec(Child, Parent).

is_a_wrapper(Child, Parent):-
    \+is_a_rec(Parent, Child),
    concept(Child), concept(Parent),
    Parent \= Child,
    \+setof(_, has(Parent, _, _), _).

is_a_wrapper(Child, Parent):-
    \+is_a_rec(Parent, Child),
    concept(Child), concept(Parent),
    Parent \= Child,
    setof([Type,Value], has(Parent, Type, Value), ParentAtributes),
    is_a2(Child, ParentAtributes).

% base case, all atributes have been checked
is_a2(_, []):- !.

% checks for all the properties in the parent whether the child has the same value for the properties
is_a2(Child, [[Type,Value]|Tail]):-
    has(Child, Type, Value), !,
    is_a2(Child, Tail).

% specific rule inheritance rule for ranges
is_a2(Child, [[Type,between(LowerValue, UpperValue)]|Tail]):-
    has(Child, Type, Value),
    between(LowerValue, UpperValue, Value), !,
    is_a2(Child, Tail).

is_all(Concept, Content):- setof(Parent, is_a_wrapper(Concept, Parent), Content), !.
is_all(_, []).

is_child(Concept, Parent):- concept(Concept), is_all(Concept, Content), member(Parent, Content), print(Content), !, has_most_wrapper(Content, Parent), !, concept(Parent), print(Parent).

has_most_wrapper(Content, Parent):-
   has_most(Content, _, 0, Parent).

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
show(Concept):- has_all(Concept, Content), is_all(Concept, Content2), print('Attributes: \n'), show_attributes(Content), print('\nAncestors: \n'), show_ancestors(Content2).

show_attributes([]).
show_attributes([[Type, Value]|OtherContent]):- print(Type), print(': '), print(Value), print('\n'), show_attributes(OtherContent).

show_ancestors([]).
show_ancestors([Ancestor|OtherContent]):- print(Ancestor), print('\n'), show_ancestors(OtherContent).

% adds a new rule
add_concept(Concept):- \+concept(Concept), assert(concept(Concept)).

% adds a new attribute
add_attribute(Concept, Type, Value):- \+has(Concept, Type, _), assert(has(Concept, Type, Value)).
add_attribute(Concept, Type, Value):- has(Concept, Type, between(Min, Max)), between(Min, Max, Value), (retract(has(Concept, Type, between(Min, Max))); \+retract(has(Concept, Type, between(Min, Max)))), assert(has(Concept, Type, Value)).
