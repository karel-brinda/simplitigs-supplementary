#! /usr/bin/env bash

set -e
set -o pipefail
set -u

for k in 19 23 27 31; do
	for p in bc pa; do
		m="$p$k"
		for x in *."$m.fsa"; do
			>&2 echo "Processing $m $x"
			b=$(basename "$x" ".$m.fsa")
			cat $x \
				| perl -pe "s/>/>$b./g"
		done | seqtk seq -C > "$m.fasta"
	done
done
