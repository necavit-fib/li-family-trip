/*
 * family-trip.pl
 *
 * Solver logic for the Family Trip problem (pure Prolog implementation)
 *
 * david.martinez.rodriguez@est.fib.upc.edu
 *
 * May, 2015
 */

/*
 * nat/1
 * nat(N)
 * Retrieves, under backtracking, the sequence of natural numbers,
 * beginning with 0.
 */
nat(0).
nat(N):-
	nat(X),
	N is X + 1.

/*
 * msubset/2
 * msubset(Set,Subset)
 * Retrieves, under backtracking, all the subsets of the given
 * set, represented as a list.
 */
msubset([], []).
msubset([E|Tail], [E|NTail]):-
  msubset(Tail, NTail).
msubset([_|Tail], NTail):-
  msubset(Tail, NTail).

/*
 * unionAttractions/2
 * unionAttractions(Cities, Attractions)
 * Given a list of cities, retrieves the union of all
 * the attractions that can be fulfilled by visiting these cities.
 */
unionAttractions([],[]).
unionAttractions([City|Tail],Union):-
	attractions(City,Attractions),
	unionAttractions(Tail,X),
	union(Attractions,X,Union).

main:-
	%Given the list of possible cities...
	cities(Cities),

	%and the list of interests of the family trip,
	interests(Interests),

	%select subsets of the possible cities (of increasing size),
	nat(N),
	msubset(Cities,Selected),
	length(Selected,N),

	%gather all the attractions offered by this selected subset of cities...
	unionAttractions(Selected,Union),

	%and check if the interests of the family are satisfied with
	% this selection of cities.
	subset(Interests, Union),

	%If the interests are satisfied, write the solution!
	write('Trip interests can be satisfied!'), nl,
	write('You need to visit '), write(N),
	write(' cities: '), write(Selected), nl,
	halt.
