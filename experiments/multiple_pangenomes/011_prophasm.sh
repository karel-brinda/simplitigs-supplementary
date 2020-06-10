#! /usr/bin/env bash

set -e
set -o pipefail
set -u


function run_prophasm ()
{
	x="$1"
	b=$(basename $x .fa)
	echo $b

	for k in 19 23 27 31; do
		../../prophasm/prophasm -k $k -i $x -o $b/$b.pa$k.fsa
	done
}

export -f run_prophasm

parallel --eta -j 8 --colsep '\t' --halt now,fail=1 --no-notice run_prophasm :::: <(ls *.fa)

