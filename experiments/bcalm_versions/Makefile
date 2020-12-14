.PHONY: all help clean cleanall cluster error logs single

SHELL=/usr/bin/env bash -eo pipefail

.SECONDARY:

.SUFFIXES:


LOG_OUTPUTS=$(addsuffix .details,$(wildcard *.out) )

all: ## Run everything
	snakemake -j --printshellcmds

single: ## Run everything in a single thread
	snakemake -j1 --printshellcmds

cluster: ## Submit jobs to a cluster
	snakemake --cores 9999 --keep-going --printshellcmds\
		--rerun-incomplete \
		--keep-going \
		--cluster 'sbatch -p {params.queue} -c {threads} -J {rule} -t {params.time} --mem={params.mem_mb}'

help: ## Print help message
	@echo "$$(grep -hE '^\S+:.*##' $(MAKEFILE_LIST) | sed -e 's/:.*##\s*/:/' -e 's/^\(.\+\):\(.*\)/\\x1b[36m\1\\x1b[m:\2/' | column -c2 -t -s : | sort)"

clean: ## Clean
	for x in *.fna; do \
		y=$$(basename "$$x" .fna); \
		echo "Cleaning $$y"; \
		rm -fr "$$y/"; \
	done

cleanall: ## Cleanall
cleanall: clean
	rm -f *.fna slurm-* results_* */*.txt
	rm -f logs/* benchmarks/*

error: ## Show SLURM error messages
	grep -i error *.out || true

logs: ## Update SLURM logs
logs: $(LOG_OUTPUTS)

slurm-%.out.details: slurm-%.out
	seff "$*" > "$@"

