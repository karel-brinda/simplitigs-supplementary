#!/usr/bin/env Rscript

library(tidyverse)
library(ggsci)

w <- 6.75
h <- 3

bw <- 0.5
bd <- 0.6

theme_set(
  theme_minimal(base_family = 'Helvetica') +
    theme(
      legend.title = element_blank(),
      legend.margin = unit(x = c(0, 0, 0, 0), units = "mm"),
      plot.margin = unit(c(1.5, 0.0, 0.0, 15), "pt"),
      plot.background = element_rect(colour = "white"),
      text = element_text(size = 10),
      #panel.grid.minor = element_blank(),
      axis.text.x = element_blank()
      #axis.text.x = element_text(angle = 45)
    )
)

scale_fill_discrete <- function(...) {
  scale_fill_nejm(...)
}


df0 <- read_tsv("preprocessed_results.tsv") %>%
  mutate(method = str_replace(method, "unitigs", "Unitigs-fa")) %>%
  mutate(method = str_replace(method, "simplitigs", "Simplitigs-fa")) %>%
  mutate(method = str_replace(method, "assembly", "Assemblies-fa")) %>%
  mutate(method = str_replace(method, "boss", "BOSS-tar")) %>%
  mutate(method = factor(method, levels = c(
    "Unitigs-fa", "Simplitigs-fa", "Assemblies-fa", "BOSS-tar"
  )))

df1 <- df0 %>%
  filter(grepl('(pneumo|ngono|bombyx|hg)', experiment)) %>%
  mutate(experiment = factor(
    experiment,
    levels = c(
      "spneumoniae",
      "bombyx",
      "hg38",
      "pangenome-spneumoniae",
      "pangenome-ngonorrhoeae"
    )
  ))


df18 <- df1 %>%
  filter(compressed == T, k == 18)

df31 <- df1 %>%
  filter(compressed == T, k == 31)

df.18.31 <- df1 %>%
  filter(compressed == T) %>%
  select(-size,-kmers,-compressed) %>%
  spread(k, bits_per_kmer) %>%
  rename(`k18` = `18`, `k31` = `31`)

df.18.all <- df1 %>%
  filter(k == 18) %>%
  select(-size,-kmers,-k) %>%
  spread(compressed, bits_per_kmer) %>%
  rename(`compressed` = `TRUE`, `uncompressed` = `FALSE`)

df.31.all <- df1 %>%
  filter(k == 31) %>%
  select(-size,-kmers,-k) %>%
  spread(compressed, bits_per_kmer) %>%
  rename(`compressed` = `TRUE`, `uncompressed` = `FALSE`)

p <-
  ggplot(df18, aes(x = experiment, y = bits_per_kmer, fill = method)) +
  scale_y_continuous(breaks = seq(0, 50, 4), limits = c(0, 20)) +
  geom_bar(stat = "identity",
           width = bw,
           position = position_dodge(bd),
  ) +
  ylab("") +
  xlab("")
p + ggsave("bits_per_kmer.k18.pdf",
           width = w,
           height = h)

q <-
  ggplot(df31, aes(x = experiment, y = bits_per_kmer, fill = method)) +
  scale_y_continuous(breaks = seq(0, 50, 4), limits = c(0, 20)) +
  geom_bar(stat = "identity",
           width = bw,
           position = position_dodge(bd),
  ) +
  ylab("") +
  xlab("")
q + ggsave("bits_per_kmer.k31.pdf",
           width = w,
           height = h)


r <- ggplot(df.18.31, aes(x = experiment, fill = method)) +
  scale_y_continuous(breaks = seq(0, 50, 4), limits = c(0, 20)) +
  geom_bar(
    stat = "identity",
    width = bw,
    position = position_dodge(bd),
    aes(y = k18),
    alpha = 0.2
  ) +
  geom_bar(stat = "identity",
           width = bw,
           position = position_dodge(bd),
           aes(y = k31)) +
  ylab("") +
  xlab("")
r + ggsave("bits_per_kmer.k18_k31.pdf",
           width = w,
           height = h)


s18 <- ggplot(df.18.all, aes(x = experiment, fill = method)) +
  scale_y_continuous(
    trans = 'log2',
    breaks = 4 ^ seq(0, 50, 1),
    limits = c(1, 6000)
  ) +
  geom_bar(
    stat = "identity",
    width = bw,
    position = position_dodge(bd),
    aes(y = uncompressed),
    alpha = 0.2
  ) +
  geom_bar(
    stat = "identity",
    width = bw,
    position = position_dodge(bd),
    aes(y = compressed)
  ) +
  geom_hline(aes(yintercept=8), alpha=0.2, linetype="dashed") +
  geom_hline(aes(yintercept=2), linetype="dashed") +
  ylab("") +
  xlab("") +
  theme(legend.margin = margin(t = 4, unit = 'cm'))
s18 + ggsave("bits_per_kmer.uncompr_compr.k18.pdf",
             width = w,
             height = h)

s31 <-
  ggplot(df.31.all, aes(
    x = experiment,
    fill = method)
  ) +
  scale_y_continuous(
    trans = 'log2',
    breaks = 4 ^ seq(0, 50, 1),
    limits = c(1, 6000)
  ) +
  geom_bar(
    stat = "identity",
    width = bw,
    position = position_dodge(bd),
    aes(y = uncompressed),
    alpha = 0.2
  ) +
  geom_bar(
    stat = "identity",
    width = bw,
    position = position_dodge(bd),
    aes(y = compressed)
  ) +
  geom_hline(aes(yintercept=8), alpha=0.2, linetype="dashed") +
  geom_hline(aes(yintercept=2), linetype="dashed") +
  ylab("") +
  xlab("") +
  scale_fill_discrete(labels = c("No compr ", "xz", "", "Lower\nbound")) +
  guides(fill = guide_legend(override.aes = list(
    alpha = c(0.2, 1.0, 0.0, 0.0),
    fill = rep(1, 4),
    linetype = c(0, 0, 0, 2),
    color = c(NA, NA, NA, 1)
    #fill = rep(pal_nejm("default")(4)[1], 4)
  ))) +
  theme(legend.margin = margin(b = 4.0, r = 0.52, unit = 'cm'))
s31 + ggsave("bits_per_kmer.uncompr_compr.k31.pdf",
             width = w,
             height = h)
