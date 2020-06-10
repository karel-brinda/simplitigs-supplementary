#!/usr/bin/env Rscript

library(tidyverse)
library(patchwork)
library(lubridate)
library(ggsci)
library(stringr)

w <- 5
h <- 5

#scale_colour_discrete <- function(...) {
#  scale_color_nejm(...)
#}

theme_set(
  theme_classic(base_family = 'Helvetica', base_size = 20) +
    theme(
      #legend.title = element_blank(),
      plot.margin = unit(c(2.5, 7.5, 3.5, 7.5), "pt"),
      legend.position = "none",
      legend.justification = "top",
      legend.title = element_blank(),
      axis.line = element_line(color = 'black',
                               linetype = 'solid'),
      axis.ticks = element_line(color = 'black',
                                linetype = 'solid'),
      axis.ticks.length = unit(0.25, "cm"),
      axis.title.x = element_blank(),
      axis.title.y = element_blank()
    )
)


df <- read_tsv("03_performance_table.complete.tsv") %>%
  #mutate(cputime.sm = hms(cputime.sm)) %>%
  #mutate(cputime.gnu = hms(cputime.gnu)) %>%
  mutate(g = str_c(method, threads)) %>%
  mutate(g = str_replace(g, "pa1", "\nProphAsm\n(1 thread)")) %>%
  mutate(g = str_replace(g, "bc1", "\nBCALM 2\n(1 thread)")) %>%
  mutate(g = str_replace(g, "bc4", "\nBCALM 2\n(4 threads)"))

plot.species <- function(df, spec, fn, legend = F) {
  df.filt <- df %>%
    filter(species == spec)

  sc.shape <-
    scale_shape_manual(name = "Program", values = c(16, 16, 17))
  sc.color <- scale_color_manual(name = "Program",
                                 values = c(pal_nejm()(2)[1],
                                            pal_nejm(alpha = 0.2)(2)[1],
                                            pal_nejm()(2)[2]))

  p <- ggplot(df.filt) + geom_point(aes(
    x = k,
    y = mem.gnu / 1000,
    color = g,
    shape = g
  ),
  size = 2) +
    sc.shape + sc.color +
    labs(color = "Program")

  p <- p + theme(legend.position = "right")

  q <- ggplot(df.filt) + geom_point(aes(
    x = k,
    y = as.numeric(cputime.sm) / 60,
    color = g,
    shape = g
  ),
  size = 2) + sc.shape + sc.color


  r <- p / q

  r + ggsave(paste0(fn, ".pdf"), width = w, height = h)
}

if (Sys.getenv("RSTUDIO") == "1") {
  plot.species(df, "yeast", "03_yeast", legend = T)
} else{
  plot.species(df, "spneumoniae", "01_spneumoniae")
  plot.species(df, "ecoli", "02_ecoli")
  plot.species(df, "yeast", "03_yeast", legend = T)

  plot.species(df, "celegan", "04_celegan")
  plot.species(df, "bombyx", "05_bombyx")
  plot.species(df, "hg38", "06_hg38")
}
