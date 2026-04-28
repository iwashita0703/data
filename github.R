# データ生成
set.seed(123)
x <- rnorm(100)
y <- 2 * x + rnorm(100)

# データフレーム作成
data <- data.frame(x, y)

# 散布図
plot(data$x, data$y,
     main = "Scatter Plot",
     xlab = "X",
     ylab = "Y",
     col = "blue",
     pch = 19)

# 回帰直線
model <- lm(y ~ x, data = data)
abline(model, col = "red", lwd = 2)

# モデル結果表示
summary(model)