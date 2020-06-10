#!/usr/bin/env Rscript

source("include.R")

df <- df %>% filter(dataset == "gc31")

sc <- scale_linetype_manual(
  name = "Colors",
  values = c(
    "a" = 2,
    "b" = 1,
    "c" = 4,
    "d" = 3,
    "e" = 5
  ),
  labels = c("unit", "simpl", "lobound")
)



# As a function of #genomes --------------------------

p <-
  ggplot(df) + sc +
  geom_line(aes(x = genomes, y = bc.seq.count, linetype = "a")) +
  geom_line(aes(x = genomes, y = pa.seq.count, linetype = "b")) +
  geom_line(aes(x = genomes, y = 1, linetype = "c")) +
  ylab("") +
  xlab("") +
  ylim(0, NA) +
  theme(legend.position = "none")

q <-
  ggplot(df) + sc +
  geom_line(aes(x = genomes, y = bc.cum.len, linetype = "a")) +
  geom_line(aes(x = genomes, y = pa.cum.len, linetype = "b")) +
  geom_line(aes(x = genomes, y = kmers, linetype = "c")) +
  ylab("") +
  xlab("") +
  ylim(0, NA) +
  theme(legend.position = "none")

pw <- p / q
pw + ggsave("single_ngenomes.pdf", width = w, height = h)


# As a function of #kmers --------------------------


p <-
  ggplot(df) + sc +
  geom_line(aes(x = kmers, y = bc.seq.count, linetype = "a")) +
  geom_line(aes(x = kmers, y = pa.seq.count, linetype = "b")) +
  geom_line(aes(x = kmers, y = 1, linetype = "c")) +
  ylab("") +
  xlab("") +
  ylim(0, NA) +
  xlim(2, NA) +
  guides(linetype=guide_legend(nrow=2))

q <-
  ggplot(df) + sc +
  geom_line(aes(x = kmers, y = bc.cum.len, linetype = "a")) +
  geom_line(aes(x = kmers, y = pa.cum.len, linetype = "b")) +
  geom_line(aes(x = kmers, y = kmers, linetype = "c")) +
  ylab("") +
  xlab("") +
  ylim(0, NA) +
  xlim(2, NA) +
  theme(legend.position = "none")

pw <- p / q
pw + guides(guide_legend(nrow=2)) + ggsave("single_kmers.pdf", width = w, height = h_leg)
