#! /usr/bin/env bash

set -e
set -o pipefail
set -u

sbatch \
	-n 1 \
	-p medium \
	--mem=120G \
	-t 0-23:00:00 \
	--wrap="snakemake --config reduced=True -p -j1"

