Body <- read.csv("SampleData03_forR2.csv")

hist(Body[,7], probability = TRUE)
lines(density(Body[,7]), col = "blue", lwd = 2)