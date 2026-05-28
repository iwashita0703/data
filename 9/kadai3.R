# CSV の読み込み
Body <- read.table("SampleData03_forR2.csv", header = TRUE, sep = ",")

# PDF 出力開始（YY は自分の番号に変更）
pdf("Class12_rp12-2A_YY.pdf")

# ---- 1枚目：縦の箱ひげ図 ----
boxplot(
  Body[,10],
  Body[,11],
  Body[,12],
  Body[,13],
  main = "Vertical Boxplots",
  xlab = "Variables",
  ylab = "Values"
)

# ---- 2枚目：横の箱ひげ図 ----
boxplot(
  Body[,10],
  Body[,11],
  Body[,12],
  Body[,13],
  horizontal = TRUE,
  main = "Horizontal Boxplots",
  xlab = "Values",
  ylab = "Variables"
)

# PDF 出力終了
dev.off()
