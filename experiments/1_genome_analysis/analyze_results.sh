#! /usr/bin/env bash

set -e

readonly PROGNAME=$(basename $0)
readonly PROGDIR=$(dirname $0)
readonly -a ARGS=("$@")
readonly NARGS="$#"

if [[ $NARGS -ne 0 ]]; then
	>&2 echo "usage: $PROGNAME"
	exit 1
fi

#for e in *.fna; do
#	./_analyze_results_fna.sh "$e"
#done

for e in *.fna; do

	sbatch \
		-n 1 \
		-p medium \
		--mem=60G \
		-t 0-23:00:00 \
		--wrap="./_analyze_results_fna.sh $e";

done
