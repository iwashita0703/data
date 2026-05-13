# ---------------------------------------------------------
# 14-2A：男女別にピアソン相関係数を求め、図に書き込む（提出用）
# ---------------------------------------------------------

# CSV 読み込み
Body <- read.table("SampleData03_forR2.csv", header=TRUE, sep=",")

pdf("Class7_rp14-2A_YY.pdf", width=7, height=7)

# 性別で分割
Body_F <- subset(Body, Sex == "F")
Body_M <- subset(Body, Sex == "M")

# ---------------------------------------------------------
# ★ 女性データの散布図（白抜き四角）
# ---------------------------------------------------------
plot(Body_F[,7], Body_F[,8],
     xlab="Weight", ylab="Height",
     xlim=c(30,100), ylim=c(1400,2000),
     pch=22, col="red", bg="white", cex=1.8,
     main="Correlation by Sex (Pearson)")

# 女性のピアソン相関係数
Body_F_cor <- cor.test(Body_F[,7], Body_F[,8], method="pearson")
r_F <- Body_F_cor$estimate

# 女性の相関係数を左上より少し下に表示
text(32, 1940,
     sprintf("Female: r = %.3f", r_F),
     col="red", cex=0.9, adj=c(0,1))

# ---------------------------------------------------------
# ★ 男性データを重ね描き（白抜き四角）
# ---------------------------------------------------------
par(new=TRUE)

plot(Body_M[,7], Body_M[,8],
     xlab="", ylab="",
     xlim=c(30,100), ylim=c(1400,2000),
     pch=22, col="blue", bg="white", cex=1.8)

# 男性のピアソン相関係数
Body_M_cor <- cor.test(Body_M[,7], Body_M[,8], method="pearson")
r_M <- Body_M_cor$estimate

# 男性の相関係数をさらに下に表示（重ならない位置）
text(32, 1920,
     sprintf("Male:   r = %.3f", r_M),
     col="blue", cex=0.9, adj=c(0,1))

# ---------------------------------------------------------
# ★ 凡例
# ---------------------------------------------------------
legend("topleft",
       legend=c("Female", "Male"),
       col=c("red", "blue"),
       pch=22,
       pt.bg="white",
       pt.cex=1.8)
       dev.off()
