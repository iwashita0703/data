setwd("/Users/kakigoori/Desktop/data/13")

dir.create("./answers/plots_pdf", recursive=TRUE, showWarnings=FALSE)

gokamoku <- read.table("./seiseki_gokamoku.csv", header=T, sep=",")

gokamoku

head(gokamoku)

gokamoku_fact <- factanal(gokamoku[,-1], factors=2, scores="regression", rotation="none")

str(gokamoku_fact)

gokamoku_fact

gokamoku_fact$loadings[1,]

gokamoku_fact$loadings[1,]^2

1 - sum(gokamoku_fact$loadings[1,]^2)

apply(gokamoku_fact$loadings, 1, function(x){1-sum(x^2)})

gokamoku_fact$scores

pdf("./answers/plots_pdf/18-10A_gokamoku_none_biplot.pdf", width=8.5, height=6.2)
biplot(gokamoku_fact$scores, gokamoku_fact$loadings, xlabs=gokamoku[,1])
dev.off()

pdf("./answers/plots_pdf/18-10A_gokamoku_none_factor1_bar.pdf", width=8, height=5.2)
barplot(gokamoku_fact$loadings[,1], cex.names=0.8, las=2, ylim=c(0,1))
abline(h=0, col="gray50")
dev.off()

pdf("./answers/plots_pdf/18-10A_gokamoku_none_factor2_bar.pdf", width=8, height=5.2)
barplot(gokamoku_fact$loadings[,2], cex.names=0.8, las=2, ylim=c(-0.8,0.8))
abline(h=0, col="gray50")
dev.off()

gokamoku_fact <- factanal(gokamoku[,-1], factors=2, scores="regression", rotation="promax")

pdf("./answers/plots_pdf/18-10A_gokamoku_promax_biplot.pdf", width=8.5, height=6.2)
biplot(gokamoku_fact$scores, gokamoku_fact$loadings, xlabs=gokamoku[,1])
dev.off()

pdf("./answers/plots_pdf/18-10A_gokamoku_promax_factor1_bar.pdf", width=8, height=5.2)
barplot(gokamoku_fact$loadings[,1], cex.names=0.8, las=2, ylim=c(-0.3,1.2))
abline(h=0, col="gray50")
dev.off()

pdf("./answers/plots_pdf/18-10A_gokamoku_promax_factor2_bar.pdf", width=8, height=5.2)
barplot(gokamoku_fact$loadings[,2], cex.names=0.8, las=2, ylim=c(-0.3,1.2))
abline(h=0, col="gray50")
dev.off()

gokamoku_fact <- factanal(gokamoku[,-1], factors=2, scores="regression", rotation="varimax")

pdf("./answers/plots_pdf/18-10A_gokamoku_varimax_biplot.pdf", width=8.5, height=6.2)
biplot(gokamoku_fact$scores, gokamoku_fact$loadings, xlabs=gokamoku[,1])
dev.off()

pdf("./answers/plots_pdf/18-10A_gokamoku_varimax_factor1_bar.pdf", width=8, height=5.2)
barplot(gokamoku_fact$loadings[,1], cex.names=0.8, las=2, ylim=c(-0.3,1.2))
abline(h=0, col="gray50")
dev.off()

pdf("./answers/plots_pdf/18-10A_gokamoku_varimax_factor2_bar.pdf", width=8, height=5.2)
barplot(gokamoku_fact$loadings[,2], cex.names=0.8, las=2, ylim=c(-0.3,1.2))
abline(h=0, col="gray50")
dev.off()

