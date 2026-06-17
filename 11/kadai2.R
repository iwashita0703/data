library(MASS)

Tochi <- read.table("Tochi_kakaku.csv", header = TRUE, sep = ",")

Tochi_ans <- lda(Tochi[,1:4], Tochi[,5])

pdf("Class11_rp16-30B_YY.pdf")
plot(Tochi_ans, dimen = 1)
dev.off()
