#! /usr/bin/env bash

for x in */; do
	2>&1 echo $x
	find -d $x | xargs rmdir -p $x 2>/dev/null || echo true
done
