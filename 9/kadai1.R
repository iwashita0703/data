# CSV の読み込み
Body <- read.table("SampleData03_forR2.csv", header = TRUE, sep = ",")

# PDF 出力開始
pdf("Class12_rp12-1A_YY.pdf")   # ← YY は自分の番号に置き換える

# 棒グラフの描画
barplot(
  Body[,7],                     # 体重データ
  xlab = "number",              # x軸ラベル
  ylab = "weight",              # y軸ラベル
  names.arg = Body[,2],         # ID を x軸ラベルに
  las = 2,                      # ラベルを縦向きに
  cex.names = 0.5               # ラベル文字サイズ
)

# PDF 出力終了
dev.off()
