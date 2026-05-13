# データ
x1 <- c(19,23,27,35,44,51,59,66)
y1 <- c(124,117,120,132,128,142,143,135)

# PDF保存開始
pdf("Class07_rp11-1A_02.pdf")

# 散布図
plot(
  y1 ~ x1,
  xlab="x",
  ylab="y",
  pch=16,
  xlim=c(15,70),
  ylim=c(110,150)
)

# 単回帰
result <- lm(y1 ~ x1)

# 回帰直線（赤）
abline(result, col="red", lwd=2)

# 平均線（青の横線）
abline(
  h = mean(y1),
  col = "blue",
  lwd = 2,
  lty = 2
)

# 任意の直線（緑）
# y = 0.5x + 110
abline(
  a = 110,
  b = 0.5,
  col = "green",
  lwd = 2,
  lty = 3
)

# 回帰式を左上に表示
text(
  20,
  148,
  labels=sprintf(
    "y = %.3fx + %.3f",
    result$coefficients[2],
    result$coefficients[1]
  ),
  pos=4
)

# PDF終了
dev.off()