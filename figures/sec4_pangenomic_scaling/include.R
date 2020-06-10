library(tidyverse)
library(patchwork)
library(scales)
library(ggsci)

w <- 2.8
w_leg1 <- w + 1.
w_leg2 <- w + 1.
h <- 5
h_leg <- 5+0.6

fs <- 16

update_geom_defaults("line", list(lineend = "round", size = 0.75))

scale_colour_discrete <- function(...) {
  scale_color_nejm(...)
}

theme_set(
  theme_classic(base_family = 'Helvetica') +
    theme(
      text = element_text(size = fs),
      legend.title = element_blank(),
      #legend.justification = "top",
      legend.position = "top",
      legend.margin=margin(),
      plot.margin = unit(c(0.0, 0.0, 0.0, 0.0), "pt"),
      axis.line = element_line(
        colour = 'black',
        size = 0.5,
        linetype = 'solid'
      ),
      axis.ticks = element_line(
        colour = 'black',
        size = 0.5,
        linetype = 'solid'
      ),
      axis.ticks.length = unit(0.25, "cm"),
      axis.text.x = element_text(margin = margin(t = 8))
    )
)


df <- read.delim("data.tsv", header = T, stringsAsFactors = F) %>%
  mutate(kmers = kmers / 1e6) %>%
  mutate(bc.seq.count = bc.seq.count / 1e3) %>%
  mutate(pa.seq.count = pa.seq.count / 1e3) %>%
  mutate(bc.cum.len = bc.cum.len / 1e6) %>%
  mutate(pa.cum.len = pa.cum.len / 1e6)

