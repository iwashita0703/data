hyouka_ <- read.table("hyouka.csv", header = TRUE, sep = ",")
hyouka  <- hyouka_[, -1]

hyouka_pca <- princomp(~ ., cor = TRUE, data = hyouka)

# ▼ loadings を普通の行列に変換（重要）
L <- unclass(hyouka_pca$loadings)

# ▼ Comp.1（横軸）だけ反転
L[,1] <- -L[,1]

pdf("Class11_rp17-1D_YY.pdf")
plot(L[,1:2], xlim=c(-0.5,0.5), ylim=c(-1,1))
dev.off()
