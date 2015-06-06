/*
 * display-solution.pl
 *
 * Display logic for the Family Trip problem (SAT solver based implementation)
 *
 * david.martinez.rodriguez@est.fib.upc.edu
 *
 * June, 2015
 */

writeCitiesTail([]):- nl.
writeCitiesTail([NumericVar|Tail]):-
  num2var(NumericVar,Var),
  varToCity(Var,City),
  write(', '), write(City),
  writeCitiesTail(Tail).

writeCities([]):- nl.
writeCities([NumericVar|Tail]):-
  num2var(NumericVar,Var),
  varToCity(Var,City),
  write(City),
  writeCitiesTail(Tail).

displaySolution(List):-
  length(List,N),
  write('Trip interests can be satisfied!'), nl,
  write('You need to visit '), write(N), write(' cities: '),
  writeCities(List).

/*
 * End of display-solution.pl
 */
