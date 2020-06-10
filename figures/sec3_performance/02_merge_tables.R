#!/usr/bin/env Rscript

library(tidyverse)

df.sm  <-
  read_tsv("01_snakemake_benchmark.tsv", col_types = "ffiidf")

df.gnu <-
  read_tsv("01_gnu_time.tsv", col_types = "ffiicdi")


df <-
  full_join(
    df.sm,
    df.gnu,
    by = c("species", "method", "k", "threads"),
    suffix = c(".sm", ".gnu")
  ) %>%
  mutate(mem.gnu = mem.gnu / 1000) %>%
  mutate(mem.sm = mem.sm)

write_tsv(df, "02_performance_table.all.tsv")


df.compl <- df[!is.na(df$cputime.sm), ]

write_tsv(df.compl, "03_performance_table.complete.tsv")
