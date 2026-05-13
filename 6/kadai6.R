# ===============================
# 11-6A 男女別 散布図＋回帰直線
# ===============================

Body <- read.table("SampleData03_forR2.csv",
                   header = TRUE, sep = ",")

Body_F <- subset(Body, Sex == "F")
Body_M <- subset(Body, Sex == "M")

# 幅は元（デフォルト）
pdf("11-6A_Gender.pdf")

# ---- 女性の散布図（赤）----
plot(
  Body_F[,8] ~ Body_F[,7],
  col = "red",
  pch = 16,
  xlab = "Weight",
  ylab = "Height"
)

# ---- 男性の散布図（青）を重ねる ----
points(
  Body_M[,8] ~ Body_M[,7],
  col = "blue",
  pch = 16
)

# ---- 回帰直線 ----
lm_F <- lm(Body_F[,8] ~ Body_F[,7])
abline(lm_F, col = "red", lwd = 2)

lm_M <- lm(Body_M[,8] ~ Body_M[,7])
abline(lm_M, col = "blue", lwd = 2)

# ---- 凡例 ----
legend(
  "topleft",
  legend = c("Female", "Male"),
  col = c("red", "blue"),
  pch = 16,
  lwd = 2
)

dev.off()