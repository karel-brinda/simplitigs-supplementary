#!/usr/bin/env Rscript

library(tidyverse)

load.res <- function(filename) {
  # filename assumes the following format: "data/spneumoniae.bc31.tsv"
  df <- read.delim(filename, header = TRUE, stringsAsFactors = F)
  df %>%
    mutate(fn = filename) %>%
    select(fn, everything(),-superstr.coef, -genome.frac) %>%
    separate(fn, into = c(NA, "species", "metk", NA)) %>%
    separate(metk, into = c("method", "k"), sep = 2) %>%
    rename(seq.count = simplitigs, genomes = name)
}

partial.dfs <- list(
  load.res("data/spneumoniae.bc31.tsv"),
  load.res("data/spneumoniae.bc18.tsv"),
  load.res("data/spneumoniae.pa31.tsv"),
  load.res("data/spneumoniae.pa18.tsv"),
  load.res("data/ngonorrhoeae.bc31.tsv"),
  load.res("data/ngonorrhoeae.bc18.tsv"),
  load.res("data/ngonorrhoeae.pa31.tsv"),
  load.res("data/ngonorrhoeae.pa18.tsv")
)

df <- bind_rows(partial.dfs)

df2 <- df %>%
  unite("dataset" ,
        c("species", "k"),
        remove = F,
        sep = "") %>%
  mutate(dataset = str_replace_all(dataset, "spneumoniae", "sp")) %>%
  mutate(dataset = str_replace_all(dataset, "ngonorrhoeae", "gc")) %>%
  unite("characteristics" , c("kmers", "seq.count", "cum.len")) %>%
  spread("method", "characteristics") %>%
  separate(pa,
           into = c("pa.kmers", "pa.seq.count", "pa.cum.len"),
           convert = T) %>%
  separate(bc,
           into = c("bc.kmers", "bc.seq.count", "bc.cum.len"),
           convert = T) %>%
  select(-pa.kmers) %>%
  rename(kmers = bc.kmers) %>%
  mutate(impr.seq.count = bc.seq.count / pa.seq.count,
         impr.cum.len = bc.cum.len / pa.cum.len)

write.table(
  df2,
  file = 'data.tsv',
  quote = FALSE,
  sep = '\t',
  col.names = T,
  row.names = F
)
