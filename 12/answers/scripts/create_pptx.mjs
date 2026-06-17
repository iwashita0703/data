import fs from "node:fs/promises";
import path from "node:path";
import { Presentation, PresentationFile } from "/Users/kakigoori/.cache/codex-runtimes/codex-primary-runtime/dependencies/node/node_modules/@oai/artifact-tool/dist/artifact_tool.mjs";

const baseDir = "/Users/kakigoori/Desktop/data/12";
const outDir = path.join(baseDir, "answers");
const plotDir = path.join(outDir, "plots");
const tableDir = path.join(outDir, "tables");
const qaDir = path.join(outDir, "pptx_qa");

await fs.mkdir(qaDir, { recursive: true });

function parseCsv(text) {
  const lines = text.replace(/^\uFEFF/, "").trim().split(/\r?\n/);
  return lines.map((line) => line.split(",").map((v) => v.replace(/^"|"$/g, "")));
}

async function readCsv(filePath) {
  return parseCsv(await fs.readFile(filePath, "utf8"));
}

async function readPng(filePath) {
  return new Uint8Array(await fs.readFile(filePath));
}

async function writeBlob(filePath, blob) {
  await fs.writeFile(filePath, new Uint8Array(await blob.arrayBuffer()));
}

function addText(slide, text, position, style = {}) {
  const box = slide.shapes.add({
    geometry: "textbox",
    position,
    fill: "none",
    line: { style: "solid", fill: "none", width: 0 },
  });
  box.text = text;
  box.text.style = {
    fontSize: 20,
    color: "#15202B",
    fontFace: "Aptos",
    ...style,
  };
  return box;
}

function addTitle(slide, title, subtitle) {
  addText(slide, title, { left: 64, top: 42, width: 890, height: 56 }, {
    fontSize: 34,
    bold: true,
    color: "#143642",
    fontFace: "Aptos Display",
  });
  if (subtitle) {
    addText(slide, subtitle, { left: 66, top: 92, width: 1000, height: 28 }, {
      fontSize: 15,
      color: "#56636D",
    });
  }
}

function addFooter(slide, assignment) {
  addText(slide, `${assignment} | R prcomp(scale.=TRUE) による主成分分析`, {
    left: 64,
    top: 682,
    width: 760,
    height: 22,
  }, { fontSize: 11, color: "#7A858C" });
}

function addCallout(slide, label, value, left, top, accent = "#E76F51") {
  slide.shapes.add({
    geometry: "roundRect",
    position: { left, top, width: 248, height: 112 },
    fill: "#FFFFFF",
    line: { style: "solid", fill: "#DDE3E7", width: 1 },
    borderRadius: 8,
  });
  slide.shapes.add({
    geometry: "rect",
    position: { left, top, width: 8, height: 112 },
    fill: accent,
    line: { style: "solid", fill: accent, width: 0 },
  });
  addText(slide, label, { left: left + 24, top: top + 18, width: 198, height: 24 }, {
    fontSize: 14,
    bold: true,
    color: "#56636D",
  });
  addText(slide, value, { left: left + 24, top: top + 45, width: 198, height: 46 }, {
    fontSize: 28,
    bold: true,
    color: "#143642",
  });
}

function addBullets(slide, lines, position) {
  const text = lines.map((line) => `・${line}`).join("\n");
  addText(slide, text, position, {
    fontSize: 18,
    color: "#1C2A32",
    breakLine: false,
  });
}

async function addImage(slide, imagePath, position, alt) {
  slide.images.add({
    blob: await readPng(imagePath),
    contentType: "image/png",
    alt,
    fit: "contain",
    position,
  });
}

