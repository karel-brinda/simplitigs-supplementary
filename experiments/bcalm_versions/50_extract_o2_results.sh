#! /usr/bin/env bash

set -e
set -o pipefail
set -u

(
	printf 'experiment\tk\tversion\ttime\n'
	cd benchmarks-o2
	head *.txt \
		| grep -v max \
		| perl -pe 's/ *[=<>]+ *//g' \
		| perl -pe 's/\.txt\n/\t/g' \
		| cut -f1,2 \
		| grep -Ev ^$ \
		| perl -pe 's/-/\t/g' \
		| perl -pe 's/\.1bc/\t/g'
) > o2_results.tsv
