Body = read.table("SampleData03_forR2.csv", header = T, sep = ",")
cname = colnames(Body)

pdf("body.pdf")
x <- Body[,7]
y <- Body[,8]
plot(x, y)
dev.off()