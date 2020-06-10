#! /usr/bin/env bash

set -e
set -o pipefail
set -u

(
printf "Nodes\tVendor ID\tModel name\tCache size\n"
cat hardware.txt \
	| xargs -L 1 echo \
	| grep -v flags \
	| perl -pe 's/(vendor_id : |model name : |cache size : )/\t/g' \
	| perl -pe 's/\n//g' \
	| perl -pe 's/Compute/\nCompute/g' \
	| grep -v ^$
) > hardware_table.tsv
