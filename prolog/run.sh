#!/bin/bash

echo "Compiling solver into 'solve' executable..."
swipl -O -g solve --stand_alone=true -o solve -c family-trip.pl

echo "Running solver..."
./solve
