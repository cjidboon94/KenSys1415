% Authors:
% Koen van der Keijl (10555900)
% Cornelis Boon
%
% Date: 31-3-2015

% concepts
concept(mammal).
concept(bird).
concept(thing).

% attributes of a mammal
has(mammal, reproduction, birth).
has(mammal, skintype, hair).
has(mammal, limbcount, between(2,4)).
has(mammal, breathing, lungs).

% attributes of a bird
has(bird, breathing , lungs).
has(bird, wings, true).

has(thingy, wings, true).

is_a(thingy, bird).

%%%%%%%%%%%%%%%%%%%
% inheritance rules
%%%%%%%%%%%%%%%%%%%
is_a(blahtje, bird).

is_a_rec(Child,Parent):- concept(Child), concept(Parent), is_a(Child, X), is_a_rec(X, Parent), concept(X).

% wrapper rule, collects all the properties of the parent
is_a(Child, Parent):- concept(Child), concept(Parent), Parent \= Child, bagof([Type,Value], has(Parent, Type, Value), ParentAtributes), is_a2(Child, ParentAtributes).

% base case, all atributes have been checked
is_a2(_, []):- !.

% checks for all the properties in the parent whether the child has the same value for the properties
is_a2(Child, [[Type,Value]|Tail]):- has(Child, Type, Value), !, is_a2(Child, Tail).

% specific rule inheritance rule for ranges
is_a2(Child, [[Type,between(LowerValue, UpperValue)]|Tail]):- has(Child, Type, Value), between(LowerValue, UpperValue, Value), !, is_a2(Child, Tail).

show(X):- bagof([Value, Type], (has(X, Value, Type); is_a(X, Parent), has(Parent, Value, Type)), Content), print(Content).