##################################################
# 11-2A
##################################################

# データ読み込み
Body <- read.table("SampleData03_forR2.csv",
                   header=TRUE,
                   sep=",")
pdf("data4.pdf")
# xとy
x1 <- Body[,7]
y1 <- Body[,8]

# 散布図
plot(y1 ~ x1,
     xlab="Weight",
     ylab="Height",
     pch=21)

# 回帰分析
result <- lm(y1 ~ x1)

# 回帰直線
abline(result)
dev.off()