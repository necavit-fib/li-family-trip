/*
 * display-solution.pl
 *
 * Display logic for the Family Trip problem (SAT solver based implementation)
 *
 * david.martinez.rodriguez@est.fib.upc.edu
 *
 * June, 2015
 */

displaySolution(List):-
  write('Trip interests can be satisfied!'), nl,
  write('You need to visit '), write(N),
  write(' cities: '), writeCities(List).

writeCities([]):- nl.
writeCities([Nv|S]):-
 	num2var(Nv,Var),
 	varToCity(Var,City),
 	write(City), write(', '),
 	displaySol(S).

/*
 * End of display-solution.pl
 */
