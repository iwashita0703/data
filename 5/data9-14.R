# データ読み込み
Body <- read.table("SampleData03_forR2.csv", header=TRUE, sep=",")

# ★ ここを自由に変更
x_col <- 6                 # x軸
y_cols <- c(7,8,9)         # 重ねる3つ（合計4項目）

# PDF出力
pdf("figs_9_14.pdf")

# データ取得
x <- Body[, x_col]
y_list <- Body[, y_cols]

# 色リスト（必要なら増やせる）
colors <- c("red","blue","green","orange")

# 1つ目（ベース）
plot(x, y_list[,1],
     col=colors[1],
     xlab=paste("Column", x_col),
     ylab="Value",
     main=paste("Overlay Scatter:", x_col, "vs others"),
     xlim=range(x),
     ylim=range(y_list))

# 2個目以降を重ねる
for(i in 2:ncol(y_list)){
  par(new=TRUE)
  plot(x, y_list[,i],
       col=colors[i],
       xlab="", ylab="",
       xlim=range(x),
       ylim=range(y_list))
}

# 保存
dev.off()