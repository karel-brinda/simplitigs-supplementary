#!/usr/bin/env Rscript

library(tidyverse)
library(easySupplementary)


fn <- "Additional_File_5.xlsx"

# Data processing -------------------------------------------------------

wb <- es_create()

firstup <- function(x) {
  substr(x, 1, 1) <- toupper(substr(x, 1, 1))
  x
}

format_species <- function(x) {
  str_replace(firstup(x), "_", " ")
}

# 1) Genomes -------------------------------------------------------

df.genomes <- read_tsv("genomes_list.tsv") %>%
  mutate(species = format_species(species))

es_add_sheet(
  wb,
  df.genomes,
  "a) Genomes",
  "Genomes",
  "List of individual genomes with their accession codes and basic characteristics."
)


# 2) Species -------------------------------------------------------

df.counts <- read_tsv("strain_counts.tsv") %>%
  mutate(species = format_species(species))

es_add_sheet(
  wb,
  df.counts,
  "b) Pan-genomes overview",
  "Pan-genomes overview",
  "Genome counts per individual species pan-genomes"
)

# 3) Simplitigs/unitigs per species

df0.spec <- read_tsv("seq_stats_species.txt")

df.spec <- df0.spec %>%
  drop_na() %>%
  rename(NS = simplitigs, CL = `cum len`) %>%
  select(-kmers) %>%
  mutate(NS = NS / 1e3, CL = CL / 1e6) %>%
  mutate(name = str_replace_all(name, ".fsa", "")) %>%
  separate(name, into = c("species", "method0"), sep = "\\.") %>%
  separate(method0, into = c("method", "k"), sep = 2)

df2.spec <- df.spec %>%
  pivot_wider(names_from = c(method),
              values_from = c(NS, CL)) %>%
  mutate(species = format_species(species)) %>%
  select(species, k, NS_bc, CL_bc, everything()) %>%
  rename(`Simplitig NS\n[k]` = NS_pa) %>%
  rename(`Unitig NS\n[k]` = NS_bc) %>%
  rename(`Simplitig CL\n[Mbp]` = CL_pa) %>%
  rename(`Unitig CL\n[Mbp]` = CL_bc)

es_add_sheet(
  wb,
  df2.spec,
  "c) Pan-genomes simplitigs",
  "Pan-genomes simplitigs",
  "Characteristics of the resulting simplitigs and unitigs for individual species pan-genomes"
)

# 4) Simplitigs/unitigs index -------------------------------------------------------

load_seq_stats <- function(fn, dataset) {
  df0 <- read_tsv(fn)

  df <- df0 %>%
    rename(NS = simplitigs, CL = `cum len`) %>%
    select(-kmers) %>%
    mutate(NS = NS / 1e6, CL = CL / 1e9) %>%
    mutate(method = str_replace_all(name, "\\d+(_solid\\d+){0,1}\\.(fasta|fa|fsa)", "")) %>%
    mutate(k = str_replace_all(name, "[a-zA-Z.]", "")) %>%
    mutate(k = str_replace_all(k, "_10", "")) %>%
    select(-name)

  df2 <- df %>%
    pivot_wider(names_from = method, values_from = c(NS, CL)) %>%
    select(k, NS_bc, CL_bc, everything()) %>%
    mutate(`NS reduction\nratio` = NS_bc / NS_pa) %>%
    mutate(`CL reduction\nratio` = CL_bc / CL_pa) %>%
    rename(`Simplitig NS\n[M]` = NS_pa) %>%
    rename(`Unitig NS\n[M]` = NS_bc) %>%
    rename(`Simplitig CL\n[Gpb]` = CL_pa) %>%
    rename(`Unitig CL\n[Gbp]` = CL_bc) %>%
    mutate(dataset = dataset) %>%
    select(dataset, k, everything()) %>%
    arrange_all()

  df2
}

df_all <- load_seq_stats("seq_stats_all.tsv", "all")
df_solid <- load_seq_stats("seq_stats_solid10.txt", "solid")


es_add_sheet(
  wb,
  rbind(df_solid, df_all),
  "d) Datasets simplitigs",
  "Datasets simplitigs",
  "Characteristics of the resulting simplitigs and unitigs for the Solid and All datasets"
)


# 5) Performance -------------------------------------------------------

load_perf <- function(fn, env) {
  df0 <- read_tsv(fn)

  df <- df0 %>%
    mutate(file = str_replace_all(file, ".log", "_all")) %>%
    mutate(file = str_replace_all(file, "_solid10_all", "_solid")) %>%
    separate(file, c("experiment", "dataset"), sep = "_") %>%
    separate(experiment, c("method", "k"), sep = 2) %>%
    mutate(method = str_replace_all(method, "bc", "unitigs")) %>%
    mutate(method = str_replace_all(method, "pa", "simplitigs")) %>%
    mutate(environment = env) %>%
    select(environment, dataset, method, k, iter, everything()) %>%
    mutate(iteration = iter) %>%
    arrange_all()
  df
}

df_perf_imac <- load_perf("fastmap_imac.tsv", "desktop")
df_perf_o2 <- load_perf("fastmap_o2.tsv", "cluster")
#df_solid <- load_seq_stats("seq_stats_solid10.txt")


es_add_sheet(
  wb,
  rbind(df_perf_imac, df_perf_o2),
  "e) Performance",
  "Performance",
  "Memory footprint, index loading time and time to query 10 million k-mers using BWA"
)


es_save(wb, fn)
