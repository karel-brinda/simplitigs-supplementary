#!/usr/bin/env Rscript

library(tidyverse)
library(easySupplementary)

fn <- "Additional_File_4.xlsx"

wb <- es_create()

# Data import & processing -------------------------------------------------------

df1 <- read_tsv("preprocessed_results.tsv")
df2 <- read_tsv("preprocessed_results_wide.tsv")

# Data processing -------------------------------------------------------

es_add_sheet(wb, df1, "a) File sizes",
             "File sizes",
             "Sizes of individual produced files")
es_add_sheet(wb, df2, "b) Compression ratios",
             "Compression ratios",
             "Compression ratios for individual methods")

es_save(wb, fn)
