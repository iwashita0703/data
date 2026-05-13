# ---------------------------------------------------------
# 13-3A：白抜き四角 + 小さいID文字（提出用）
# ---------------------------------------------------------

# CSV 読み込み
Body <- read.table("SampleData03_forR2.csv", header=TRUE, sep=",")

# 性別で分割
Body_F <- subset(Body, Sex == "F")
Body_M <- subset(Body, Sex == "M")

# PDF 出力開始
pdf("Class13_rp13-3A_YY.pdf", width=7, height=7)

# ---------------------------------------------------------
# ★ 女性（白抜き四角 + 小さいID）
# ---------------------------------------------------------
plot(Body_F[,7], Body_F[,8],
     xlab="Weight", ylab="Height",
     xlim=c(30,100), ylim=c(1400,2000),
     pch=22, col="red", bg="white", cex=2,
     main="Weight vs Height with ID Labels (Hollow Squares)")

# 女性 ID（さらに小さく）
text(Body_F[,7], Body_F[,8],
     labels=Body_F[,2],
     col="red", cex=0.35)

# ---------------------------------------------------------
# ★ 男性（白抜き四角 + 小さいID）
# ---------------------------------------------------------
par(new=TRUE)

plot(Body_M[,7], Body_M[,8],
     xlab="", ylab="",
     xlim=c(30,100), ylim=c(1400,2000),
     pch=22, col="blue", bg="white", cex=2)

# 男性 ID（さらに小さく）
text(Body_M[,7], Body_M[,8],
     labels=Body_M[,2],
     col="blue", cex=0.35)

# ---------------------------------------------------------
# ★ 凡例
# ---------------------------------------------------------
legend("topleft",
       legend=c("Female", "Male"),
       col=c("red", "blue"),
       pch=22,
       pt.bg="white",
       pt.cex=2)

# PDF 終了
dev.off()
