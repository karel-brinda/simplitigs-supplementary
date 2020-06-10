#! /usr/bin/env bash

set -e
set -o pipefail
set -u

(
for x in ngono.{bc,pa,me}??.fna; do
	>&2 echo $x
	samtools faidx $x
	./_summarize_fais_simple.py $x.fai
done
) \
	| awk '!x[$0]++' \
	| tee seq_stats.txt
