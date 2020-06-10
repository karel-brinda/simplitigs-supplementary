#! /usr/bin/env bash

set -e
set -o pipefail
set -u

for x in *.txt; do
	b=$(basename "$x" .txt)
	cat "$x" \
		| perl -pe 's/.*\.(\d+)genomes\...\d+\.fa/\1/g' \
		| sort -n \
		> "$b.tsv"
done
