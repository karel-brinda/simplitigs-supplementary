#! /usr/bin/env bash

set -e
set -o pipefail
set -u

#find . -name '*.fna.gz' -mindepth 3 -print -exec gzip -d -f -k {} \;
find . -name '*.fna' -print -exec samtools faidx {} \;
