# フルーツ名とデータ
fruits_name <- c("Banana", "Berry", "Apple", "Kiwi", "Cherry", 
                 "Watermelon", "Plum", "Pear", "Pineapple")

fruits_data <- c(35, 10, 25, 7, 3, 12, 18, 11, 19)

# データフレーム化
fruits <- data.frame(fruits_name, fruits_data)

# 大きい順の並び替え
jyuni <- order(fruits$fruits_data, decreasing = TRUE)

# PDF 出力開始（YY は自分の番号に変更）
pdf("Class12_rp12-3B_YY.pdf")

# パイチャート（資料の最終形）
pie(
  fruits[jyuni, 2],                 # 並べ替えたデータ
  labels = fruits[jyuni, 1],        # 並べ替えたラベル
  clockwise = TRUE,
  col = rainbow(9)                  # 色を重複なく
)

# PDF 出力終了
dev.off()
