.PHONY: all help clean cleanall cluster error

SHELL=/usr/bin/env bash -eo pipefail

.SECONDARY:

.SUFFIXES:

all: ## Run everything
	snakemake -j --printshellcmds

cluster: ## Submit jobs to a cluster
	snakemake --cores 9999 --keep-going --printshellcmds\
		--cluster-config cluster.json \
		--cluster 'sbatch -p {cluster.queue} -c {threads} -J {rule} -t {cluster.time} --mem={cluster.memory}'

help: ## Print help message
	@echo "$$(grep -hE '^\S+:.*##' $(MAKEFILE_LIST) | sed -e 's/:.*##\s*/:/' -e 's/^\(.\+\):\(.*\)/\\x1b[36m\1\\x1b[m:\2/' | column -c2 -t -s : | sort)"

clean: ## Clean
	rm -fr *_comp/

cleanall: ## Cleanall
cleanall: clean
	rm -f *.fna

error: ## Show SLURM error messages
	grep -i error *.out || true
