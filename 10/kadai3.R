library(MASS)

poster <- read.csv("Poster.csv", fileEncoding="UTF-8-BOM")

Hin <- poster$Hinshitsu
Nendo <- poster$Nendo
Netsu <- poster$Netsu

ans <- lda(Hin ~ Nendo + Netsu)
ans2 <- predict(ans)

coef <- ans$scaling
const <- apply(ans$means %*% coef, 2, mean)

cat("Discriminant Function:\n")
cat("z = ",
    round(coef[1], 4), "* Nendo + ",
    round(coef[2], 4), "* Netsu + ",
    round(const, 4), "\n")
cat("Rule: z > 0 → Good,  z < 0 → Bad\n\n")

cat("Predicted Classes:\n")
print(ans2$class)

cat("\nConfusion Matrix:\n")
tbl <- table(True = Hin, Predicted = ans2$class)
print(tbl)

wrong <- sum(Hin != ans2$class)
rate <- wrong / nrow(poster)

cat("\nMisclassification Rate:\n")
cat(wrong, "/", nrow(poster), " = ", rate, "\n")
