% Authors:
% Koen van der Keijl (10555900)
% Cornelis Boon
%
% Date: 31-3-2015

% concepts
concept(mammal).
concept(bird).
concept(thing).
concept(blahtje).
concept(something).

% attributes of a mammal
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

is_a(blahtje, something).

has(Child, Value, Type):- concept(Child), is_a_rec(Child, Parent), concept(Parent), has(Parent, Value, Type).


%%%%%%%%%%%%%%%%%%%
% inheritance rules
%%%%%%%%%%%%%%%%%%%
is_a_rec(Child,Parent):- is_a(Child, Parent).
is_a_rec(Child,Parent):- concept(Child), concept(Parent), is_a(Child, Z), is_a_rec(Z, Parent), concept(X).

% wrapper rule for is_a
is_a_wrapper(Child, Parent):- is_a_rec(Child, Parent).
is_a_wrapper(Child, Parent):- concept(Child), concept(Parent), Parent \= Child, \+setof(_, has(Parent, _, _), _).
is_a_wrapper(Child, Parent):- concept(Child), concept(Parent), Parent \= Child, setof([Type,Value], has(Parent, Type, Value), ParentAtributes), is_a2(Child, ParentAtributes).

% base case, all atributes have been checked
is_a2(_, []):- !.

% checks for all the properties in the parent whether the child has the same value for the properties
is_a2(Child, [[Type,Value]|Tail]):- has(Child, Type, Value), !, is_a2(Child, Tail).

% specific rule inheritance rule for ranges
is_a2(Child, [[Type,between(LowerValue, UpperValue)]|Tail]):- has(Child, Type, Value), between(LowerValue, UpperValue, Value), !, is_a2(Child, Tail).

has_all(Child, Content):- bagof([Value,Type], has(Child, Value, Type), Content).

show(X):- has_all(X, Content), print(Content).