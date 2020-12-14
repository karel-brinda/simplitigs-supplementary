#! /usr/bin/env bash

set -e
set -o pipefail
set -u

wc -c $(find . -maxdepth 1 -name '*fa*' -or -name '*tar*' -type f | sort | xargs -L1 basename) \
	| xargs -L1 echo \
	| awk '{printf("%s\t%s\n", $2, $1)}' \
	| grep -v total \
	> results.tsv
