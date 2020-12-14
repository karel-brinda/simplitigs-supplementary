#!/usr/bin/env Rscript

library(tidyverse)

df0 <- read_tsv("results.tsv", col_names = c("fn", "size"))

df <- df0 %>%
    separate(fn, c("experiment", "others", "suffix", "compressed"), sep = "[^[:alnum:]-]+") %>%
    select(-suffix) %>%
    extract(others, c("method", "k"), "(.*)([[:alnum:]]{2})", convert = T) %>%
    mutate(compressed = ifelse(is.na(compressed), F, T))


df.kmers <- read_tsv("kmer_counts_manual.tsv")

df.merged <- full_join(df, df.kmers, by = c("experiment", "k")) %>%
    mutate(bits_per_kmer = 8 * size / kmers)

df.merged %>% write_tsv("preprocessed_results.tsv")


df.merged.wide <- df.merged %>%
    select(-size) %>%
    pivot_wider(names_from = compressed,
                values_from = c(bits_per_kmer)) %>%
    rename(`xz_bits_per_kmer` = `TRUE`,
           `nocompr_bits_per_kmer` = `FALSE`) %>%
    mutate(`compr_ratio` = nocompr_bits_per_kmer / xz_bits_per_kmer) %>%
    write_tsv("preprocessed_results_wide.tsv")
