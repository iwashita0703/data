setwd("/Users/kakigoori/Desktop/data/13")

dir.create("./answers/plots_pdf", recursive=TRUE, showWarnings=FALSE)

syusyoku <- read.table("./syusyoku_jyuuyou.csv", header=T, sep=",")

syusyoku

head(syusyoku)

syusyoku_fact <- factanal(syusyoku[,-1], factors=3, scores="regression", rotation="varimax")

str(syusyoku_fact)

syusyoku_fact

syusyoku_fact$loadings[,1:3]

apply(syusyoku_fact$loadings, 1, function(x){1-sum(x^2)})

syusyoku_fact$scores

pdf("./answers/plots_pdf/18-11A_syusyoku_biplot.pdf", width=8.5, height=6.2)
biplot(syusyoku_fact$scores, syusyoku_fact$loadings, xlabs=syusyoku[,1])
dev.off()

pdf("./answers/plots_pdf/18-11A_syusyoku_factor1_bar.pdf", width=8, height=5.2)
barplot(syusyoku_fact$loadings[,1], cex.names=0.8, las=2, ylim=c(-0.5,1.1))
abline(h=0, col="gray50")
dev.off()

pdf("./answers/plots_pdf/18-11A_syusyoku_factor2_bar.pdf", width=8, height=5.2)
barplot(syusyoku_fact$loadings[,2], cex.names=0.8, las=2, ylim=c(-0.5,1.1))
abline(h=0, col="gray50")
dev.off()

pdf("./answers/plots_pdf/18-11A_syusyoku_factor3_bar.pdf", width=8, height=5.2)
barplot(syusyoku_fact$loadings[,3], cex.names=0.8, las=2, ylim=c(-0.5,1.1))
abline(h=0, col="gray50")
dev.off()

