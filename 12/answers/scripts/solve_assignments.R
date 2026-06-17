base_dir <- "/Users/kakigoori/Desktop/data/12"
out_dir <- file.path(base_dir, "answers")
plot_dir <- file.path(out_dir, "plots")
table_dir <- file.path(out_dir, "tables")

dir.create(plot_dir, recursive = TRUE, showWarnings = FALSE)
dir.create(table_dir, recursive = TRUE, showWarnings = FALSE)

library(ggplot2)

theme_set(theme_minimal(base_size = 12))

read_data <- function(name) {
  read.csv(file.path(base_dir, name), check.names = FALSE, fileEncoding = "UTF-8-BOM")
}

pca_summary <- function(df, id_col) {
  x <- df[, setdiff(names(df), id_col), drop = FALSE]
  fit <- prcomp(x, scale. = TRUE)
  scores <- as.data.frame(fit$x)
  scores[[id_col]] <- df[[id_col]]
  scores <- scores[, c(id_col, setdiff(names(scores), id_col))]
  loadings <- as.data.frame(fit$rotation)
  loadings$variable <- rownames(loadings)
  loadings <- loadings[, c("variable", setdiff(names(loadings), "variable"))]
  eigen <- fit$sdev^2
  importance <- data.frame(
    PC = paste0("PC", seq_along(eigen)),
    eigenvalue = eigen,
    proportion = eigen / sum(eigen),
    cumulative = cumsum(eigen / sum(eigen))
  )
  list(fit = fit, x = x, scores = scores, loadings = loadings, importance = importance)
}

write_pca_tables <- function(prefix, pca) {
  write.csv(round_df(pca$scores, 4), file.path(table_dir, paste0(prefix, "_scores.csv")), row.names = FALSE)
  write.csv(round_df(pca$loadings, 4), file.path(table_dir, paste0(prefix, "_loadings.csv")), row.names = FALSE)
  write.csv(round_df(pca$importance, 4), file.path(table_dir, paste0(prefix, "_importance.csv")), row.names = FALSE)
}

round_df <- function(df, digits) {
  data.frame(lapply(df, function(col) if (is.numeric(col)) round(col, digits) else col), check.names = FALSE)
}

save_scores_plot <- function(prefix, pca, id_col, title, subtitle = NULL) {
  pct1 <- round(100 * pca$importance$proportion[1], 1)
  pct2 <- round(100 * pca$importance$proportion[2], 1)
  p <- ggplot(pca$scores, aes(PC1, PC2, label = .data[[id_col]])) +
    geom_hline(yintercept = 0, color = "grey72", linewidth = 0.4) +
    geom_vline(xintercept = 0, color = "grey72", linewidth = 0.4) +
    geom_point(size = 3.2, color = "#1F6F8B") +
    geom_text(vjust = -0.9, size = 4, color = "#1B1B1B") +
    coord_equal() +
    labs(
      title = title,
      subtitle = subtitle,
      x = paste0("PC1 (", pct1, "%)"),
      y = paste0("PC2 (", pct2, "%)")
    ) +
    theme(plot.title = element_text(face = "bold"), panel.grid.minor = element_blank())
  ggsave(file.path(plot_dir, paste0(prefix, "_scores.png")), p, width = 7.5, height = 5.2, dpi = 180)
}

save_loading_plot <- function(prefix, pca, title) {
  load <- pca$loadings
  pct1 <- round(100 * pca$importance$proportion[1], 1)
  pct2 <- round(100 * pca$importance$proportion[2], 1)
  p <- ggplot(load, aes(PC1, PC2, label = variable)) +
    geom_hline(yintercept = 0, color = "grey72", linewidth = 0.4) +
    geom_vline(xintercept = 0, color = "grey72", linewidth = 0.4) +
    geom_segment(aes(x = 0, y = 0, xend = PC1, yend = PC2), arrow = arrow(length = unit(0.18, "cm")), color = "#9B2226", linewidth = 0.8) +
    geom_text(vjust = -0.8, size = 4, color = "#5C1A1B") +
    coord_equal(xlim = c(-1, 1), ylim = c(-1, 1)) +
    labs(title = title, x = paste0("PC1 (", pct1, "%)"), y = paste0("PC2 (", pct2, "%)")) +
    theme(plot.title = element_text(face = "bold"), panel.grid.minor = element_blank())
  ggsave(file.path(plot_dir, paste0(prefix, "_loadings.png")), p, width = 6.8, height = 5.2, dpi = 180)
}

save_scree_plot <- function(prefix, pca, title) {
  p <- ggplot(pca$importance, aes(PC, proportion)) +
    geom_col(fill = "#2A9D8F", width = 0.62) +
    geom_text(aes(label = paste0(round(proportion * 100, 1), "%")), vjust = -0.35, size = 4) +
    scale_y_continuous(labels = function(x) paste0(round(x * 100), "%"), limits = c(0, max(pca$importance$proportion) * 1.18)) +
    labs(title = title, x = NULL, y = "Proportion") +
    theme(plot.title = element_text(face = "bold"), panel.grid.minor = element_blank())
  ggsave(file.path(plot_dir, paste0(prefix, "_scree.png")), p, width = 6.6, height = 4.4, dpi = 180)
}

save_bar_plot <- function(prefix, df, id_col, title) {
  long <- reshape(
    df,
    varying = setdiff(names(df), id_col),
    v.names = "score",
    timevar = "item",
    times = setdiff(names(df), id_col),
    idvar = id_col,
    direction = "long"
  )
  p <- ggplot(long, aes(.data[[id_col]], score, fill = item)) +
    geom_col(position = "dodge", width = 0.7) +
    labs(title = title, x = NULL, y = "Score / count", fill = NULL) +
    theme(plot.title = element_text(face = "bold"), legend.position = "bottom", panel.grid.minor = element_blank())
  ggsave(file.path(plot_dir, paste0(prefix, "_bars.png")), p, width = 8, height = 4.8, dpi = 180)
}

