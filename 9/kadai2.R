# CSV の読み込み
Body <- read.table("SampleData03_forR2.csv", header = TRUE, sep = ",")

# PDF 出力開始（YY は自分の番号に変更）
pdf("Class12_rp12-1B_YY.pdf")

# ---- 1つ目の棒グラフ（体重） ----
barplot(
  Body[,7],
  xlab = "number",
  ylab = "weight",
  names.arg = Body[,2],
  las = 2,
  cex.names = 0.5
)

# ---- 2つ目の棒グラフ（身長） ----
barplot(
  Body[,8],
  xlab = "number",
  ylab = "height",
  names.arg = Body[,2],
  las = 2,
  cex.names = 0.5
)

# ---- 3つ目の棒グラフ（腰回り高さ） ----
barplot(
  Body[,10],
  xlab = "number",
  ylab = "waist_height",
  names.arg = Body[,2],
  las = 2,
  cex.names = 0.5
)

# PDF 出力終了
dev.off()
