##################################################
# 9-17A
##################################################

# データ読み込み
Body <- read.table("SampleData03_forR2.csv",
                   header=TRUE,
                   sep=",")

# 女性データ抽出
Body_F <- subset(Body, Sex=="F")

# 男性データ抽出
Body_M <- subset(Body, Sex=="M")

# 散布図
plot(Body_F[,7], Body_F[,8],
     xlab="Weight",
     ylab="Height",
     col="red",
     xlim=c(30,100),
     ylim=c(1400,2000),
     pch=21)

# 重ね描き
par(new=TRUE)

plot(Body_M[,7], Body_M[,8],
     xlab="Weight",
     ylab="Height",
     col="blue",
     xlim=c(30,100),
     ylim=c(1400,2000),
     pch=21)