write_console_image <- function(path, lines) {
  png(path, width = 1600, height = 950, res = 160)
  par(mar = c(1, 1, 1, 1), bg = "#F7F7F4")
  plot.new()
  text(0.02, 0.98, paste(lines, collapse = "\n"), adj = c(0, 1), family = "mono", cex = 0.78, col = "#1B1B1B")
  dev.off()
}

seiseki <- read_data("seiseki.csv")
seiseki_pca <- pca_summary(seiseki, "ID")
write_pca_tables("17-6_seiseki", seiseki_pca)

pdf(file.path(out_dir, "Class12_rp17-6A_YY.pdf"), width = 8, height = 6)
biplot(seiseki_pca$fit, xlabs = seiseki$ID, main = "seiseki.csv PCA biplot")
dev.off()

tokuten <- t(t(seiseki_pca$fit$x) / (seiseki_pca$fit$sdev * sqrt(nrow(seiseki_pca$fit$x))))
tokuten_df <- as.data.frame(tokuten)
tokuten_df$ID <- seiseki$ID
write.csv(round_df(tokuten_df[, c("ID", "PC1", "PC2", "PC3", "PC4")], 4), file.path(table_dir, "17-6_tokuten.csv"), row.names = FALSE)

pdf(file.path(out_dir, "Class12_rp17-6C_YY.pdf"), width = 7, height = 7)
plot(tokuten[, 1], tokuten[, 2], asp = 1, xlab = "PC1", ylab = "PC2", main = "PC scores: PC1-PC2")
abline(h = 0, v = 0, col = "grey70")
text(tokuten[, 1], tokuten[, 2], labels = seiseki$ID, pos = 3)
dev.off()

console_lines <- c(
  "> seiseki <- read.csv('seiseki.csv')",
  "> seiseki_eig <- eigen(cor(seiseki[,-1]))",
  "> seiseki_eig$values",
  paste(capture.output(print(seiseki_pca$importance$eigenvalue)), collapse = "\n"),
  "> seiseki_eig$vectors",
  paste(capture.output(print(round(unname(eigen(cor(seiseki[,-1]))$vectors), 7))), collapse = "\n"),
  "> seiseki_prn <- prcomp(seiseki[,-1], scale=TRUE)",
  "> seiseki_prn$sdev^2",
  paste(capture.output(print(seiseki_pca$fit$sdev^2)), collapse = "\n"),
  "> seiseki_prn$rotation",
  paste(capture.output(print(round(seiseki_pca$fit$rotation, 7))), collapse = "\n"),
  "",
  "The eigenvalues from eigen(cor(...)) match prcomp(...)$sdev^2.",
  "Eigenvector signs may flip, but PCA interpretation is unchanged when the relative relationship is the same."
)
write_console_image(file.path(out_dir, "Class12_rp17-6B_YY.png"), console_lines)

nyusya <- read_data("nyusya_shiken.csv")
nyusya_pca <- pca_summary(nyusya, "ID")
write_pca_tables("17-7A_nyusya", nyusya_pca)
save_scores_plot("17-7A_nyusya", nyusya_pca, "ID", "Entrance exam: PCA scores", "PC1: overall ability / PC2: specialty-writing vs English-interview")
save_loading_plot("17-7A_nyusya", nyusya_pca, "Entrance exam: loadings")
save_scree_plot("17-7A_nyusya", nyusya_pca, "Entrance exam: explained variance")
save_bar_plot("17-7A_nyusya", nyusya, "ID", "Entrance exam: raw data")

kuruma <- read_data("kuruma.csv")
kuruma_pca <- pca_summary(kuruma, "syasyu")
write_pca_tables("17-7B_kuruma", kuruma_pca)
save_scores_plot("17-7B_kuruma", kuruma_pca, "syasyu", "Car evaluation: PCA scores", "PC1: total evaluation / PC2: design vs performance-comfort")
save_loading_plot("17-7B_kuruma", kuruma_pca, "Car evaluation: loadings")
save_scree_plot("17-7B_kuruma", kuruma_pca, "Car evaluation: explained variance")
save_bar_plot("17-7B_kuruma", kuruma, "syasyu", "Car evaluation: raw data")

image_tyousa <- read_data("image_tyousa.csv")
image_pca <- pca_summary(image_tyousa, "kuruma")
write_pca_tables("17-7C_image", image_pca)
save_scores_plot("17-7C_image", image_pca, "kuruma", "Car image survey: PCA scores", "PC1: favor-purchase intent / PC2: popular-casual vs professional-cool")
save_loading_plot("17-7C_image", image_pca, "Car image survey: loadings")
save_scree_plot("17-7C_image", image_pca, "Car image survey: explained variance")
save_bar_plot("17-7C_image", image_tyousa, "kuruma", "Car image survey: raw data")

recommendations <- data.frame(
  assignment = c("17-7A", "17-7B", "17-7C"),
  main_finding = c(
    "受験者2が総合的に最も高く、受験者5は全科目が低く採用優先度は低い。受験者1は専門・論文が強く、受験者3と4は面接・英語側に特徴がある。",
    "Fが全項目で高く最有力。EとCは性能・居住性が強い。BとDはデザイン寄りだが総合力は中位から低め。",
    "Aは一般的・ミーハー・好き・欲しいが高く販促の中心候補。Cはプロ的だが好き・欲しいが弱く、F/Gは初心者・ダサい側の印象が強い。"
  )
)
write.csv(recommendations, file.path(table_dir, "recommendations.csv"), row.names = FALSE)

cat("Finished. Outputs are in:", out_dir, "\n")
