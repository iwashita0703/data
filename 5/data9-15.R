
Body <- read.table("SampleData03_forR2.csv", header=TRUE, sep=",")

# ★ ここを自由に変更（使う2列）
x_col <- 6
y_col <- 7

# ★ マーカー設定（ここも自由に変更OK）
pch_list <- c(1, 16, 21)
col_list <- c("red", "blue", "green")
bg_list  <- c(NA, NA, "yellow")  # pch=21のときだけ使う

pdf("figs_9_15.pdf")

# データ取得
x <- Body[, x_col]
y <- Body[, y_col]

for(i in 1:3){
  plot(x, y,
       pch=pch_list[i],
       col=col_list[i],
       bg=bg_list[i],
       main=paste("Pattern", i,
                  "(Col", x_col, "vs", y_col, ")"),
       xlab=paste("Column", x_col),
       ylab=paste("Column", y_col))
}

dev.off()