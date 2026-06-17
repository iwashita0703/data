# データ読み込み
hyouka <- read.table("hyouka.csv", header = TRUE, sep = ",")

# 6列だけ使用
hyouka6 <- hyouka[, 1:6]

# 列名を英語に統一
colnames(hyouka6) <- c("complaints", "privileges", "learning",
                       "raises", "critical", "advance")

# PCA（標準化あり）
hyouka_pca <- prcomp(hyouka6, scale = TRUE)

# --- PC1, PC2, PC3 を全部反転 ---
hyouka_pca$x[,1] <- -hyouka_pca$x[,1]   # PC1
hyouka_pca$x[,2] <- -hyouka_pca$x[,2]   # PC2
hyouka_pca$x[,3] <- -hyouka_pca$x[,3]   # PC3

hyouka_pca$rotation[,1] <- -hyouka_pca$rotation[,1]  # PC1 loadings
hyouka_pca$rotation[,2] <- -hyouka_pca$rotation[,2]  # PC2 loadings
hyouka_pca$rotation[,3] <- -hyouka_pca$rotation[,3]  # PC3 loadings

# --- PDF 出力 ---
pdf("Class17_rp17-1F_YY.pdf", width = 7, height = 7)

# Comp.1 × Comp.2
biplot(hyouka_pca,
       choices = c(1, 2),
       col = c("red", "blue"),
       cex = 0.8,
       main = "PCA Biplot: Comp.1 vs Comp.2 (Reversed)")

# Comp.2 × Comp.3
biplot(hyouka_pca,
       choices = c(2, 3),
       col = c("red", "blue"),
       cex = 0.8,
       main = "PCA Biplot: Comp.2 vs Comp.3 (Reversed)")

dev.off()
