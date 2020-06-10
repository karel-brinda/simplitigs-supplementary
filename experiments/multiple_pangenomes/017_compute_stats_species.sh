#! /usr/bin/env bash

set -e
set -o pipefail
set -u

summarize () {
	x=$1
	b=$(basename $x .fsa.fai)
	k=$(echo $b | perl -pe 's/.*(\d{2})/\1/g')
	./summarize_fais_simple.py -k $k $x
}

export -f summarize

(
	find . -name '*.fsa.fai' \
		| sort \
		| xargs -I {} bash -c 'summarize {}'
) \
	| awk '!visited[$0]++' \
	| tee seq_stats_species.txt

