## zh

**加到 docs/reference.md 〈文件選項〉的表格**：把 `text` 那一列換成第一列，`10pt` `11pt` `12pt` 那一列換成第二列，其餘接在 `cjk`、`cjk-bold` 那一列後面。

| 選項 | 值 | 預設 | 作用 |
|---|---|---|---|
| `text` | `serif` `sans` `times` `palatino` | `serif` | 內文字型。`serif` 用 New Computer Modern（和數學同一套設計），`sans` 整份用 Lato，`times`、`palatino` 用 TeX Gyre Termes／Pagella（數學仍是 Computer Modern）。標題、標籤一律 Lato |
| `10pt` `11pt` `12pt` `13pt` `14pt`、`fontsize` | 例如 `fontsize=13pt` | `11pt` | 字級。`13pt`、`14pt` 或任意 `fontsize=` 由 scrextend 處理 |
| `par` | `skip` `indent` | `skip` | 段落。`indent` 每段（含標題後第一段）首行縮排 2 字，段落間不留空白，適合中文報告 |
| `secnum` | `arabic` `zh` | `arabic` | `zh` 章節編號改成「一、」「（一）」「1.」；書的章是「第一章」。定理、公式號碼仍用阿拉伯數字（定理 1.2），`\cref` 寫成「第一節」「一（一）」 |
| `kai` | | | 中文內文改用楷書：Kaiti TC（macOS）> 標楷體 BiauKai（macOS）> DFKai-SB（Windows）> AR PL UKai（Linux）> STKaiti > FandolKai（TeX Live 內附，只有簡體字，會出警告）。`text=sans` 也有效，標題仍是蘋方 |
| `cjk-serif`、`cjk-serif-bold` | 字型名稱 | 宋體 | 換掉襯線內文（`text=serif\|times\|palatino`）的中文字型和粗體，例如 `cjk-serif-bold=Noto Serif CJK TC SemiBold`。只給 `cjk-serif` 或楷書沒有粗體時，粗體用描粗 |

**〈ax new 的選項與專案內容〉表格**：`--text serif\|sans` 改成 `--text serif\|sans\|times\|palatino`。

**加到 docs/reference.md 〈寫內容〉，放在〈多語混排〉之後**：

### 中文報告

課堂報告、心得、計畫書常用的版面：

```latex
\documentclass[lang=zh, par=indent, secnum=zh, 13pt, kai, text=times]{akizumi-note}
\title{2013 年臺灣毒澱粉事件}
\author{林子祐}
\akizumisetup{course=食品安全, subtitle={食品安全風險溝通失敗之案例研究},
  info={學號=B10303083, 系級=資工四}}
\begin{document}
\maketitle
\section{緒論}          % 一、緒論
\subsection{研究背景}   % （一）研究背景
```

- `subtitle` 印在標題下方，`info` 的每一項在下一行置中排成一列，標籤灰色、值是內文色；沒有 `=` 的項目照原樣印出。作業、講義、考卷、書的封面都適用（簡報不支援）。
- 這些選項彼此獨立，可以只用其中幾個；不加時版面和以前完全一樣。

## en

**Add to the table in "Document options" of docs/reference.en.md**: the first row replaces the `text` row, the second replaces the `10pt` `11pt` `12pt` row, and the rest go after the `cjk`, `cjk-bold` row.

| Option | Values | Default | Effect |
|---|---|---|---|
| `text` | `serif` `sans` `times` `palatino` | `serif` | Body font. `serif` is New Computer Modern (same design as the math); `sans` uses Lato throughout; `times` and `palatino` use TeX Gyre Termes / Pagella (math stays Computer Modern). Headings and labels are Lato either way |
| `10pt` `11pt` `12pt` `13pt` `14pt`, `fontsize` | e.g. `fontsize=13pt` | `11pt` | Font size. `13pt`, `14pt` and any `fontsize=` go through scrextend |
| `par` | `skip` `indent` | `skip` | Paragraphs. `indent` indents every paragraph's first line by 2em (the first after a heading too) with no space between paragraphs, as Chinese reports do |
| `secnum` | `arabic` `zh` | `arabic` | `zh` numbers sections 一、, subsections （一）, subsubsections 1.; book chapters read 第一章. Theorem and equation numbers stay Arabic (定理 1.2); `\cref` gives 第一節 and 一（一） |
| `kai` | | | Chinese body text in a Kai face: Kaiti TC (macOS) > BiauKai (macOS) > DFKai-SB (Windows) > AR PL UKai (Linux) > STKaiti > FandolKai (ships with TeX Live, Simplified only, with a warning). Works with `text=sans` too; headings keep the sans face |
| `cjk-serif`, `cjk-serif-bold` | font name | Songti | Replace the CJK face and its bold for serif body text (`text=serif\|times\|palatino`), e.g. `cjk-serif-bold=Noto Serif CJK TC SemiBold`. With only `cjk-serif`, or a Kai face without bold, bold is synthesised |

**In the "ax new" options table**: change `--text serif\|sans` to `--text serif\|sans\|times\|palatino`.

**Add to "Writing content" in docs/reference.en.md, after "Mixed languages"**:

### Chinese reports

The layout of class reports, reflections and proposals:

```latex
\documentclass[lang=zh, par=indent, secnum=zh, 13pt, kai, text=times]{akizumi-note}
\title{2013 年臺灣毒澱粉事件}
\author{林子祐}
\akizumisetup{course=食品安全, subtitle={食品安全風險溝通失敗之案例研究},
  info={學號=B10303083, 系級=資工四}}
\begin{document}
\maketitle
\section{緒論}          % 一、緒論
\subsection{研究背景}   % （一）研究背景
```

- `subtitle` goes under the title; the `info` items follow on one centred line, labels muted and values in body colour; an item without `=` is printed as is. Works for homework, notes, exams and the book cover (not slides).
- The options are independent, so any subset works; without them the layout is exactly as before.

## changelog

- Chinese report layout: `par=indent` (2em first-line indent, no paragraph gaps), `secnum=zh` (一、 / （一） / 1.; 第一章), `13pt` / `14pt` / `fontsize=` (scrextend), `kai` (Kaiti TC, BiauKai, DFKai-SB, AR PL UKai, FandolKai), `cjk-serif` / `cjk-serif-bold`, `text=times|palatino` (TeX Gyre), and `\akizumisetup{subtitle=..., info={學號=..., 系級=...}}` in the title block. `ax new --text` accepts `times` and `palatino`. Defaults unchanged.
