.PHONY: all help clean cleanall cluster

SHELL=/usr/bin/env bash -eo pipefail

.SECONDARY:

.SUFFIXES:


all: ## Run everything
	snakemake -j --printshellcmds


cluster: ## Submit jobs to a cluster
	snakemake --cores 9999 --keep-going --printshellcmds \
		--cluster 'sbatch -p short -c {threads} -J {rule} -t {params.cpu_time} --mem={params.mem_mb}' \
		--rerun-incomplete \
		--keep-going
