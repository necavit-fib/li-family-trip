#!/bin/bash

# Family Trip automated solver script
# david.martinez.rodriguez@est.fib.upc.edu
#
# June 2015

# *** environment setting *** #
export PATH=$PATH:.

# *** variables *** #
instance="foo" #instance_file

# *** function declarations *** #
function usage {
  echo ""
  echo "usage: $0 INSTANCE_FILE"
  echo "    compiles and runs the solver over the given instance file"
  echo ""
  exit
}

# *** main script logic *** #
if [ $# -lt 1 ]; then
  echo "error: no arguments supplied"
  usage
fi

#command line arguments parsing
if [ -n "$1" ] && [ -f "$1" ]; then
  instance="$1"
else
  echo "error: INSTANCE_FILE does not exist or is not specified"
  usage
fi

#final solver filename:
solver_file=solver.pl

#put the instance of the problem in a new file
echo "including instance $instance in $solver_file..."
cat $instance > $solver_file

#append user made solver (the solver's logic)
solver_logic=family-trip.pl
echo "including solver logic (file: $solver_logic) to $solver_file..."
cat $solver_logic >> $solver_file

#compile and create the executable solver file
solver_executable_file=solve
echo "compiling the solver to an executable file $solver_executable_file..."
swipl -O -g main --stand_alone=true -o $solver_executable_file -c $solver_file

#execute solver
echo "executing solver..."
$solver_executable_file 2> /dev/null
echo "DONE executing solver!"
