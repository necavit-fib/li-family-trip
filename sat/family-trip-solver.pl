/*
 * family-trip-solver.pl
 *
 * Solver logic for the Family Trip problem
 *
 * david.martinez.rodriguez@est.fib.upc.edu
 *
 * May, 2015
 */

/*
 * DYNAMIC VARIABLES
 */

:-dynamic(varNumber/3).
:-dynamic(maxCities/1).

/*
 * INSTANCE
 */

cities([paris,bangkok,montevideo,windhoek,male,delhi,reunion,lima,banff]).

interests([landscapes,culture,ethnics,gastronomy,sport,relax]).

attractions( paris,     [culture,gastronomy]       ).
attractions( bangkok,   [landscapes,relax,sport]   ).
attractions( montevideo,[gastronomy,relax]         ).
attractions( windhoek,  [ethnics,landscapes]       ).
attractions( male,      [landscapes,relax,sport]   ).
attractions( delhi,     [culture,ethnics]          ).
attractions( reunion,   [sport,relax,gastronomy]   ).
attractions( lima,      [landscapes,sport,culture] ).
attractions( banff,     [sport,landscapes]         ).

/*
 * SOLUTION
 */

symbolicOutput(0).
%maxCities(3).

nat(0).
nat(N):-
	nat(X),
	N is X + 1.

writeClauses:-
	constrainNumberOfCities,
	constrainInterests.

constrainNumberOfCities:-
	maxCities(K),
	write(user_error,'  constraining cities to K = '), write(user_error,K), nl(user_error),
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
 * DISPLAY SOLUTION
 */

displaySol([]):- nl.
displaySol([Nv|S]):-
	num2var(Nv,Var),
	varToCity(Var,City),
	write(City), write(', '),
	displaySol(S).

/*
 * MAIN
 */

% ========== No need to change the following: =====================================
main:- % escribir bonito, no ejecutar
	symbolicOutput(1), !,
	writeClauses,
	halt.
main:- % ejecutar
	nat(K),
	K > 0,
	assert(maxCities(K)),
	picosat,
	extractModel(Model),
	validModel(Model).

extractModel(Model):-
	see(model), readModel(Model), seen,
	unix('rm model'),!.

validModel([]):-
	maxCities(K),
	write('model not found for K = '), write(K), nl,
	retract(maxCities(K)),
	fail.
validModel(Model):-
	length(Model,Length),
	Length > 0,
	maxCities(K),
	write('model FOUND for K = '), write(K), nl,
	displaySol(Model),
	halt.

picosat:-
	assert(numClauses(0)), assert(numVars(0)),
	tell(clauses), writeClauses, told,
	tell(header),  writeHeader,  told,
	unix('cat header clauses > infile.cnf'),
	% unix('cat infile.cnf'),
	unix('picosat -v -o model infile.cnf'),
	% unix('cat model'),
	unix('rm header'), unix('rm clauses'), unix('rm infile.cnf'),!.

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
%========================================================================================
