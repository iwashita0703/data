base_dir <- "/Users/kakigoori/Desktop/data/13"
out_dir <- "/Users/kakigoori/Documents/データサイエンス/class13_work/answers"
plot_dir <- file.path(out_dir, "plots")
table_dir <- file.path(out_dir, "tables")
screen_dir <- file.path(out_dir, "screenshots")

dir.create(plot_dir, recursive = TRUE, showWarnings = FALSE)
dir.create(table_dir, recursive = TRUE, showWarnings = FALSE)
dir.create(screen_dir, recursive = TRUE, showWarnings = FALSE)

read_data <- function(name) {
  read.table(file.path(base_dir, name), header = TRUE, sep = ",", check.names = TRUE, fileEncoding = "UTF-8-BOM")
}

round_df <- function(df, digits = 4) {
  data.frame(lapply(df, function(x) if (is.numeric(x)) round(x, digits) else x), check.names = FALSE)
}

fit_factanal <- function(df, data_cols, factors, scores = "regression", rotation = "none") {
  factanal(df[, data_cols], factors = factors, scores = scores, rotation = rotation)
}

make_screen <- function(path, lines, width = 1800, height = 1150) {
  png(path, width = width, height = height, res = 170)
  par(mar = c(1, 1, 1, 1), bg = "#F8F7F2")
  plot.new()
  text(0.02, 0.98, paste(lines, collapse = "\n"), adj = c(0, 1), family = "mono", cex = 0.7, col = "#1B1B1B")
  dev.off()
}

capture_head <- function(df, n = 6) {
  capture.output(print(head(df, n)))
}

capture_fact <- function(obj) {
  capture.output(print(obj))
}

write_factor_tables <- function(prefix, fit, ids = NULL) {
  loadings <- as.data.frame(unclass(fit$loadings))
  loadings$variable <- rownames(loadings)
  loadings <- loadings[, c("variable", setdiff(names(loadings), "variable"))]
  write.csv(round_df(loadings), file.path(table_dir, paste0(prefix, "_loadings.csv")), row.names = FALSE)
  uniq <- data.frame(variable = names(fit$uniquenesses), uniqueness = as.numeric(fit$uniquenesses))
  uniq$communality <- 1 - uniq$uniqueness
  write.csv(round_df(uniq), file.path(table_dir, paste0(prefix, "_uniqueness.csv")), row.names = FALSE)
  if (!is.null(fit$scores)) {
    scores <- as.data.frame(fit$scores)
    if (!is.null(ids)) scores <- cbind(ID = ids, scores)
    write.csv(round_df(scores), file.path(table_dir, paste0(prefix, "_scores.csv")), row.names = FALSE)
  }
}

save_biplot <- function(prefix, fit, ids, title) {
  plot_one <- function() {
    par(mar = c(4, 4, 3, 2))
    biplot(fit$scores, fit$loadings, xlabs = ids, main = title)
  }

  png(file.path(plot_dir, paste0(prefix, "_biplot.png")), width = 1400, height = 1000, res = 160)
  plot_one()
  dev.off()

  pdf(file.path(plot_dir, paste0(prefix, "_biplot.pdf")), width = 8.5, height = 6.2)
  plot_one()
  dev.off()
}

save_loading_bars <- function(prefix, fit, title) {
  loadings <- as.matrix(unclass(fit$loadings))
  for (i in seq_len(ncol(loadings))) {
    plot_one <- function() {
      par(mar = c(7, 4, 3, 2))
      ylim <- range(c(loadings[, i], 0))
      pad <- max(0.15, diff(ylim) * 0.15)
      barplot(
        loadings[, i],
        names.arg = rownames(loadings),
        las = 2,
        cex.names = 0.75,
        ylim = c(ylim[1] - pad, ylim[2] + pad),
        col = "#2A9D8F",
        main = paste0(title, " Factor", i, " loadings"),
        ylab = "loading"
      )
      abline(h = 0, col = "gray50")
    }

    png(file.path(plot_dir, paste0(prefix, "_factor", i, "_bar.png")), width = 1400, height = 900, res = 160)
    plot_one()
    dev.off()

    pdf(file.path(plot_dir, paste0(prefix, "_factor", i, "_bar.pdf")), width = 8, height = 5.2)
    plot_one()
    dev.off()
  }
}

