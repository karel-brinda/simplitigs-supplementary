#! /usr/bin/env bash

set -e
set -o pipefail
set -u

./parse_gnutime_log.py ../../experiments/1_genome_analysis/logs/*.log \
	> 01_gnu_time.tsv

./parse_snakemake_benchmark.py ../../experiments/1_genome_analysis/benchmarks/*.txt \
	> 01_snakemake_benchmark.tsv
