file = family-trip

solve: $(file).pl
	swipl -O -g solve --stand_alone=true -o solve -c $(file).pl
