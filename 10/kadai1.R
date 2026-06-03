library(MASS)

gouhi <- read.table("gouhi_line_hantei.csv", header=TRUE, sep=",")

hikki <- gouhi$hikki_shiken
mensetsu <- gouhi$mensetsu_shiken
gouhi_factor <- gouhi$hantei

ans <- lda(gouhi_factor ~ hikki + mensetsu)

ans2 <- predict(ans)
ans2
