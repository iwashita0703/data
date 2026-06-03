poster <- read.csv("Poster.csv", fileEncoding="UTF-8-BOM")

pdf("Class10_rp16-29A_1_Noudo_Nendo.pdf", width=7, height=7)

plot(poster$Noudo, poster$Nendo,
     col=ifelse(poster$Hinshitsu=="ryou","blue","red"),
     pch=ifelse(poster$Hinshitsu=="ryou",16,17),
     xlab="Noudo", ylab="Nendo",
     main="Noudo vs Nendo")
legend("topleft", legend=c("Good","Bad"), col=c("blue","red"), pch=c(16,17))

dev.off()
