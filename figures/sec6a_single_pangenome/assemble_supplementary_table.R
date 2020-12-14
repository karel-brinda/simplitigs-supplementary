#!/usr/bin/env Rscript

library(tidyverse)
library(easySupplementary)


fn <- "Additional_File_5.xlsx"

wb <- es_create()

# 1) Simplitigs / unitigs -------------------------------------------------------

df <- read_tsv("seq_stats.txt") %>%
  mutate(NS = ns / 1e3, CL = cl / 1e6) %>%
  select(-ns,-cl) %>%
  mutate(method = str_replace_all(fn, "\\d+\\.(fasta|fna|fa|fsa)", "")) %>%
  mutate(method = str_replace_all(method, "ngono\\.", "")) %>%
  mutate(method = str_replace_all(method, "bc", "unitigs")) %>%
  mutate(method = str_replace_all(method, "pa", "simplitigs")) %>%
  mutate(method = str_replace_all(method, "me", "assemblies")) %>%
  mutate(method = factor(method, levels = c("assemblies", "unitigs", "simplitigs"))) %>%
  mutate(k = str_replace_all(fn, "[a-zA-Z.]", "")) %>%
  filter (k > 15) %>%
  select(-fn) %>%
  select(method, k, everything()) %>%
  arrange_all()


add_rel <- function (x, k) {
  bns_uni <- x %>%
    filter(method == "unitigs") %>%
    select(NS) %>%
    as.numeric

  bcl_uni <- x %>%
    filter(method == "unitigs") %>%
    select(CL) %>%
    as.numeric

  bns_sim <- x %>%
    filter(method == "simplitigs") %>%
    select(NS) %>%
    as.numeric

  bcl_sim <- x %>%
    filter(method == "simplitigs") %>%
    select(CL) %>%
    as.numeric

  bns_asm <- x %>%
    filter(method == "assemblies") %>%
    select(NS) %>%
    as.numeric

  bcl_asm <- x %>%
    filter(method == "assemblies") %>%
    select(CL) %>%
    as.numeric

  x %>%

    mutate(`NS\nrel_impr_asm` = bns_asm / NS) %>%
    mutate(`NS\nrel_impr_uni` = bns_uni / NS) %>%
    mutate(`NS\nrel_impr_sim` = bns_sim / NS) %>%

    mutate(`CL\nrel_impr_asm` = bcl_asm / CL) %>%
    mutate(`CL\nrel_impr_uni` = bcl_uni / CL) %>%
    mutate(`CL\nrel_impr_sim` = bcl_sim / CL)

}

df2 <- df %>%
  group_by(k) %>%
  group_modify(add_rel) %>%
  ungroup()

# df2 <- df %>%
#   pivot_wider(names_from = method, values_from = c(NS, CL)) %>%
#   select(k, NS_bc, CL_bc, everything()) %>%
#   mutate(`NS reduction\nratio` = NS_bc / NS_pa) %>%
#   mutate(`CL reduction\nratio` = CL_bc / CL_pa) %>%
#   rename(`Simplitig NS\n[k]` = NS_pa) %>%
#   rename(`Unitig NS\n[k]` = NS_bc) %>%
#   rename(`Simplitig CL\n[Mpb]` = CL_pa) %>%
#   rename(`Unitig CL\n[Mbp]` = CL_bc) %>%
#   select(k, everything()) %>%
#   arrange_all()

es_add_sheet(
  wb,
  df2,
  "a) Simplitigs",
  "Simplitigs",
  "Characteristics of the N. gonorrhoeae pan-genome simplitigs and unitigs"
)



# 2) Performance -------------------------------------------------------

df0 <- read_tsv("fastmap_imac.tsv")

df <- df0 %>%
  mutate(method = str_replace_all(method, "bc", "unitigs")) %>%
  mutate(method = str_replace_all(method, "pa", "simplitigs")) %>%
  mutate(method = str_replace_all(method, "me", "assemblies")) %>%
  mutate(method = factor(method, levels = c("assemblies", "unitigs", "simplitigs"))) %>%
  arrange(k, method)

add_rel <- function (x, k) {
  bmat_uni <- x %>%
    filter(method == "unitigs") %>%
    select(matching) %>%
    as.numeric

  bmem_uni <- x %>%
    filter(method == "unitigs") %>%
    select(mem) %>%
    as.numeric

  bmat_sim <- x %>%
    filter(method == "simplitigs") %>%
    select(matching) %>%
    as.numeric

  bmem_sim <- x %>%
    filter(method == "simplitigs") %>%
    select(mem) %>%
    as.numeric

  bmat_asm <- x %>%
    filter(method == "assemblies") %>%
    select(matching) %>%
    as.numeric

  bmem_asm <- x %>%
    filter(method == "assemblies") %>%
    select(mem) %>%
    as.numeric

  x %>%

    mutate(`matching\nrel_impr_asm` = bmat_asm / matching) %>%
    mutate(`matching\nrel_impr_uni` = bmat_uni / matching) %>%
    mutate(`matching\nrel_impr_sim` = bmat_sim / matching) %>%

    mutate(`memory\nrel_impr_asm` = bmem_asm / mem) %>%
    mutate(`memory\nrel_impr_uni` = bmem_uni / mem) %>%
    mutate(`memory\nrel_impr_sim` = bmem_sim / mem)

}

df2 <- df %>%
  group_by(k) %>%
  group_modify(add_rel) %>%
  ungroup %>%
  rename(`loading\n[s]` = loading) %>%
  rename(`matching\n[s]` = matching) %>%
  mutate(mem = 1000 * mem) %>%
  rename(`memory\n[MB]` = mem)



es_add_sheet(
  wb,
  df2,
  "b) Performance",
  "Performance",
  "Memory footprint, index loading time and time to query 10 million k-mers using BWA for the N. gonorrhoeae pan-genome"
)

es_save(wb, fn)
