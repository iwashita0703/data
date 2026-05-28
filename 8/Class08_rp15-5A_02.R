# 重回帰分析の実行 [4]
conveni <- read.table("conveni.csv", header=TRUE, sep=",")
hage <- read.table("hage.csv", header=TRUE, sep=",")
test_data <- read.table("test.csv", header=TRUE, sep=",")
# Y(売上) ~ X1(人口) + X2(商店) + X3(弁当) + X4(お菓子)
result_conveni <- lm(uriage_hyakuman ~ jinkou_sennin + syouten_tenpo + bento_syurui + okashi_syurui, data=conveni)
summary(result_conveni) # 係数などの確認 [5, 10]

# 21番目の店舗の予測 (X1=30, X2=35, X3=25, X4=50)
new_store <- data.frame(jinkou_sennin=30, syouten_tenpo=35, bento_syurui=25, okashi_syurui=50)
pred_21 <- predict(result_conveni, new_store)
cat("課題 15-5A: 21番目の店舗の売上予測値 =", pred_21, "百万円\n")