#! /usr/bin/env bash

set -e
set -o pipefail
set -u

ls -alh index1cop.tar index2cop.tar | tee comparison.txt
