#! /usr/bin/env bash

set -e
set -o pipefail
set -u

find . -name '*.fsa' -print -exec samtools faidx {} \;
