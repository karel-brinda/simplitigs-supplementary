#! /usr/bin/env bash

set -e
set -o pipefail
set -u

for m in bc pa; do
	for k in 19 23 27 31; do
		e="$m$k"
		>&2 echo "Computing statistics for $e"
		./summarize_fais_simple.py -k $k $e.fasta.fai
	done | tee seq_stats.$m.txt
done | awk '!visited[$0]++' > seq_stats.txt

