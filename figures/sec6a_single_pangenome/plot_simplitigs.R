#!/usr/bin/env Rscript

library(patchwork)
library(tidyverse)
library(ggsci)

w <- 2.5
h <- 2.5
ps <- 1.5
lw <- 0.2


theme_set(
  theme_minimal(base_family = 'Helvetica') +
    theme(
      legend.title = element_blank(),
      legend.margin = unit(x = c(0, 0, 0, 0), units = "mm"),
      plot.margin = unit(c(1.5, 0.0, 0.0, 0), "pt"),
      plot.background = element_rect(colour = "white"),
      text = element_text(size = 10),
      panel.grid.minor = element_blank()
    )
)

scale_colour_discrete <- function(...) {
  scale_colour_nejm(...)
}

ylim_ns = c(0, 250)
ylim_cl = c(0, 15)

df <- read_tsv("seq_stats.txt") %>%
  mutate(fn = str_replace(fn, "\\.fna", "")) %>%
  mutate(fn = str_replace(fn, "ngono\\.", "")) %>%
  separate(col = "fn",
           into = c("method", "k"),
           sep = 2) %>%
  filter(k > 15) %>%
  mutate(method = str_replace(method, "pa", "Simplitigs")) %>%
  mutate(method = str_replace(method, "bc", "Unitigs")) %>%
  mutate(method = str_replace(method, "me", "Assemblies")) %>%
  mutate(kmers = ifelse(method == "Assemblies", NA, (cl - ns * (as.numeric(k) - 1)) / 1e6)) %>%
  mutate(ns = ns / 1e3, cl = cl / 1e6) %>%
  mutate(method = factor(method, levels = c("Unitigs", "Simplitigs", "Assemblies")))


p <- ggplot(df, aes(
  x = k,
  y = ns,
  shape = method,
  colour = method
)) +
  geom_point(size = ps) +
  geom_line(aes(group = method), size = lw) +
  ylim(ylim_ns) +
  xlab("") +
  ylab("")



trans_cl <- function(x) {
  pmin(x, 10) + 0.008 * pmax(x - 10, 0)
}

yticks_cl <- c(0, 5, 10, 2000, 2500)

q <- ggplot(df, aes(
  x = k,
  y = trans_cl(cl),
  shape = method,
  colour = method
)) +
  geom_point(size = ps) +
  geom_line(aes(group = method), size = lw) +
  scale_y_continuous(limits = c(0, NA),
                     breaks = trans_cl(yticks_cl),
                     labels = yticks_cl) +
  geom_rect(
    xmin = 0,
    xmax = 6,
    ymin = 16,
    ymax = 18,
    fill = "white",
    color = "white"
  ) +
  xlab("") +
  ylab("") +
  theme(legend.position = "none") +
  geom_line(aes(x = k, y = trans_cl(kmers), group = method),
            color = "grey30",
            linetype = "dotdash")

(p / q) + ggsave("simplitigs.pdf", width = w, height = h)
