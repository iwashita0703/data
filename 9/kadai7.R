rm(list = ls())

library(ggplot2)

df <- read.csv("gakusyuu.csv", header = TRUE, fileEncoding = "UTF-8")

df$就職率 <- as.numeric(df$就職率)
df$短縮名 <- factor(df$短縮名, levels = df$短縮名)

png("Class12_rp12-4A_YY.png", width = 1200, height = 800)

print(
  ggplot(df, aes(x = 短縮名, y = 就職率)) +
    geom_col(fill = "skyblue") +
    theme(
      text = element_text(family = "Hiragino Sans"),   # ← Mac ではこれが最強
      axis.text.x = element_text(angle = 90, hjust = 1, size = 10)
    ) +
    labs(
      title = "学科別の就職率（短縮名）",
      x = "学科（短縮名）",
      y = "就職率（％）"
    )
)

dev.off()