make_assignment <- function(prefix, label, file, data_cols, factors, scores, rotations, ids_col = "ID", save_biplot_plot = TRUE) {
  df <- read_data(file)
  ids <- if (ids_col %in% names(df)) df[[ids_col]] else seq_len(nrow(df))

  first_fit <- NULL
  for (rotation in rotations) {
    fit <- fit_factanal(df, data_cols, factors = factors, scores = scores, rotation = rotation)
    rot_prefix <- paste0(prefix, "_", rotation)
    write_factor_tables(rot_prefix, fit, ids)
    if (save_biplot_plot && !is.null(fit$scores)) save_biplot(rot_prefix, fit, ids, paste0(label, " - ", rotation))
    save_loading_bars(rot_prefix, fit, paste0(label, " - ", rotation))
    if (is.null(first_fit)) first_fit <- fit
  }

  screen_lines <- c(
    paste0("> ", prefix, " <- read.table('./", file, "', header=T, sep=',')"),
    paste0("> head(", prefix, ")"),
    capture_head(df),
    "",
    paste0("> ", prefix, "_fact <- factanal(", prefix, "[,", if (is.numeric(data_cols)) paste0(min(data_cols), ":", max(data_cols)) else "-1", "], factors=", factors, ", scores='", scores, "', rotation='", rotations[1], "')"),
    paste0("> ", prefix, "_fact"),
    capture_fact(first_fit),
    "",
    paste0("> ", prefix, "_fact$loadings[,1:", factors, "]"),
    capture.output(print(first_fit$loadings[, seq_len(factors)])),
    "",
    paste0("> apply(", prefix, "_fact$loadings, 1, function(x){1-sum(x^2)})"),
    capture.output(print(apply(first_fit$loadings, 1, function(x){1 - sum(x^2)})))
  )
  make_screen(file.path(screen_dir, paste0(prefix, "_screen.png")), screen_lines)
}

seiseki <- read_data("seiseki_zenkikouki.csv")
make_assignment(
  prefix = "18-8A_seiseki",
  label = "18-8A seiseki_zenkikouki",
  file = "seiseki_zenkikouki.csv",
  data_cols = 3:12,
  factors = 3,
  scores = "Bartlett",
  rotations = c("varimax"),
  ids_col = "no",
  save_biplot_plot = FALSE
)

make_assignment(
  prefix = "18-10A_gokamoku",
  label = "18-10A seiseki_gokamoku",
  file = "seiseki_gokamoku.csv",
  data_cols = 2:6,
  factors = 2,
  scores = "regression",
  rotations = c("none", "promax", "varimax"),
  ids_col = "ID"
)

make_assignment(
  prefix = "18-11A_syusyoku",
  label = "18-11A syusyoku_jyuuyou",
  file = "syusyoku_jyuuyou.csv",
  data_cols = 2:8,
  factors = 3,
  scores = "regression",
  rotations = c("varimax"),
  ids_col = "ID"
)

make_assignment(
  prefix = "18-12A_jyuku",
  label = "18-12A gakusyuujyuku",
  file = "gakusyuujyuku.csv",
  data_cols = 2:6,
  factors = 2,
  scores = "regression",
  rotations = c("varimax"),
  ids_col = "ID"
)

summary <- data.frame(
  assignment = c("18-8A", "18-10A", "18-11A", "18-12A"),
  file = c("seiseki_zenkikouki.csv", "seiseki_gokamoku.csv", "syusyoku_jyuuyou.csv", "gakusyuujyuku.csv"),
  factors = c(3, 2, 3, 2),
  interpretation = c(
    "Factor1: reading/civics, Factor2: English, Factor3: science/math",
    "No rotation: Factor1 total ability, Factor2 humanities vs science; rotation separates humanities and science",
    "Factor1: growth/education, Factor2: stability/tradition, Factor3: young/immediate contribution",
    "Factor1: humanities, Factor2: science/math"
  )
)
write.csv(summary, file.path(table_dir, "assignment_summary.csv"), row.names = FALSE)

cat("Finished factor-analysis outputs:", out_dir, "\n")
