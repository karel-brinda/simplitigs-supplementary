#! /usr/bin/env bash

set -e
set -o pipefail
set -u


function species_file ()
{
	x="$1"
	b=$(basename "$x")

	cat "$b"/*/*.fna \
		| seqtk seq \
		> "$b.fa"
}

export -f species_file

parallel --eta -j 8 --colsep '\t' --halt now,fail=1 --no-notice species_file :::: <(ls -d */)

