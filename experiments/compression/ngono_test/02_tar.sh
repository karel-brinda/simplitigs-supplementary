#! /usr/bin/env bash

set -e
set -o pipefail
set -u

tar cvf - index1cop > index1cop.tar
tar cvf - index2cop > index2cop.tar
