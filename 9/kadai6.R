# フルーツ名とデータ
fruits_name <- c("Banana", "Berry", "Apple", "Kiwi", "Cherry",
                 "Watermelon", "Plum", "Pear", "Pineapple")

fruits_data <- c(35, 10, 25, 7, 3, 12, 18, 11, 19)

# データフレーム化
fruits <- data.frame(fruits_name, fruits_data)

# 大きい順に並べ替え
jyuni <- order(fruits$fruits_data, decreasing = TRUE)

# PDF 出力開始（YY は自分の番号に変更）
pdf("Class12_rp12-3C_YY.pdf")

# ---- 外側のパイチャート（資料の最終形） ----
pie(
  fruits[jyuni, 2],
  labels = fruits[jyuni, 1],
  clockwise = TRUE,
  col = rainbow(9),
  border = "white"
)

# ---- 内側の白い円（ドーナツ化） ----
par(new = TRUE)
pie(
  1,
  radius = 0.5,
  col = "white",
  border = "white",
  labels = ""
)

# PDF 出力終了
dev.off()
