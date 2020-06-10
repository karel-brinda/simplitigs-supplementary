#!/usr/bin/env Rscript

library(tidyverse)
library(easySupplementary)

fn <- "Additional_File_1.xlsx"

wb <- es_create()

# Data import & processing -------------------------------------------------------

load_results <- function(fn) {
  df <- read_tsv(fn)
  df %>%
    select(-`superstr coef`,-`genome frac`) %>%
    rename(k = name, NS = simplitigs, CL = `cum len`)
}

merge_results <- function(fn.unitigs, fn.simplitigs) {
  df.u <- load_results(fn.unitigs)
  df.s <- load_results(fn.simplitigs)
  inner_join(df.u,
             df.s,
             by = "k",
             suffix = c(".unitigs", ".simplitigs")) %>%
    arrange(k) %>%
    rename(
      `unitigs NS` = NS.unitigs,
      `unitigs CL` = CL.unitigs,
      `unitigs #kmers` = kmers.unitigs
    ) %>%
    rename(
      `simplitigs NS` = NS.simplitigs,
      `simplitigs CL` = CL.simplitigs,
      `simplitigs #kmers` = kmers.simplitigs
    )
}

load_species <- function(species) {
  fn.u = paste0("data/results_", species, ".bc.tsv")
  fn.s = paste0("data/results_", species, ".pa.tsv")
  merge_results(fn.u, fn.s)
}

# Data processing -------------------------------------------------------

wb <- es_create()

es_add_sheet(
  wb,
  load_species("spneumoniae"),
  "a) S. pneumoniae",
  "Streptococcus pneumoniae",
  "Genome length: 2.22 Mbp"
)
es_add_sheet(wb,
             load_species("ecoli"),
             "b) E. coli",
             "Escherichia coli",
             "Genome length: 4.64 Mbp")
es_add_sheet(
  wb,
  load_species("yeast"),
  "c) S. cerevisiae",
  "Saccharomyces cerevisiae",
  "Genome length: 12.2 Mbp"
)
es_add_sheet(
  wb,
  load_species("celegan"),
  "d) C. elegans",
  "Caenorhabditis elegans",
  "Genome length: 100 Mbp"
)
es_add_sheet(wb,
             load_species("bombyx"),
             "e) B. mori",
             "Bombyx mori",
             "Genome length: 482 Mbp")
es_add_sheet(wb,
             load_species("hg38"),
             "f) H. sapiens",
             "Homo sapiens",
             "Genome length: 3.21 Gbp")

es_save(wb, fn)
