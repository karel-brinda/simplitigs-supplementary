#! /usr/bin/env bash

set -e
set -o pipefail
set -u


for ef in $(ls -d *_comp/); do
	# experiment (e.g., ngonorrhoeae)
	e=$(basename $ef _comp)

	# first reference file
	ref1=$(find "$e" -name '*.fna' | head -n1 || true)
	samtools faidx "$ref1"

	# genome length
	g=$(awk '{sum+=$2} END {print sum}' "${ref1}.fai")

	# methods (pa18, pa31, etc.)
	meth=$(
		find ${e}_comp -name '*.fai' -exec basename {} .fa.fai \; \
			| cut -f3 -d. \
			| sort \
			| uniq
					)

	for m in $meth; do
		k=$(echo "$m" | perl -pe 's/.*?(\d+)/\1/g')
		>&2 echo "Experiment: $e "
		>&2 echo "First ref:  $ref1"
		>&2 echo "Genome len: $g"
		>&2 echo "Method:     $m"
		>&2 echo "k:          $k"
		>&2 echo "../summarize_fais.py -k "$k" -g $g ${e}_comp/$e.*.$m.*.fai > ${e}.$m.txt"
		>&2 echo
		../summarize_fais.py -k "$k" -g $g ${e}_comp/$e.*.$m.*.fai > ${e}.$m.txt
	done

done
exit
