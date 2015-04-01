% Authors:
% Koen van der Keijl (10555900)
% Cornelis Boon
%
% Date: 31-3-2015

% attributes of a mammal
has('mammal', 'reproduction', 'birth').
has('mammal', 'skintype', 'hair').
has('mammal', 'limbcount', between(2,4)).
has('mammal', 'breathing', 'lungs').

% attributes of a thing
has('thing', 'reproduction', 'birth').
has('thing', 'skintype', 'hair').
has('thing', 'breathing', 'lungs').
has('thing', 'limbcount', 2).

% attributes of a bird
has('bird', 'breathing' , 'lungs').
has('bird', 'wings', _).
has('bird', 'skintype').



%%%%%%%%%%%%%%%%%%%
% inheritance rules
%%%%%%%%%%%%%%%%%%%

% wrapper rule, collects all the properties of the parent
isInherited(Child, Parent):- bagof([Type,Value], has(Parent, Type, Value), ParentAtributes), isSubType(Child, ParentAtributes).

% base case, all atributes have been checked
isSubType(_, []):- !.

% checks for all the properties in the parent whether the child has the same value for the properties
isSubType(Child, [[Type,Value]|Tail]):- has(Child, Type, Value), !, isSubType(Child, Tail).

% specific rule inheritance rule for ranges
isSubType(Child, [[Type,between(LowerValue, UpperValue)]|Tail]):- has(Child, Type, Value), between(LowerValue, UpperValue, Value), !, isSubType(Child, Tail).