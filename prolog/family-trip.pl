
cities([paris,bangkok,montevideo,windhoek,male,delhi,reunion,lima,banff]).

interests([paisatges,cultura,etnies,gastronomia,esport,relax]).

attractions( paris,     [cultura,gastronomia]      ).
attractions( bangkok,   [paisatges,relax,esport]   ).
attractions( montevideo,[gastronomia,relax]        ).
attractions( windhoek,  [etnies,paisatges]         ).
attractions( male,      [paisatges,relax,esport]   ).
attractions( delhi,     [cultura,etnies]           ).
attractions( reunion,   [esport,relax,gastronomia] ).
attractions( lima,      [paisatges,esport,cultura] ).
attractions( banff,     [esport,paisatges]         ).

nat(0).
nat(N):-
	nat(X),
	N is X + 1.

msubset([], []).
msubset([E|Tail], [E|NTail]):-
  msubset(Tail, NTail).
msubset([_|Tail], NTail):-
  msubset(Tail, NTail).

unionAttractions([],[]).
unionAttractions([City|Tail],Union):-
	attractions(City,Attractions),
	unionAttractions(Tail,X),
	union(Attractions,X,Union).

solve:-
	cities(Cities),
	interests(Interests),
	nat(N),
	msubset(Cities,Selected),
	length(Selected,N),
	unionAttractions(Selected,Union),
	subset(Interests, Union),
	write(N), write(' cities: '), write(Selected), nl, halt.
