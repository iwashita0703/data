getwd()

Body <- read.table("SampleData03_forR2.csv", header=TRUE, sep=",")


pdf("figs_9_12.pdf")

for(i in 6:10){
  x <- Body[, i]
  y <- Body[, i+1]
  
  hist(x, main=paste("Histogram of column", i))
  hist(y, main=paste("Histogram of column", i+1))
  plot(x, y, main=paste("Scatter:", i, "vs", i+1),
       xlab=paste("Column", i),
       ylab=paste("Column", i+1))
}

# 保存終了
dev.off()