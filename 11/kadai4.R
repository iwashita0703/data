library(MASS)

Tochi <- read.table("Tochi_kakaku.csv", header = TRUE, sep = ",")
Tochi$City <- factor(Tochi$City)

Tochi_ans <- lda(Tochi[,1:4], Tochi[,5])
Tochi_ans2 <- predict(Tochi_ans)

# LD1 を反転して City_A が負側へ来るようにする
LD1 <- -Tochi_ans2$x[,1]
LD2 <-  Tochi_ans2$x[,2]

pdf("Class11_rp16-30D_YY.pdf", width = 12, height = 6)

plot(LD1, LD2,
     pch = as.integer(Tochi$City),  # City_A=1, City_B=2, City_C=3
     col = "black",
     cex = 0.9,
     xlab = "LD1",
     ylab = "LD2",
     xlim = c(-15, 10),   # LD1 の範囲
     ylim = c(-5, 5))     # LD2 の範囲

legend("topright",
       legend = levels(Tochi$City),
       pch = c(1,2,3))

dev.off()
