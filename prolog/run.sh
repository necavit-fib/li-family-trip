#!/bin/bash

echo "Compiling solver (make) into 'solve' executable..."
make

echo "Running solver..."
./solve
