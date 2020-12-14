#! /usr/bin/env bash

set -e
set -o pipefail
set -u

../../../themisto/bin/build_index --mem-megas 10000 --k 18 --input-file ngono.asm18_1cop.fa --n-threads 4 --index-dir index1cop --temp-dir tmp1cop

../../../themisto/bin/build_index --mem-megas 10000 --k 18 --input-file ngono.asm18_2cop.fa --n-threads 4 --index-dir index2cop --temp-dir tmp2cop
