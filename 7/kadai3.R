# ---------------------------------------------------------
# 13-1C：性別ごとの回帰直線の式と決定係数を左上に表示し、
#        女性・男性の2つの図を1つのPDFにまとめる
# ---------------------------------------------------------

# CSV 読み込み
Body <- read.table("SampleData03_forR2.csv", header=TRUE, sep=",")

# 性別で分割
Body_F <- subset(Body, Sex == "F")
Body_M <- subset(Body, Sex == "M")

# PDF 出力開始（ファイル名は課題ルールに合わせて変更）
pdf("Class13_rp13-1C_YY.pdf", width=7, height=7)

# ---------------------------------------------------------
# ★ 女性グラフ
# ---------------------------------------------------------
result_F <- lm(Body_F[,8] ~ Body_F[,7])
R2_F <- summary(result_F)$r.squared

plot(Body_F[,8] ~ Body_F[,7],
     xlab="Weight", ylab="Height",
     col="red", pch=19,
     main="Female: Weight vs Height")

abline(result_F, col="red", lwd=2)

# 左上に回帰式と R² を表示
text(min(Body_F[,7]) + 2,
     max(Body_F[,8]) - 20,
     sprintf("y = %.3f x + %.3f\nR² = %.3f",
             result_F$coefficients[2],
             result_F$coefficients[1],
             R2_F),
     col="red", adj=c(0,1))

# ---------------------------------------------------------
# ★ 男性グラフ
# ---------------------------------------------------------
result_M <- lm(Body_M[,8] ~ Body_M[,7])
R2_M <- summary(result_M)$r.squared

plot(Body_M[,8] ~ Body_M[,7],
     xlab="Weight", ylab="Height",
     col="blue", pch=19,
     main="Male: Weight vs Height")

abline(result_M, col="blue", lwd=2)

# 左上に回帰式と R² を表示
text(min(Body_M[,7]) + 2,
     max(Body_M[,8]) - 20,
     sprintf("y = %.3f x + %.3f\nR² = %.3f",
             result_M$coefficients[2],
             result_M$coefficients[1],
             R2_M),
     col="blue", adj=c(0,1))

# ---------------------------------------------------------
# PDF 終了
# ---------------------------------------------------------
dev.off()
