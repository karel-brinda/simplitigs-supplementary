#!/usr/bin/env Rscript

library(tidyverse)
library(easySupplementary)

fn <- "Additional_File_2.xlsx"

wb <- es_create()

# Performance -------------------------------------------------------------

df0 <- read_tsv("03_performance_table.complete.tsv")

df <- df0 %>%
  arrange(species, method, threads, k) %>%
  mutate(cputime.gnu = cputime.gnu / 60, cputime.sm = cputime.sm / 60) %>%
  mutate(method = str_replace(method, "bc", "unitigs")) %>%
  mutate(method = str_replace(method, "pa", "simplitigs")) %>%
  mutate(method = factor(method, levels = c("unitigs", "simplitigs"))) %>%
  mutate(species = str_replace(species, "spneumoniae", "S. pneumoniae")) %>%
  mutate(species = str_replace(species, "ecoli", "E. coli")) %>%
  mutate(species = str_replace(species, "yeast", "S. cerevisiae")) %>%
  mutate(species = str_replace(species, "bombyx", "B. mori")) %>%
  mutate(species = str_replace(species, "celegan", "C. elegans")) %>%
  mutate(species = str_replace(species, "hg38", "H. sapiens")) %>%
  mutate(species = factor(
    species,
    levels = c(
      "S. pneumoniae",
      "E. coli",
      "S. cerevisiae",
      "B. mori",
      "C. elegans",
      "H. sapiens"
    )
  )) %>%
  select(species,
         method,
         threads,
         k,
         cputime.gnu,
         mem.gnu,
         everything(),
         hostname) %>%
  select(-cputime.sm,-mem.sm) %>%
  rename(Species = species) %>%
  rename(Hostname = hostname) %>%
  rename(Representation = method) %>%
  rename(Threads = threads) %>%
  #rename(`CPU\n(Snakemake)\n[mins]` = cputime.sm) %>%
  #rename(`Memory\n(Snakemake)\n[MB]` = mem.sm) %>%
  rename(`CPU\n[mins]` = cputime.gnu) %>%
  rename(`Memory\n[MB]` = mem.gnu) %>%
  arrange_all()


es_add_sheet(
  wb,
  df,
  "a) Performance",
  "Performance comparison",
  "Memory and CPU performance comparison of ProphAsm vs. BCALM 2."
)

# Hardware specification -------------------------------------------------------------

df.spec <- read_tsv("hardware/hardware_table.tsv")

es_add_sheet(
  wb,
  df.spec,
  "b) Hardware",
  "Hardware specification",
  "Specification of the hardware on individual nodes of the HMS O2 cluster (adapted from https://wiki.rc.hms.harvard.edu/display/O2/O2+HPC+Cluster+and+Computing+Nodes+Hardware).",
  auto_size_columns = T
)


es_save(wb, fn)
