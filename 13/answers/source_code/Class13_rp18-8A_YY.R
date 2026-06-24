setwd("/Users/kakigoori/Desktop/data/13")

dir.create("./answers/plots_pdf", recursive=TRUE, showWarnings=FALSE)

seiseki <- read.table("./seiseki_zenkikouki.csv", header=T, sep=",")

seiseki

head(seiseki, 5)

seiseki_fact <- factanal(seiseki[,3:12], factors=3)

seiseki_fact

names(seiseki_fact)

seiseki_fact <- factanal(seiseki[,3:12], factors=3, scores="Bartlett")

names(seiseki_fact)

head(seiseki_fact$scores, 5)

tail(seiseki_fact$scores, 5)

seiseki_fact$loadings[,1:3]

pdf("./answers/plots_pdf/18-8A_seiseki_factor1_bar.pdf", width=8, height=5.2)
barplot(seiseki_fact$loadings[,1], cex.names=0.8, las=2, ylim=c(-0.3,1))
abline(h=0, col="gray50")
dev.off()

pdf("./answers/plots_pdf/18-8A_seiseki_factor2_bar.pdf", width=8, height=5.2)
barplot(seiseki_fact$loadings[,2], cex.names=0.8, las=2, ylim=c(-0.3,1))
abline(h=0, col="gray50")
dev.off()

pdf("./answers/plots_pdf/18-8A_seiseki_factor3_bar.pdf", width=8, height=5.2)
barplot(seiseki_fact$loadings[,3], cex.names=0.8, las=2, ylim=c(-0.3,1))
abline(h=0, col="gray50")
dev.off()