function addDataTable(slide, rows, position, fontSize = 13) {
  const table = slide.tables.add({
    rows: rows.length,
    columns: rows[0].length,
    left: position.left,
    top: position.top,
    width: position.width,
    height: position.height,
    values: rows,
  });
  table.styleOptions = { headerRow: true, bandedRows: true };
  table.borders.assign({ style: "solid", fill: "#D9E0E5", width: 1 });
  for (let c = 0; c < rows[0].length; c++) {
    table.getCell(0, c).fill = "#143642";
    table.getCell(0, c).text.style = { fontSize, bold: true, color: "#FFFFFF" };
  }
  for (let r = 1; r < rows.length; r++) {
    for (let c = 0; c < rows[0].length; c++) {
      table.getCell(r, c).text.style = { fontSize, color: "#1C2A32" };
    }
  }
  return table;
}

function formatPercent(value) {
  return `${(Number(value) * 100).toFixed(1)}%`;
}

function roundCell(value) {
  const n = Number(value);
  return Number.isFinite(n) ? n.toFixed(2) : value;
}

async function makeDeck(config) {
  const p = Presentation.create({ slideSize: { width: 1280, height: 720 } });

  const rawRows = await readCsv(path.join(baseDir, config.dataFile));
  const scores = await readCsv(path.join(tableDir, config.scoresFile));
  const loadings = await readCsv(path.join(tableDir, config.loadingsFile));
  const importance = await readCsv(path.join(tableDir, config.importanceFile));
  const impRows = importance.slice(1);
  const pc1 = impRows[0];
  const pc2 = impRows[1];
  const cumulative2 = formatPercent(pc2[3]);

  {
    const slide = p.slides.add();
    slide.background.fill = "#F4F6F7";
    addTitle(slide, config.title, config.subtitle);
    addCallout(slide, "PC1寄与率", formatPercent(pc1[2]), 64, 170, "#2A9D8F");
    addCallout(slide, "PC2寄与率", formatPercent(pc2[2]), 334, 170, "#E9C46A");
    addCallout(slide, "累積寄与率", cumulative2, 604, 170, "#E76F51");
    addBullets(slide, config.summaryBullets, { left: 70, top: 332, width: 520, height: 210 });
    await addImage(slide, path.join(plotDir, config.screePlot), { left: 675, top: 320, width: 500, height: 300 }, "寄与率の棒グラフ");
    addFooter(slide, config.assignment);
  }

  {
    const slide = p.slides.add();
    slide.background.fill = "#FFFFFF";
    addTitle(slide, "元データの確認", "各対象の得点・人数を比較し、PCA解釈の前提を確認する");
    const displayRows = rawRows.map((row, idx) => idx === 0 ? row : row.map(roundCell));
    if (config.fullWidthDataTable) {
      addDataTable(slide, displayRows, { left: 58, top: 132, width: 1110, height: 230 }, config.tableFontSize ?? 8);
      await addImage(slide, path.join(plotDir, config.barPlot), { left: 260, top: 368, width: 760, height: 210 }, "元データの棒グラフ");
      addBullets(slide, config.dataBullets, { left: 72, top: 602, width: 1080, height: 52 });
    } else {
      addDataTable(slide, displayRows, { left: 58, top: 142, width: config.tableWidth ?? 590, height: config.tableHeight ?? 340 }, config.tableFontSize ?? 13);
      await addImage(slide, path.join(plotDir, config.barPlot), { left: 660, top: 142, width: 560, height: 380 }, "元データの棒グラフ");
      addBullets(slide, config.dataBullets, { left: 72, top: 535, width: 1080, height: 90 });
    }
    addFooter(slide, config.assignment);
  }

  {
    const slide = p.slides.add();
    slide.background.fill = "#F4F6F7";
    addTitle(slide, "主成分得点と負荷量", "第1主成分と第2主成分の位置関係から特徴を読む");
    await addImage(slide, path.join(plotDir, config.scoresPlot), { left: 58, top: 134, width: 560, height: 430 }, "主成分得点の散布図");
    await addImage(slide, path.join(plotDir, config.loadingsPlot), { left: 660, top: 134, width: 520, height: 430 }, "主成分負荷量の散布図");
    addBullets(slide, config.pcaBullets, { left: 78, top: 585, width: 1040, height: 70 });
    addFooter(slide, config.assignment);
  }

  {
    const slide = p.slides.add();
    slide.background.fill = "#FFFFFF";
    addTitle(slide, "解釈と提案", "分析担当としての結論");
    addBullets(slide, config.conclusionBullets, { left: 76, top: 150, width: 560, height: 310 });

    const scoreRows = [scores[0].slice(0, 3), ...scores.slice(1).map((row) => row.slice(0, 3).map(roundCell))];
    addDataTable(slide, scoreRows, { left: 700, top: 130, width: 420, height: 260 }, 13);

    const loadingRows = [loadings[0].slice(0, 3), ...loadings.slice(1).map((row) => row.slice(0, 3).map(roundCell))];
    addDataTable(slide, loadingRows, { left: 700, top: 428, width: 420, height: config.loadingHeight ?? 190 }, config.loadingFontSize ?? 12);
    addFooter(slide, config.assignment);
  }

  const safeName = config.output;
  for (const [index, slide] of p.slides.items.entries()) {
    const stem = `${safeName.replace(".pptx", "")}_slide-${String(index + 1).padStart(2, "0")}`;
    await writeBlob(path.join(qaDir, `${stem}.png`), await p.export({ slide, format: "png", scale: 1 }));
    await fs.writeFile(path.join(qaDir, `${stem}.layout.json`), await (await slide.export({ format: "layout" })).text());
  }
  await writeBlob(path.join(qaDir, `${safeName.replace(".pptx", "")}_montage.webp`), await p.export({ format: "webp", montage: true, scale: 1 }));
  const pptx = await PresentationFile.exportPptx(p);
  await pptx.save(path.join(outDir, safeName));
}

