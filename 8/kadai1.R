conveni <- read.table("conveni.csv", header=TRUE, sep=",")
hage <- read.table("hage.csv", header=TRUE, sep=",")
test_data <- read.table("test.csv", header=TRUE, sep=",")
pdf("Class08_rp15-2A_3A_YY.pdf")
par(mfrow=c(2,2))  # 2行2列で表示

expl_vars <- colnames(conveni)[2:5]  # 説明変数 X1〜X4
y_var <- conveni$uriage_hyakuman     # 目的変数 Y

for (i in expl_vars) {
  x_var <- conveni[[i]]
  
  # 散布図（タイトルなし）
  plot(x_var, y_var,
       main = "",   # ← タイトルを消す
       xlab = i, ylab = "Uriage")
  
  # 単回帰
  res <- lm(y_var ~ x_var)
  abline(res, col="blue")
  
  # 回帰式の係数
  a <- res$coefficients[1]  # 切片
  b <- res$coefficients[2]  # 傾き
  
  # R^2
  r2 <- summary(res)$r.squared
  
  # タイトル位置に縦に表示
  mtext(sprintf("y = %.2f x + %.2f", b, a),
        side = 3, line = 1.0, cex = 0.8)
  
  mtext(sprintf("R^2 = %.4f", r2),
        side = 3, line = 0.0, cex = 0.8)
}

dev.off()

