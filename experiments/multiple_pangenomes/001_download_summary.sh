#! /usr/bin/env bash

set -e
set -o pipefail
set -u

curl -L ftp://ftp.ncbi.nlm.nih.gov/genomes/genbank/bacteria/assembly_summary.txt \
	> assembly_summary.1_original.tsv
