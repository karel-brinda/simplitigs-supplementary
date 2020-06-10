#! /usr/bin/env bash

set -e
set -o pipefail
set -u

for x in *.fasta; do
	>&2 echo "Processing $x"
	samtools faidx "$x"
done
