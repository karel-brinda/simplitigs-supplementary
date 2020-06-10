#! /usr/bin/env bash

set -e
set -o pipefail
set -u

for m in bc pa; do
        for k in 19 23 27 31; do
                e="$m$k"
                >&2 echo "Computing statistics for $e"
                ./summarize_fais_simple.py -k $k ../multiple_pangenomes_bwa/${m}${k}_solid10.fa.fai
        done
done | awk '!visited[$0]++' > seq_stats_solid10.txt
