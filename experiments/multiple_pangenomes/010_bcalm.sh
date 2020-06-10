#! /usr/bin/env bash

set -e
set -o pipefail
set -u


function run_bcalm ()
{
	x="$1"
	b=$(basename "$x" .fa)
	p=$(pwd)
	echo "$b"

	for k in 19 23 27 31; do
		d=$(mktemp -d)
		echo "b=$b, d=$d, k=$k"
		(
			cd "$d"
			bcalm -abundance-min 1 -kmer-size "$k" -nb-cores 1 -in "$p/$x"
			mv "$b.unitigs.fa" "$p/$b/$b.bc$k.fsa"
		)
		rm -fr "$d"
	done
}

export -f run_bcalm

parallel --eta -j 8 --colsep '\t' --halt now,fail=1 --no-notice run_bcalm :::: <(ls *.fa)


