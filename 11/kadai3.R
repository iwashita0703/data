library(MASS)

Tochi <- read.table("Tochi_kakaku.csv", header = TRUE, sep = ",")
Tochi$City <- factor(Tochi$City)

Tochi_ans <- lda(Tochi[,1:4], Tochi[,5])
Tochi_ans2 <- predict(Tochi_ans)

# LD1 を反転して City_A が負側へ来るようにする
LD1 <- -Tochi_ans2$x[,1]
LD2 <-  Tochi_ans2$x[,2]

pdf("Class11_rp16-30C_YY.pdf", width = 12, height = 6)

plot(LD1, LD2,
     type = "n",
     xlab = "LD1",
     ylab = "LD2",
     xlim = c(-15, 10),
     ylim = c(-5, 5))

text(LD1, LD2,
     labels = Tochi$City,
     cex = 0.7)

legend("topright",
       legend = levels(Tochi$City),
       pch = 15)

dev.off()
