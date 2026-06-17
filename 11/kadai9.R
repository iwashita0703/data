# データ読み込み
hyouka <- read.table("hyouka.csv", header = TRUE, sep = ",")

# 列順を強制的に指定（これが最重要）
hyouka6 <- data.frame(
  complaints = hyouka$complaints,
  privileges = hyouka$privileges,
  learning   = hyouka$learning,
  raises     = hyouka$raises,
  critical   = hyouka$critical,
  advance    = hyouka$advance
)

# PDF 出力
pdf("Class17_rp17-1A_YY.pdf", width = 7, height = 5)

boxplot(hyouka6,
        main = "",
        xlab = "",
        ylab = "Percent (%)",
        col = "lightgray",
        las = 2,
        cex.axis = 0.9)

dev.off()
