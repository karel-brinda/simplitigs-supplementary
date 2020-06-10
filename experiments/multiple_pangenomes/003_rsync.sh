#! /usr/bin/env bash

set -e
set -o pipefail
set -u

parallel --eta -j8 --verbose --colsep '\t' \
	rsync --include='*v?_genomic.fna.gz' --include='*/' --exclude='*' --copy-links --recursive --times --verbose {1} {2} \
	:::: assembly_summary.4_final.tsv

