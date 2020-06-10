#! /usr/bin/env bash

set -e
set -o pipefail
set -u

for x in $(head -n 100 shuffled_genomes.txt); do
	>&2 echo $x;
	seqtk seq $x;
done > subsampled_genomes.fma

