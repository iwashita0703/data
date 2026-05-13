# ---------------------------------------------------------
# 13-2A：性別ごとに色とマーカー形状を変えて重ね描きし、
#        凡例を付けた図を PDF にまとめる
# ---------------------------------------------------------

# CSV 読み込み
Body <- read.table("SampleData03_forR2.csv", header=TRUE, sep=",")

# 性別で分割
Body_F <- subset(Body, Sex == "F")
Body_M <- subset(Body, Sex == "M")

# PDF 出力開始（ファイル名は課題ルールに合わせて変更）
pdf("Class13_rp13-2A_YY.pdf", width=7, height=7)

# ---------------------------------------------------------
# ★ 性別ごとの散布図（重ね描き）
# ---------------------------------------------------------

# 女性（赤・丸）
plot(Body_F[,7], Body_F[,8],
     xlab="Weight", ylab="Height",
     col="red", pch=19, cex=1.3,
     xlim=c(30,100), ylim=c(1400,2000),
     main="Weight vs Height by Sex")

# par(new=TRUE) で重ね描き
par(new=TRUE)

# 男性（青・三角）
plot(Body_M[,7], Body_M[,8],
     xlab="", ylab="",
     col="blue", pch=17, cex=1.3,
     xlim=c(30,100), ylim=c(1400,2000))

# 凡例（左上）
legend("topleft",
       legend=c("Female", "Male"),
       col=c("red", "blue"),
       pch=c(19, 17),
       pt.cex=1.3)

# ---------------------------------------------------------
# PDF 終了
# ---------------------------------------------------------
dev.off()
