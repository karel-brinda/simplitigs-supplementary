#! /usr/bin/env bash

set -e

readonly PROGNAME=$(basename $0)
readonly PROGDIR=$(dirname $0)
readonly -a ARGS=("$@")
readonly NARGS="$#"

if [[ $NARGS -ne 1 ]]; then
	>&2 echo "usage: $PROGNAME species.fna"
	exit 1
fi

e="$1"

b=$(basename "$e" .fna)
samtools faidx "$e"
g=$(awk '{sum+=$2} END {print sum}' "$e.fai")
>&2 echo "Processing $e (name $b, length $g)"
for y in $b/*.fa; do
	samtools faidx $y
	x="$y.fai"
	k=$(echo "$x" | perl -pe 's/.*?(\d+)\.fa\.fai/\1/g')
	>&2 echo " ... file $x (k=$k)"
	../summarize_fais.py -k $k -g $g "$x"
done | awk '!x[$0]++' > "results_$b.txt"
