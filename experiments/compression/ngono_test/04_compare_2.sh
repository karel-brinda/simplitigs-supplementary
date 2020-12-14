#! /usr/bin/env bash

set -e
set -o pipefail
set -u

(
	echo index1cop
	ls -alh index1cop/*
	echo index2cop
	ls -alh index2cop/*
) | tee comparison2.txt


