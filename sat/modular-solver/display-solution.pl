%
displaySol([]).
displaySol([Nv|S]):- num2var(Nv,x-I-J), write(I), write(': color '), write(J), nl, displaySol(S).
