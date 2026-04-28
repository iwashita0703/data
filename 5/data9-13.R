
Body <- read.table("SampleData03_forR2.csv", header=TRUE, sep=",")

cols <- c(6,7,8,9)

pdf("figs_9_13.pdf")

plot(Body[, cols],
     main=paste("Scatter Plot Matrix:", paste(cols, collapse=", ")))

dev.off()