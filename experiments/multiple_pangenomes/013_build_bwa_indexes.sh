#! /usr/bin/env bash

set -e
set -o pipefail
set -u

for x in *.fasta; do
	>&2 echo $x
	bwa index "$x" #&
done
#wait
