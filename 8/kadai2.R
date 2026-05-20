conveni <- read.table("conveni.csv", header=TRUE, sep=",")
hage <- read.table("hage.csv", header=TRUE, sep=",")
test_data <- read.table("test.csv", header=TRUE, sep=",")
# モデル作成：売上 ~ 広告費 + 営業マン [11]
result_hage <- lm(uriage_senman ~ koukokuhi_hyakumann + eigyou_nin, data=hage)

# 店舗Gの予測 (広告費13, 営業マン14) [12]
store_G <- data.frame(koukokuhi_hyakumann=13, eigyou_nin=14)
pred_G <- predict(result_hage, store_G)
cat("課題 15-9A: 店舗Gの売上予測値 =", pred_G, "千万円\n")