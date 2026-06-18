# 第12回 主成分分析

第12回は主成分分析の課題フォルダです。授業資料、元データ、作成した提出物が入っています。

## 元データ

| ファイル | 内容 |
| --- | --- |
| `seiseki.csv` | 学生A-Lの国語、数学、英語、物理の成績 |
| `nyusya_shiken.csv` | 入社試験の教養、専門、英語、面接、論文の成績 |
| `kuruma.csv` | 車種A-Gの動力性能、居住性、デザイン評価 |
| `image_tyousa.csv` | 車種A-Jのイメージ調査結果 |
| `91edd4bb9d8a8443.pdf` | 第12回授業資料 |

## 課題と提出物

| 課題 | 内容 | 主な提出物 |
| --- | --- | --- |
| 17-6A | `seiseki.csv` のPCA biplot | `answers/Class12_rp17-6A_02.pdf` |
| 17-6B | `eigen()` と `prcomp()` の比較 | `answers/Class12_rp17-6B_02.png`, `answers/Class12_rp17-6B_YY.R` |
| 17-6C | 主成分得点の散布図 | `answers/Class12_rp17-6C_02.pdf` |
| 17-7A | 入社試験データの分析 | `answers/Class12_rp17-7A_02.pptx` |
| 17-7B | 車種評価データの分析 | `answers/Class12_rp17-7B_02.pptx` |
| 17-7C | 車イメージ調査データの分析 | `answers/Class12_rp17-7C_02.pptx` |

## 生成用スクリプト

| ファイル | 用途 |
| --- | --- |
| `answers/Class12_rp17-6B_YY.R` | 授業資料に沿った17-6B用Rコード |
| `answers/scripts/solve_assignments.R` | PCAの計算、図、表の生成 |
| `answers/scripts/create_pptx.mjs` | 17-7A-CのPowerPoint生成 |

## 実行例

```bash
cd /Users/kakigoori/Desktop/data/12
Rscript answers/Class12_rp17-6B_YY.R
```

```bash
cd /Users/kakigoori/Desktop/data/12
Rscript answers/scripts/solve_assignments.R
```

## メモ

- `YY` が入っているファイルは番号を入れる前の作業用ファイルです。
- `answers/plots/` と `answers/tables/` は、PowerPoint作成や確認のための中間成果物です。
- `answers/pdf_qa/` と `answers/pptx_qa/` は見た目確認用の画像です。
