#!/usr/bin/env Rscript

isRStudio <- Sys.getenv("RSTUDIO") == "1"
set.seed(42)

w = 2.8 #2.17 #3.5
h = 4.2 #3.26 #5.2
lw = 2

xlim = c(11, 31)

plot.points = F

p <- function (bc,
               pa,
               name = NA,
               xlab = T,
               ylab = T,
               legend = T) {
  df.bc <- read.delim(bc, header = TRUE, stringsAsFactors = F)
  df.pa <- read.delim(pa, header = TRUE, stringsAsFactors = F)

  par(
    mar = c(0, 0.0, 0.0, 0.3),
    mfrow = c(2, 1),
    oma = c(2.5, 3.2, 2.1, 0.2)
  )


  #
  # PANEL 1
  #
  plot(
    df.bc$name,
    df.bc$simplitigs / 1e6,
    type = "l",
    xlab = NA,
    ylab = NA,
    col = NA,
    xaxt = 'n',
    yaxt = 'n',
    xaxs = "i",
    yaxs = "i",
    xlim = xlim,
    ylim = c(0, 1.05 * max(df.bc$simplitigs / 1e6))
  )


  if (ylab) {
    mtext(#"#sequences [M]",
          expression(paste("NS [×10" ^ "6", "]")),
          side = 2,
          outer = F,
          line = 2.5,
          cex = 1.5
	)
  }

  polygon(
    c(df.bc$name, rev(df.bc$name)),
    c(df.bc$simplitigs / 1e6, rep(1 / 1e6, times = length(df.bc$name))),
    col = "grey90",
    border = NA
  )

  lines(df.bc$name, df.bc$simplitigs / 1e6, lty = 2, lw=lw)
  lines(df.pa$name,
        df.pa$simplitigs / 1e6,
        lty = 1, lw=lw)
  lines(df.pa$name, rep(1 / 1e6, times = length(df.pa$name)), lty = 4, lw=lw)


  axis(side = 2, labels=F, lwd=lw)

  axis(side = 2,
       pretty(c(1.15 * df.bc$simplitigs / 1e6,0)),
       las = 2)


  if (plot.points) {
    points(df.pa$name, df.pa$simplitigs / 1e6, pch = 4)
    points(df.bc$name, df.bc$simplitigs / 1e6, pch = 4)
  }

  mtext(
    substitute(italic(x), list(x = name)),
    side = 3,
    line = 0.5,
    cex = 1.5,
    outer = TRUE
  )

  if (legend) {
    legend(
      "topright",
      legend = c("Unitigs", "Simplitigs", "Lower bound"),
      lty = c(2, 1, 4),
	  lw = c(lw, lw, lw),
      bg = "white"
    )
  }


  #
  # PANEL 2
  #

  plot(
    df.bc$name,
    df.bc$cum.len / 1e6,
    type = "l",
    xlab = NA,
    ylab = NA,
    xaxs = "i",
    yaxs = "i",
    col = NA,
    xaxt = 'n',
    yaxt = 'n',
    xlim = xlim,
    ylim = c(0, 1.10 * max(df.bc$cum.len / 1e6) + 1)
  )
  rug(x = 11:31,
      ticksize = -0.025,
	  lwd=lw,
      side = 1)

  polygon(
    c(df.bc$name, rev(df.pa$name)),
    c(df.bc$cum.len / 1e6, rev(df.pa$kmers / 1e6)),
    col = "grey90",
    border = NA
  )

  lines(df.bc$name, df.bc$cum.len / 1e6, lty = 2, lw=lw)
  lines(df.pa$name, df.pa$cum.len / 1e6, lty = 1, lw=lw)
  lines(df.pa$name, df.pa$kmers / 1e6, lty = 4, lw=lw)

  axis(side = 2,
       pretty(c(0, 1.1 * df.bc$cum.len / 1e6)),
       las = 2, lwd=lw)

  axis(side = 1, seq(0, 35, 3), lwd=lw)

  if (plot.points) {
    points(df.pa$name, df.pa$cum.len / 1e6, pch = 1)
    points(df.bc$name, df.bc$cum.len / 1e6, pch = 1)
  }


  if (ylab) {
    mtext(
      "CL [Mbp]",
      side = 2,
      outer = F,
      line = 2.5,
	  cex = 1.5
    )
  }

  if (xlab) {
  mtext(
    expression(paste(italic("k"), "-mer length")),
    side = 1,
    line = 2.5,
    cex = 1.5,
    outer = TRUE
  )
  }

}


if (isRStudio) {
  p("data/results_bact.bc.tsv",
    "data/results_bact.pa.tsv")

} else{

  pdf("01_spneumoniae.pdf", width = w, height = h)
  p("data/results_spneumoniae.bc.tsv",
    "data/results_spneumoniae.pa.tsv",
    #"S. pneumoniae",
    legend = F,
    ylab = F,
    xlab = F
  )
  dev.off()


  pdf("02_ecoli.pdf", width = w, height = h)
  p("data/results_ecoli.bc.tsv",
    "data/results_ecoli.pa.tsv",
    #"E. coli",
    legend = F,
    xlab = F,
    ylab = F
  )
  dev.off()


  pdf("03_yeast.pdf", width = w, height = h)
  p(
    "data/results_yeast.bc.tsv",
    "data/results_yeast.pa.tsv",
    #"S. cerevisiae",
    legend = T,
    xlab = F,
    ylab = F
  )
  dev.off()

  pdf("04_celegan.pdf", width = w, height = h)
  p(
    "data/results_celegan.bc.tsv",
    "data/results_celegan.pa.tsv",
    #"C. elegans",
    legend = F,
    xlab = F,
    ylab = F
  )
  dev.off()

  pdf("05_bombyx.pdf", width = w, height = h)
  p(
    "data/results_bombyx.bc.tsv",
    "data/results_bombyx.pa.tsv",
    #"B. mori",
    legend = F,
    xlab = F,
    ylab = F
  )
  dev.off()

  pdf("06_hg38.pdf", width = w, height = h)
  p(
    "data/results_hg38.bc.tsv",
    "data/results_hg38.pa.tsv",
    #"H. sapiens",
    legend = F,
    xlab = F,
    ylab = F
  )
  dev.off()

}
