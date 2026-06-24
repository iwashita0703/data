setwd("/Users/kakigoori/Desktop/data/13")

dir.create("./answers/plots_pdf", recursive=TRUE, showWarnings=FALSE)

jyuku <- read.table("./gakusyuujyuku.csv", header=T, sep=",")

jyuku

head(jyuku)

jyuku_fact <- factanal(jyuku[,-1], factors=2, scores="regression", rotation="varimax")

str(jyuku_fact)

jyuku_fact

jyuku_fact$loadings[,1:2]

apply(jyuku_fact$loadings, 1, function(x){1-sum(x^2)})

jyuku_fact$scores

pdf("./answers/plots_pdf/18-12A_jyuku_biplot.pdf", width=8.5, height=6.2)
biplot(jyuku_fact$scores, jyuku_fact$loadings, xlabs=jyuku[,1])
dev.off()

pdf("./answers/plots_pdf/18-12A_jyuku_factor1_bar.pdf", width=8, height=5.2)
barplot(jyuku_fact$loadings[,1], cex.names=0.8, las=2, ylim=c(-0.3,1.1))
abline(h=0, col="gray50")
dev.off()

pdf("./answers/plots_pdf/18-12A_jyuku_factor2_bar.pdf", width=8, height=5.2)
barplot(jyuku_fact$loadings[,2], cex.names=0.8, las=2, ylim=c(-0.3,1.1))
abline(h=0, col="gray50")
dev.off()
