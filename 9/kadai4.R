# PDF 出力開始（YY は自分の番号に変更）
pdf("Class12_rp12-3A_YY.pdf")

# パイチャートの描画（資料と完全一致）
pie(
  c(Banana=45, Berry=30, Apple=20, Kiwi=5),
  density = c(60, 50, 40, 30)
)

# PDF 出力終了
dev.off()
