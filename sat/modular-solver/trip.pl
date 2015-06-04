/*
 * trip.pl
 *
 * Instance file for the Family Trip problem
 *
 * david.martinez.rodriguez@est.fib.upc.edu
 *
 * June, 2015
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
