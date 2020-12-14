#!/usr/bin/env Rscript

library(patchwork)
library(tidyverse)
library(ggsci)

w <- 2.2
h <- 2
ps <- 1.5
lw <- 0.2


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

scale_colour_discrete <- function(...) {
  scale_colour_nejm(...)
}

plot_simpl <- function(fn) {
  solid <- str_detect(fn, "solid")
  
  if (solid) {
    ylim_ns = c(0, 300)
    ylim_cl = c(0, 10)
  } else{
    ylim_ns = c(0, 600)
    ylim_cl = c(0, 30)
  }
  
  df <- read_tsv(fn) %>%
    select(-kmers) %>%
    mutate(name = str_replace(name, "(_solid[0-9]+)?\\.fa(sta)?", "")) %>%
    separate(col = "name",
             into = c("method", "k"),
             sep = 2) %>%
    mutate(kmers = (`cum len` - simplitigs * (as.numeric(k) - 1)) / 1e9) %>%
    mutate(method = str_replace(method, "pa", "Simplitigs")) %>%
    mutate(method = str_replace(method, "bc", "Unitigs")) %>%
    mutate(ns = simplitigs / 1e6, cl = `cum len` / 1e9) %>%
    mutate(method = fct_rev(as.factor(method)))
  
  dfk <- df %>%
    filter(method == "Simplitigs")
  
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
  
  q <- ggplot(df, aes(
    x = k,
    y = cl,
    shape = method,
    colour = method
  )) +
    geom_point(size = ps) +
    geom_line(aes(group = method), size = lw) +
    ylim(ylim_cl) +
    xlab("") +
    ylab("") +
    theme(legend.position = "none")+
    #geom_point(aes(x = k, y = kmers),size = ps, shape =3,color="grey") +
    geom_line(aes(x = k, y = kmers, group=method), color="grey30", linetype="dotdash")
    
  p / q
}

plot_simpl("seq_stats_all.tsv") + ggsave("simplitigs.all.pdf", width = w, height = h)
plot_simpl("seq_stats_solid10.txt") + ggsave("simplitigs.solid.pdf", width = w, height = h)
