#!/usr/bin/env Rscript

library(tidyverse)
library(patchwork)
library(ggsci)

isRStudio <- Sys.getenv("RSTUDIO") == "1"

w <- 2.2
h <- 4
ps <- 0.25

theme_set(
  theme_minimal(base_family = 'Helvetica') +
    theme(
      legend.title = element_blank(),
      plot.margin = unit(c(1.5, 0.0, 0.0, 0), "pt"),
      legend.margin = unit(x = c(0, 0, 0, 0), units = "mm"),
      plot.background = element_rect(colour = "white"),
      text = element_text(size = 10),
      panel.grid.minor = element_blank()
    )
)

scale_fill_discrete <- function(...) {
  scale_fill_nejm(...)
}

plot_df <- function(df0, name) {
  solid <- str_detect(name, "solid")

  if (solid) {
    ylim.mem = c(0, 50)
    ylim.loading = c(0, 250)
    ylim.matching = c(0, 250)
  } else{
    ylim.mem = c(0, 120)
    ylim.loading = c(0, 1600)
    ylim.matching = c(0, 1000)
  }

  df <- df0 %>%
    mutate(file = str_replace(file, ".log", "")) %>%
    separate(file, into = c("method", "k"), sep = 2) %>%
    mutate(k = str_replace(k, "_solid10", "")) %>%
    mutate(method = str_replace(method, "pa", "Simplitigs")) %>%
    mutate(method = str_replace(method, "bc", "Unitigs")) %>%
    mutate(method = fct_rev(as.factor(method)))

  dfag <- df %>%
    group_by(method, k) %>%
    summarize(
      mem = mean(mem, na.rm = T),
      loading = mean(loading, na.rm = T),
      matching = mean(matching, na.rm = T)
    )

  p <- ggplot(dfag) +
    geom_bar(aes(x = k, y = mem, fill = method),
             stat = "identity",
             position = position_dodge()) +
    geom_point(
      aes(x = k, y = mem),
      data = df,
      position = position_dodge2(width = .8),
      size = ps
    ) +
    ylim(ylim.mem) +
    xlab("") +
    ylab("")

  q <- ggplot(dfag) +
    geom_bar(aes(x = k, y = loading, fill = method),
             stat = "identity",
             position = position_dodge()) +
    geom_point(
      aes(x = k, y = loading),
      data = df,
      position = position_dodge2(width = .8),
      size = ps
    ) +
    ylim(ylim.loading) +
    xlab("") +
    ylab("") +
    theme(legend.position = "none")

  r <- ggplot(dfag) +
    geom_bar(aes(x = k, y = matching, fill = method),
             stat = "identity",
             position = position_dodge()) +
    geom_point(
      aes(x = k, y = matching),
      data = df,
      position = position_dodge2(width = .8),
      size = ps
    ) +
    ylim(ylim.matching) +
    xlab("") +
    ylab("") +
    theme(legend.position = "none")

  (p / q / r) + ggsave(name, width = w, height = h)
}


df_imac <- read_tsv("fastmap_imac.tsv") %>%
  filter(grepl('solid', file))
plot_df(df_imac, "imac_solid.pdf")

if (!isRStudio) {
  df_imac <- read_tsv("fastmap_imac.tsv") %>%
    filter(!grepl('solid', file))
  plot_df(df_imac, "imac_full.pdf")

  df_o2_solid <- read_tsv("fastmap_o2.tsv") %>%
    filter(grepl('solid', file))
  plot_df(df_o2_solid, "o2_solid.pdf")

  df_o2_full <- read_tsv("fastmap_o2.tsv") %>%
    filter(!grepl('solid', file))
  plot_df(df_o2_full, "o2_full.pdf")
}
