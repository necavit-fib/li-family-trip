/*
 * family-trip.pl
 *
 * Solver logic for the Family Trip problem (SAT solver based implementation)
 *
 * david.martinez.rodriguez@est.fib.upc.edu
 *
 * June, 2015
 */

/*
 * DYNAMIC VARIABLES
 */

:-dynamic(varNumber/3).
:-dynamic(maxCities/1).

/*
 * SOLVER LOGIC
 */

nat(0).
nat(N):-
	nat(X),
	N is X + 1.

writeClauses:-
	constrainNumberOfCities,
	constrainInterests.

constrainNumberOfCities:-
	maxCities(K),
	cities(Cities),
	numericCities(Cities,NumericCities),
	atMostKList(NumericCities,K).

constrainInterests:-
	interests(Interests),
	constrainInterestsList(Interests).

constrainInterestsList([]).
constrainInterestsList([Interest|Rest]):-
	constrainInterestsList(Rest),
	cities(Cities),
	citiesWithAttraction(Interest,Cities,CitiesWithInterest),
	numericCities(CitiesWithInterest,NumericCities),
	writeClause(NumericCities). %ALO

citiesWithAttraction(_,[],[]).
citiesWithAttraction(Interest,[City|Tail],CitiesWithAttraction):-
	citiesWithAttraction(Interest,Tail,Current),
	attractions(City,Attractions),
	member(Interest,Attractions),!,
	append(Current,[City],CitiesWithAttraction).
citiesWithAttraction(Interest,[_|Tail],CitiesWithAttraction):-
	citiesWithAttraction(Interest,Tail,CitiesWithAttraction).

numericCities([],[]).
numericCities([City|Tail],Numeric):-
	numericCities(Tail,Aux),
	cityToVar(City,Var),
	append([Var],Aux,Numeric).

cityToVar(City,c-Index):-
	cities(Cities),
	member(City,Cities),
	nth1(Index,Cities,City),!.

varToCity(c-Index,City):-
	cities(Cities),
	nth1(Index,Cities,City).

%generic at most K over a list of variables
atMostKList(L,K) :-
	K1 is K + 1,
	msubset(L,S),
	length(S,K1), %take all subsets of length K+1
	negateList(S,C), %make all literals of S negative and store in C
	writeClause(C),fail.
atMostKList(_,_).

%msubset(L,S) stores all subsets of L in S
msubset([],[]).
msubset([X|S],[X|Ss]) :- msubset(S,Ss).
msubset([_|S],Ss) :- msubset(S,Ss).

%negateList(L,N) stores in N all the negated terms of L
negateList([],[]).
negateList([Elem|Tail],NVars):-
	negateList(Tail,Negated),
	append([\+Elem],Negated,NVars).
negateList([\+Elem|Tail],NVars):-
	negateList(Tail,Negated),
	append([Elem],Negated,NVars).

/*
 * MAIN PROCEDURE
 */
main:- % escribir bonito, no ejecutar
	symbolicOutput(1), !,
	writeClauses,
	halt.
main:- % ejecutar
  %Initialize dynamic predicates.
	assert(numVars(0)),	assert(numClauses(0)),

  %For increasing number of cities...
	nat(K),
	K > 0,

  %assert the number of maximum cities to be visited...
	assert(maxCities(K)),

  %encode the problem, execute the SAT solver...
	picosat(Model),

  %and validate the model.
	validModel(Model).

validModel([]):-
  %if no model was found, retract the number of cities and fail (force backtrack)
	maxCities(K),
	retractall(maxCities(K)),
	fail.
validModel(Model):-
  %if a model is found, display the solution and halt the execution
	length(Model,Length),
	Length > 0,
  displaySolution(Model),
	halt.

picosat(Model):-
	retractall(numClauses(_)),
	assert(numClauses(0)),
	tell(clauses), writeClauses, told,
	tell(header),  writeHeader,  told,
	unix('cat header clauses > infile.cnf'),
	unix('picosat -v -o model infile.cnf'),
	unix('rm header'), unix('rm clauses'), unix('rm infile.cnf'),
  see(model), readModel(Model), seen,
	unix('rm model'),!. %the cut operator is needed here in order to stop Prolog
                      % from trying to execute the previous commands again under
                      % bactracking (this is, when no solution was found)

var2num(T,N):- hash_term(T,Key), varNumber(Key,T,N),!.
var2num(T,N):- retract(numVars(N0)), N is N0+1, assert(numVars(N)), hash_term(T,Key),
	assert(varNumber(Key,T,N)), assert( num2var(N,T) ), !.

writeHeader:- numVars(N),numClauses(C),write('p cnf '),write(N), write(' '),write(C),nl.

countClause:-  retract(numClauses(N)), N1 is N+1, assert(numClauses(N1)),!.

writeClause([]):- symbolicOutput(1),!, nl.
writeClause([]):- countClause, write(0), nl.
writeClause([Lit|C]):- w(Lit), writeClause(C),!.

w( Lit ):- symbolicOutput(1), write(Lit), write(' '),!.
w(\+Var):- var2num(Var,N), write(-), write(N), write(' '),!.
w(  Var):- var2num(Var,N),           write(N), write(' '),!.

unix(Comando):-shell(Comando),!.
unix(_).

readModel(L):- get_code(Char), readWord(Char,W), readModel(L1), addIfPositiveInt(W,L1,L),!.
readModel([]).

addIfPositiveInt(W,L,[N|L]):- W = [C|_], between(48,57,C), number_codes(N,W), N>0, !.
addIfPositiveInt(_,L,L).

readWord(99,W):- repeat, get_code(Ch), member(Ch,[-1,10]), !, get_code(Ch1), readWord(Ch1,W),!.
readWord(-1,_):-!, fail. %end of file
readWord(C,[]):- member(C,[10,32]), !. % newline or white space marks end of word
readWord(Char,[Char|W]):- get_code(Char1), readWord(Char1,W), !.

/*
 * End of family-trip.pl
 */
