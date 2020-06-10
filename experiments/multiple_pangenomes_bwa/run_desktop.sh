#! /usr/bin/env bash

set -e
set -o pipefail
set -u

snakemake -j1 -p -k
