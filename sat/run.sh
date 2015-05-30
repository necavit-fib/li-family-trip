#! /bin/bash

echo "Compiling solver into 'solve' executable..."
swipl -O -g main --stand_alone=true -o solve -c $1

echo "Running solver..."
./solve
