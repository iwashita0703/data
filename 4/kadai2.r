Body = read.table("SampleData03_forR2.csv", header = T, sep = ",")
cname = colnames(Body)

pdf("body_plot.pdf")
plot(Body[,8:9], xlab = cname[8], ylab = cname[9])
dev.off()