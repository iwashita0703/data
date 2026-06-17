seiseki <- read.table("seiseki.csv", header=T, sep=",")

seiseki

seiseki_eig <- eigen(cor(seiseki[,-1]))

seiseki_eig

seiseki_prn <- prcomp(seiseki[,-1], scale=TRUE)

seiseki_prn

seiseki_prn$sdev^2
