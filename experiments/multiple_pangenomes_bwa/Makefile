.PHONY: all help clean cleanall cluster single logs

SHELL=/usr/bin/env bash -eo pipefail

.SECONDARY:

.SUFFIXES:


LOG_OUTPUTS=$(addsuffix .details,$(wildcard slurm/*.out) )

all: ## Run everything
	snakemake -j --printshellcmds

single: ## Run everything in a single thread
	snakemake -j1 --printshellcmds

cluster: ## Submit jobs to a cluster
	snakemake --cores 9999 --keep-going --printshellcmds\
		--rerun-incomplete \
		--keep-going \
		--cluster-config cluster.json \
		--cluster 'sbatch -p {cluster.queue} -t {cluster.time} --mem={cluster.memory}' \
		-o slurm/slurm-%j.out
		#--cluster 'sbatch -p {params.queue} -c {threads} -J {rule} -t {params.time} --mem={params.mem_mb}'

help: ## Print help message
	@echo "$$(grep -hE '^\S+:.*##' $(MAKEFILE_LIST) | sed -e 's/:.*##\s*/:/' -e 's/^\(.\+\):\(.*\)/\\x1b[36m\1\\x1b[m:\2/' | column -c2 -t -s : | sort)"

clean: ## Clean

cleanall: ## Cleanall
cleanall: clean


logs: ## Update SLURM logs
logs: $(LOG_OUTPUTS)

slurm/slurm-%.out.details: slurm/slurm-%.out
	seff "$*" > "$@"
