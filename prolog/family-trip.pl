
cities([paris,bangkok,montevideo,windhoek,male,delhi,reunion,lima,banff]).

interests([landscapes,culture,ethnics,gastronomy,sport,relax]).

attractions( paris,     [culture,gastronomy]      ).
attractions( bangkok,   [landscapes,relax,sport]   ).
attractions( montevideo,[gastronomy,relax]        ).
attractions( windhoek,  [ethnics,landscapes]         ).
attractions( male,      [landscapes,relax,sport]   ).
attractions( delhi,     [culture,ethnics]           ).
attractions( reunion,   [sport,relax,gastronomy] ).
attractions( lima,      [landscapes,sport,culture] ).
attractions( banff,     [sport,landscapes]         ).

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
