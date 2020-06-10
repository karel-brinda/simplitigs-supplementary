#!/usr/bin/env Rscript

source("include.R")

# Reduction as a function of #genomes --------------------------

p <-
  ggplot(data = df, aes(x = genomes, y = impr.seq.count, group = dataset)) +
  geom_line(aes(color = dataset, linetype = dataset)) +
  #ylab("NS reduction ratio") +
  ylab("") +
  ylim(1, 5) +
  xlab("") +
  theme(legend.position = "none")


q <-
  ggplot(data = df, aes(x = genomes, y = impr.cum.len, group = dataset)) +
  geom_line(aes(color = dataset, linetype = dataset)) +
  #ylab("CL reduction ratio") +
  ylab("") +
  ylim(1, 1.8) +
  #xlab("#genomes") +
  xlab("") +
  theme(legend.position = "none")

pw <- p / q
pw + ggsave("reduction_genomes.pdf", width = w, height = h)




# Reduction as a function of #kmers --------------------------

p <-
  ggplot(df, aes(x = kmers, y = impr.seq.count, group = dataset)) +
  geom_line(aes(color = dataset, linetype = dataset)) +
  #scale_x_continuous(trans = log2_trans()) +
  #ylab("NS reduction ratio") +
  ylim(1, 5) +
  xlab("") +
  ylab("") +
  guides(color = guide_legend(nrow = 2))

q <-
  ggplot(data = df, aes(x = kmers, y = impr.cum.len, group = dataset)) +
  geom_line(aes(color = dataset, linetype = dataset)) +
  #scale_x_continuous(trans = log2_trans()) +
  #ylab("CL reduction ratio") +
  ylab("") +
  ylim(1, 1.8) +
  #xlab("#k-mers") +
  xlab("") +
  theme(legend.position = "none")

pw <- p / q
pw

pw + ggsave("reduction_kmers.pdf", width = w, height = h_leg)
