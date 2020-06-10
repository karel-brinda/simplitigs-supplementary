#! /usr/bin/env bash

set -e
set -o pipefail
set -u

conda create -n prophasm prophasm bcalm snakemake samtools
