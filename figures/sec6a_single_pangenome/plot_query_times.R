#!/usr/bin/env Rscript

library(tidyverse)
library(patchwork)
library(ggsci)
library(scales)

isRStudio <- Sys.getenv("RSTUDIO") == "1"

w <- 2.5
h <- 2.5
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



df0 <- read_tsv("fastmap_imac.tsv")

df <- df0 %>%
  mutate(method = str_replace(method, "pa", "Simplitigs")) %>%
  mutate(method = str_replace(method, "bc", "Unitigs")) %>%
  mutate(method = str_replace(method, "me", "Assemblies")) %>%
  mutate(method = fct_rev(as.factor(method))) %>%
  mutate(mem = mem * 1e3) %>%
  mutate(k = as.factor(k))

yticks_mem <- c(0, 25, 50, 2000, 3500)

trans_mem <- function(x) {
  pmin(x, 50) + 0.01 * pmax(x - 50, 0)
}


p <- ggplot(df) +
  geom_bar(aes(
    x = k,
    y = trans_mem(mem),
    fill = method
  ),
  stat = "identity",
  position = position_dodge()) +
  scale_y_continuous(limits = c(0, NA),
                     breaks = trans_mem(yticks_mem),
                     labels = yticks_mem) +
  geom_rect(
    xmin = 0,
    xmax = 6,
    ymin = 55,
    ymax = 61,
    fill = "white"
  ) +
  xlab("") +
  ylab("")

# q <- ggplot(df) +
#   geom_bar(aes(x = k, y = loading, fill = method),
#            stat = "identity",
#            position = position_dodge()) +
#   ylim(ylim.loading) +
#   xlab("") +
#   ylab("") +
#   theme(legend.position = "none")

trans_mat <- function(x) {
  pmin(x, 40) + 0.0060 * pmax(x - 40, 0)
}

yticks_mat <- c(0, 20, 40, 9000, 12000)

r <- ggplot(df) +
  geom_bar(aes(
    x = k,
    y = trans_mat(matching),
    fill = method
  ),
  stat = "identity",
  position = position_dodge()) +
  scale_y_continuous(limits = c(0, NA),
                     breaks = trans_mat(yticks_mat),
                     labels = yticks_mat) +
  geom_rect(
    xmin = 0,
    xmax = 6,
    ymin = 55,
    ymax = 61,
    fill = "white"
  ) +
  xlab("") +
  ylab("") +
  theme(legend.position = "none")

r


(p / r) + ggsave("imac.pdf", width = w, height = h)
