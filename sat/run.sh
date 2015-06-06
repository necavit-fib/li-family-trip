#!/bin/bash

# Family Trip problem automated solver script
# david.martinez.rodriguez@est.fib.upc.edu
#
# June 2015

# *** environment setting *** #
export PATH=$PATH:.

# *** variables *** #
symbolic=false                       #symbolic output (true|false)
instance="foo"                       #INSTANCE_FILE
output="foo"                         #OUTPUT_FILE
k="3"                                #max number of cities (symbolic output = 1)
solver_file="solver.pl"              #final solver filename
solver_logic="family-trip.pl"        #solver main logic file
solver_display="display-solution.pl" #solver display logic
solver_exe="solve"                   #solver executable filename
solution_file="solution.txt"         #solution filename

# *** function declarations *** #
function usage {
	echo ""
  echo "usage: $0 [-h|--help] [-s K OUTPUT_FILE] INSTANCE_FILE"
	echo "    compiles and runs the solver over the given instance file"
	echo ""
	echo "    -s  turns on symbolic output (CNF form) to OUTPUT_FILE and disables"
	echo "         problem resolution. The K argument is mandatory, and specifies"
	echo "         the maximum number of cities that is used to bound the solution."
  echo ""
	echo "    -h|--help  print this usage help and exit"
	echo ""
  exit
}

# *** main script logic *** #
if [ $# -lt 1 ]; then
  echo "error: no arguments supplied"
  usage
fi

#print help if necessary
if [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
	usage
fi

#command line arguments parsing
if [ "$1" == "-s" ]; then
	#symbolic output set to 1
	symbolic=true
	if [ -n "$2" ]; then
		k="$2"
		if [ -n "$3" ]; then
			output="$3"
			if [ -n "$4" ] && [ -f "$4" ]; then
				instance="$4"
			else
				echo "error: INSTANCE_FILE does not exist or is not specified"
				usage
			fi
		else
			echo "error: OUTPUT_FILE not specified"
			usage
		fi
	else
		echo "error: K is not specified"
		usage
	fi
else
	#symbolic output set to 0
	if [ -n "$1" ] && [ -f "$1" ]; then
		instance="$1"
	else
		echo "error: instance_file does not exist or is not specified"
		usage
	fi
fi

#put the instance of the problem in a new file
echo "including instance $instance in $solver_file..."
cat $instance > $solver_file

#append symbolic output to the solver file
echo "appending symbolic output to $solver_file..."
if $symbolic ; then
	echo "symbolicOutput(1)." >> $solver_file
	echo "maxCities($k)." >> $solver_file
else
	echo "symbolicOutput(0)." >> $solver_file
fi

#append display functions
echo "including display functions ($solver_display) to $solver_file..."
cat $solver_display >> $solver_file

#append user made solver (the solver's logic)
echo "including solver logic ($solver_logic) to $solver_file..."
cat $solver_logic >> $solver_file

#compile and create the executable solver file
echo "compiling the solver to an executable file $solver_exe..."
swipl -O -g main --stand_alone=true -o $solver_exe -c $solver_file

echo "executing the solver..."
#if symbolic output was set, execute and send output to output_file
if $symbolic ; then
	$solver_exe > $output
	echo "DONE executing solver!"
	echo "see $output to check the generated clauses"
else #if symbolic output was not set, display the solution
	rm -f solution.txt
	$solver_exe > $solution_file
	echo "DONE executing solver!"
	echo "solution has been stored in $solution_file"
	echo "solution found by the solver:"
	echo ""
	cat $solution_file
	echo ""
fi
