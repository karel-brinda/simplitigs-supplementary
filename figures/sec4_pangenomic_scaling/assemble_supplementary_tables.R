#!/usr/bin/env Rscript

library(tidyverse)
library(easySupplementary)

fn <- "Additional_File_3.xlsx"

wb <- es_create()

# Data import & processing -------------------------------------------------------

load_results <- function(fn, dset) {
  df <- read_tsv(fn)
  df %>%
    filter(dataset == dset) %>%
    select(-dataset,-species) %>%
    arrange(genomes) %>%
    rename(`unitigs NS` = bc.seq.count,
           `unitigs CL` = bc.cum.len,) %>%
    rename(`simplitigs NS` = pa.seq.count,
           `simplitigs CL` = pa.cum.len,) %>%
    rename(`NS reduction ratio` = impr.seq.count,
           `CL reduction ratio` = impr.cum.len,)
}


# Data processing -------------------------------------------------------

es_add_sheet(wb,
                 load_results("data.tsv", "gc18"),
                 "a) gc18",
                 "gc18",
                 "Neisseria gonorrhoeae, k=18"
)
es_add_sheet(wb,
                 load_results("data.tsv", "gc31"),
                 "b) gc31",
                 "gc31",
                 "Neisseria gonorrhoeae, k=31")
es_add_sheet(
  wb,
  load_results("data.tsv", "sp18"),
  "c) sp18",
  "sp18",
  "Streptococcus pneumoniae, k=18"
)
es_add_sheet(
  wb,
  load_results("data.tsv", "sp31"),
  "d) sp31",
  "sp31",
  "Streptococcus pneumoniae, k=31"
)

es_save(wb, fn)
