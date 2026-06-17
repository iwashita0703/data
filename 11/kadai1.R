library(MASS)

Tochi <- read.table("Tochi_kakaku.csv", header = TRUE, sep = ",")

Tochi_ans <- lda(Tochi[,1:4], Tochi[,5])

Tochi_ans2 <- predict(Tochi_ans)

hyou <- table(Tochi[,5], Tochi_ans2$class)
hyou
