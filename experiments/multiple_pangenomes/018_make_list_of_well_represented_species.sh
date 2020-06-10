#! /usr/bin/env bash

set -e
set -o pipefail
set -u

for i in $(seq 2 20); do
	awk "\$2>$i{print \$0;}" strain_counts.tsv > strain_counts.$i.tsv
done
