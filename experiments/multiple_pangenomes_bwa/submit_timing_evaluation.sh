#! /usr/bin/env bash

set -e
set -o pipefail
set -u

sbatch \
	-n 4 \
	-p medium \
	--mem=160G \
	-t 1-0:00:00 \
	--wrap="snakemake -k -p -j1" \
	-o slurm/slurm-%j.out
