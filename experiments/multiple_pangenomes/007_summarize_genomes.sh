#! /usr/bin/env bash

(
	printf "species\tgenomes\n"
	for x in */; do
		printf "%s\t%s\n" $(basename $x) $(find $x -name '*.fna' | wc -l);
	done
) | tee strain_counts.tsv

#exit 0

(
	printf "accession\tversion\tspecies\tfna\tseqs\tsize\n"
	find . -name '*.fna' \
		| sort \
		| while IFS= read -r x; do
			b=$(basename $(dirname $x))
			acc=$(echo "$b" | perl -pe 's/(.*)v\d+$/\1/g')
			v=$(echo "$b" | perl -pe 's/.*(v\d+)$/\1/g')
			sp=$(dirname $(dirname $x))
			seqs=$(wc -l < $x.fai)
			size=$(cut -f2 $x.fai | paste -sd+ - | bc)
			printf "$acc\t$v\t$sp\t$x\t$seqs\t$size\n"
		done
)\
	| perl -pe 's@\./@@g' \
	| tee genomes_list.tsv
