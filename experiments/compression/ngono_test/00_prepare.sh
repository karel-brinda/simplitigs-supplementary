#! /usr/bin/env bash

set -e
set -o pipefail
set -u

cat ../pangenome-ngonorrhoeae.assembly18.fa > ngono.asm18_1cop.fa
(
	cat ../pangenome-ngonorrhoeae.assembly18.fa
	cat ../pangenome-ngonorrhoeae.assembly18.fa
) > ngono.asm18_2cop.fa

