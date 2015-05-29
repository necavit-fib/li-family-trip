#! /bin/bash

echo "Compiling solver into 'solve' executable..."
swipl -O -g main --stand_alone=true -o solve -c family-trip-solver.pl

echo "Running solver..."
./solve
