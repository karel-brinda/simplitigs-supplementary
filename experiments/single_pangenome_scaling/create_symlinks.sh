#! /usr/bin/env bash

set -e
set -o pipefail

(
rm -fr spneumoniae
mkdir spneumoniae
cd spneumoniae
for x in ~/github/my/rase-db-spneumoniae-sparc/isolates/*.fa; do
	b=$(basename "$x" .fa)
	ln -s "$x" "$b.fna"
done
)

(
rm -fr ngonorrhoeae
mkdir ngonorrhoeae
cd ngonorrhoeae
for x in ~/github/my/rase-db-ngonorrhoeae-gisp/isolates/contigs/*.fa; do
	b=$(basename "$x" .fa)
	ln -s "$x" "$b.fna"
done
)
