rm(list = ls())

library(ggplot2)

df <- read.csv("gakusyuu.csv", header = TRUE, fileEncoding = "UTF-8")

df$就職率 <- as.numeric(df$就職率)
df <- df[!is.na(df$就職率), ]
df$短縮名 <- factor(df$短縮名, levels = df$短縮名)

png("Class12_rp12-4B_pie_YY.png", width = 1200, height = 800)

print(
  ggplot(df, aes(x = "", y = 就職率, fill = 短縮名)) +
    geom_col(width = 1, color = "white") +
    coord_polar(theta = "y") +
    theme_void() +
    theme(
      text = element_text(family = "Hiragino Sans"),  
      legend.title = element_text(size = 12),
      legend.text = element_text(size = 10)
    ) +
    labs(
      title = "学科別の就職率（円グラフ・短縮名）",
      fill = "学科（短縮名）"
    )
)

dev.off()
