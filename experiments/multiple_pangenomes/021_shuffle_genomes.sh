#! /usr/bin/env bash

set -e
set -o pipefail
set -u

find . -name '*gz*' \
	| sort -R \
	> shuffled_genomes.txt
