% Authors:
% Koen van der Keijl (10555900)
% Cornelis Boon (10561145)
%
% Date: 5-4-2015

:- dynamic concept/1.

concept(thing).
concept(living_creature).
concept(animal).

concept(warmblooded).
concept(coldblooded).

concept(mammal).
concept(bird).
concept(fish).
concept(amphibian).
concept(reptile).

concept(human).
concept(cat).
concept(elephant).

concept(eagle).
concept(swallow).

concept(frog).
concept(toad).

concept(crocodile).
concept(turtle).

concept(eel).
concept(seahorse).

concept(john).
concept(mary).

% attributes of a mammal

:- dynamic has/3.
has(Child, Value, Type):-
	concept(Child),
	is_a_rec(Child, Parent),
	concept(Parent),
	has(Parent, Value, Type).

has(living_creature, biological_processes, true).
has(animal, cells, animal_cells).

has(warmblooded, temperature, constant).
has(coldblooded, temperature, variable).

has(mammal,skintype, hair).
has(mammal, limbs, between(2, 4)).
has(mammal, reproduction, birth).
has(mammal, breathing, lungs).

has(bird, wings, true).
has(bird, skintype, feathers).
has(bird, limbs, between(2,4)).
has(bird, breathing, lungs).
has(bird, reproduction, eggs).

has(amphibian, skintype, smooth).
has(amphibian, reproduction, egg).

has(fish, reproduction, eggs).
has(fish, skintype, scales).
has(fish, breathing, gills).

has(reptile, reproduction, eggs).
has(reptile, breathing, lungs).

has(human, diet, omnivore).
has(cat, diet, carnivore).
has(elephant, diet, herbivore).

has(eagle, diet, carnivore).
has(swallow, diet, herbivore).

has(frog, lays_eggs, clusters).
has(toad, lays_eggs, chains).

has(crocodile, diet, carnivore).
has(turtle, diet, herbivore).

has(eel, fins, 1).
has(seahorse, fins, between(2,4)).

has(john, sex, male).
has(mary, sex, female).

%inheritance relations.

:- dynamic is_a/2.
is_a(living_creature, thing).
is_a(animal, thing).
is_a(warmblooded, thing).
is_a(coldblooded, thing).
is_a(mammal, thing).
is_a(bird, thing).
is_a(reptile, thing).
is_a(fish, thing).
is_a(amphibian, thing).
is_a(toad, thing).
is_a(frog, thing).
is_a(human, thing).
is_a(cat, thing).
is_a(elephant, thing).
is_a(eagle, thing).
is_a(swallow, thing).
is_a(eel, thing).
is_a(seahorse, thing).
is_a(crocodile, thing).
is_a(turtle, thing).
is_a(john, thing).
is_a(mary, thing).

is_a(animal, living_creature).
is_a(warmblooded, animal).
is_a(coldblooded, animal).

is_a(mammal, warmblooded).
is_a(bird, warmblooded).

is_a(amphibian, coldblooded).
is_a(reptile, coldblooded).
is_a(fish, coldblooded).

is_a(human, mammal).
is_a(cat, mammal).
is_a(elephant, mammal).

is_a(eagle, bird).
is_a(swallow, bird).

is_a(frog, amphibian).
is_a(toad, amphibian).

is_a(crocodile, reptile).
is_a(turtle, reptile).

is_a(seahorse, fish).
is_a(eel, fish).

is_a(john, human).
is_a(mary, human).