#!/usr/bin/env Rscript

library(tidyverse)

df0 <- read_tsv("o2_results.tsv")

df <- df0 %>%
  pivot_wider(names_from = version, values_from = time) %>%
  mutate(improvement = `2.2.2` / `2.2.3`) %>%
  write_tsv("o2_results_postprocessed.tsv")
