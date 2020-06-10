#! /usr/bin/env bash

set -e
set -o pipefail
set -u

readonly PROGNAME=$(basename $0)
readonly PROGDIR=$(dirname $0)
readonly -a ARGS=("$@")
readonly NARGS="$#"

if [[ $NARGS -ne 3 ]]; then
	>&2 echo "usage: $PROGNAME in.fa genomes out.fa"
	exit 1
fi

i="$1"
g="$2"
o="$3"

awk 'NR == FNR{a[">"$1];next} $1 in a {print $0}' \
	../multiple_pangenomes/strain_counts.$g.tsv FS="." \
	<(cat "$i" | paste - -) \
	| perl -pe 's/\t/\n/g' \
	> "$o"
