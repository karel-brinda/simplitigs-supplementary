#! /usr/bin/env bash

set -u

for x in results_*.txt; do
	b=$(basename "$x" .txt)
	bb=$(echo $b | perl -pe 's/results_//g')
	for m in 1bc pa; do
		mm=$(echo $m | perl -pe 's/[0-9]//g')
		(
		head -n1 "$x"
		cat "$x" \
			| grep "$m" \
			| perl -pe "s/\\.$m//g" \
			| perl -pe "s/\\.fa//g" \
			| perl -pe "s/$bb//g" \
			| sort -n \
		) \
			> "$b.$mm.tsv"

	done
done
