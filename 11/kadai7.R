pdf("Class11_rp17-1E_YY.pdf")
hyouka_ <- read.table("hyouka.csv", header = TRUE, sep = ",")
par(mfrow=c(2,2))

# 1枚目：主成分負荷量
plot(hyouka_pca$loadings[,1:2],
     xlim=c(-0.5,0.5),
     ylim=c(-1,1),
     main="Loadings")

# 2枚目：主成分得点
plot(hyouka_pca$scores[,1:2],
     main="Scores")

# 3枚目：部署番号付き主成分得点
plot(hyouka_pca$scores[,1:2],
     type="n",
     main="Scores(Label)")
text(hyouka_pca$scores[,1:2],
     labels=1:30)

dev.off()