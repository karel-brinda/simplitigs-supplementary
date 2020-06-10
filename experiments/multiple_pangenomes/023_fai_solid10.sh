#! /usr/bin/env bash

set -e
set -o pipefail
set -u

for x in ../multiple_pangenomes_bwa/*solid10.fa; do
	>&2 echo "Processing $x"
	samtools faidx "$x"
done
