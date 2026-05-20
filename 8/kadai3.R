conveni <- read.table("conveni.csv", header=TRUE, sep=",")
hage <- read.table("hage.csv", header=TRUE, sep=",")
test_data <- read.table("test.csv", header=TRUE, sep=",")
result_test <- lm(gyouseki ~ syuusyoku_shiken + gakkou_seiseki, data=test_data)
summary(result_test)

# 候補者のデータ作成
candidates <- data.frame(
  name = c("高専太郎", "日本花子"),
  syuusyoku_shiken = c(8, 4),
  gakkou_seiseki = c(4, 8)
)

# 予測実行
candidates$pred_gyouseki <- predict(result_test, candidates)
print("課題 15-9B: 採用候補者の業績予測")
print(candidates)