const decks = [
  {
    assignment: "17-7A",
    title: "入社試験成績の分析",
    subtitle: "nyusya_shiken.csv: 5名の試験結果を主成分分析で評価",
    dataFile: "nyusya_shiken.csv",
    output: "Class12_rp17-7A_YY.pptx",
    scoresFile: "17-7A_nyusya_scores.csv",
    loadingsFile: "17-7A_nyusya_loadings.csv",
    importanceFile: "17-7A_nyusya_importance.csv",
    screePlot: "17-7A_nyusya_scree.png",
    barPlot: "17-7A_nyusya_bars.png",
    scoresPlot: "17-7A_nyusya_scores.png",
    loadingsPlot: "17-7A_nyusya_loadings.png",
    summaryBullets: [
      "PC1は全科目が正方向で、総合力を表す軸と解釈できる",
      "PC2は専門・論文が正、英語・面接が負で、強みの種類を分ける",
      "PC1+PC2で元データの95.1%を説明できる"
    ],
    dataBullets: [
      "受験者2は全体的に高得点で安定している。受験者5は全科目で低い。",
      "受験者1は専門と論文、受験者3・4は英語や面接に特徴がある。"
    ],
    pcaBullets: [
      "右側ほど総合評価が高い。上側ほど専門・論文型、下側ほど英語・面接型の傾向が強い。"
    ],
    conclusionBullets: [
      "採用優先順位は、総合力を重視すると 2 → 4 → 3 → 1 → 5 と考えられる。",
      "受験者2は全体的に高く、上位5名を選ぶ際の中心候補になる。",
      "受験者1は専門・論文型、受験者4と3は英語・面接型として配属先を分けて考える。",
      "受験者5は上位5名に入れる場合も、入社後の基礎力補強が必要である。"
    ],
  },
  {
    assignment: "17-7B",
    title: "同価格帯7車種の評価分析",
    subtitle: "kuruma.csv: 動力性能・居住性・デザイン評価人数をPCAで整理",
    dataFile: "kuruma.csv",
    output: "Class12_rp17-7B_YY.pptx",
    scoresFile: "17-7B_kuruma_scores.csv",
    loadingsFile: "17-7B_kuruma_loadings.csv",
    importanceFile: "17-7B_kuruma_importance.csv",
    screePlot: "17-7B_kuruma_scree.png",
    barPlot: "17-7B_kuruma_bars.png",
    scoresPlot: "17-7B_kuruma_scores.png",
    loadingsPlot: "17-7B_kuruma_loadings.png",
    summaryBullets: [
      "PC1は動力性能・居住性が大きく、総合性能を表す軸と解釈できる",
      "PC2はデザイン評価の違いを強く表す",
      "PC1+PC2で元データの99.2%を説明できる"
    ],
    dataBullets: [
      "Fは3項目すべてが高く、総合評価で最も強い。",
      "BとDはデザイン評価が相対的に高いが、性能・居住性は低め。"
    ],
    pcaBullets: [
      "左側ほど総合性能が高い。下側ほどデザイン評価寄り、上側ほど性能・居住性寄りに読める。"
    ],
    conclusionBullets: [
      "最有力はF。全項目で高く、広告でも主力として扱いやすい。",
      "EとCは動力性能・居住性を押し出す訴求に向いている。",
      "BとDはデザインを評価する層に訴求できるが、総合評価では弱い。",
      "GとAは中位で、突出点を補う追加調査が必要。"
    ],
  },
  {
    assignment: "17-7C",
    title: "車イメージ調査の販売促進分析",
    subtitle: "image_tyousa.csv: A-J車種の印象語10項目をPCAで整理",
    dataFile: "image_tyousa.csv",
    output: "Class12_rp17-7C_YY.pptx",
    scoresFile: "17-7C_image_scores.csv",
    loadingsFile: "17-7C_image_loadings.csv",
    importanceFile: "17-7C_image_importance.csv",
    screePlot: "17-7C_image_scree.png",
    barPlot: "17-7C_image_bars.png",
    scoresPlot: "17-7C_image_scores.png",
    loadingsPlot: "17-7C_image_loadings.png",
    fullWidthDataTable: true,
    tableFontSize: 7,
    loadingHeight: 220,
    loadingFontSize: 8,
    summaryBullets: [
      "PC1は「好き・欲しい」と「ダサい・嫌い」が反対方向に出る好意度軸",
      "PC2は「プロ的・格好良い」と「一般的・初心者的」の違いを表す軸",
      "PC1+PC2で元データの80.3%を説明できる"
    ],
    dataBullets: [
      "Aは一般的・ミーハー・好き・欲しいが高く、量販向きの印象が強い。",
      "Cはプロ的が高い一方、好き・欲しいは弱い。F/Gは初心者的・ダサい側が目立つ。"
    ],
    pcaBullets: [
      "左側ほど好意・購買意向が強く、右側ほど否定的印象が強い。下側はプロ・格好良い寄りに読める。"
    ],
    conclusionBullets: [
      "販売促進の中心候補はA。認知されやすく、好意度と購買意向が高い。",
      "EとHは格好良さや欲しい印象を補助訴求として使える。",
      "Cはプロ的印象を活かした専門性・こだわり訴求が向くが、欲しい印象の弱さを補う必要がある。",
      "F/G/Dは初心者的・ダサい・嫌い側の印象が強く、改善またはターゲット再設定が必要。"
    ],
  },
];

for (const deck of decks) {
  await makeDeck(deck);
}

await fs.writeFile(path.join(qaDir, "visual-qa.txt"), [
  "Visual QA",
  "Generated three editable PPTX decks from R-produced PCA plots and CSV tables.",
  "Checked by rendering every slide to PNG plus montage via @oai/artifact-tool.",
  "No full-slide bitmap slides; plots are embedded as figures, with editable text and tables.",
  "Final files are in /Users/kakigoori/Desktop/data/12/answers.",
].join("\n"));

console.log("Created PPTX files in", outDir);
