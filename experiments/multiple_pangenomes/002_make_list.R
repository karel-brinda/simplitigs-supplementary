#!/usr/bin/env Rscript

library(tidyverse)
library(stringr)


df <- read_tsv("assembly_summary.1_original.tsv", skip = 1) %>%
  filter(assembly_level == "Complete Genome") %>%
  filter(is.na(excluded_from_refseq))

write_tsv (df, "assembly_summary.2_filtered.tsv")

df.cleaned <- df %>%
  mutate(organism_name = word(organism_name, 1, 2, sep = " ")) %>%
  mutate(organism_name = str_replace_all(organism_name, "[^[:alnum:] ]", "")) %>%
  mutate(organism_name = str_replace_all(organism_name, " ", "_")) %>%
  mutate(organism_name = tolower(organism_name)) %>%
  mutate(rsync_path = str_replace_all(ftp_path, "ftp:", "rsync:"))

write_tsv (df.cleaned, "assembly_summary.3_cleaned.tsv")

df.final <- df.cleaned %>%
  select(rsync_path, organism_name)

write_tsv (df.final, "assembly_summary.4_final.tsv", col_names = F)
