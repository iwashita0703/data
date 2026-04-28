
Body <- read.table("SampleData03_forR2.csv", header=TRUE, sep=",")

# ★ ここを自由に変更（4列）
cols <- c(6,7,8,9)


group_col <- "Sex"


Body[[group_col]] <- factor(Body[[group_col]])


colors <- c("red", "blue", "green", "orange")


pdf("figs_9_16.pdf")


pairs(Body[, cols],
      pch=21,
      bg=colors[unclass(Body[[group_col]])],
      main=paste("Scatter Matrix:",
                 paste(cols, collapse=", "),
                 "(Colored by", group_col, ")"))


dev.off()