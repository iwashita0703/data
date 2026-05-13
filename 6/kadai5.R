Body <- read.table("SampleData03_forR2.csv",
                   header = TRUE, sep = ",")

pdf("11-5A_All.pdf")

plot(Body[,8] ~ Body[,7])
result <- lm(Body[,8] ~ Body[,7])
abline(result)

text(
  x = min(Body[,7]) + 5,
  y = max(Body[,8]) - 20,
  labels = sprintf("y = %.2f x + %.2f",
                   result$coefficients[2],
                   result$coefficients[1]),
  adj = c(0,1)
)

dev.off()