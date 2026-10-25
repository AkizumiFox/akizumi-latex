## zh

### 1. 〈ax new 的選項與專案內容〉的選項表，接在 `--progress` 那一列後面

| `--venue neurips\|icml\|iclr\|aaai\|plain` | 投稿論文的會議（預設 `plain`），見〈投稿論文〉 |
| `--split` | 投稿論文：每一節放在 `sections/` 裡的獨立檔案 |
| `--anonymous` `--no-anonymous` | 投稿論文：匿名投稿版或署名版；會議預設匿名，`plain` 預設署名 |

### 2. 〈參考文獻〉整段改成

建立專案時加 `--bib`，或在已有的文件加上 `bib=refs.bib` 選項：

```latex
\documentclass[bib=refs.bib]{akizumi-note}
...
如 MR.Q~\cite{fujimoto2025mrq} 所示。
...
\printbibliography
```

預設是數字編號、依引用順序，`[1–3]` 自動壓縮，每筆文獻後面標出被引用的頁碼。`ax build` 會自動執行 biber。

另外三個選項跟 `bib=` 寫在一起：

| 選項 | 值 | 預設 | 作用 |
|---|---|---|---|
| `bibstyle` | `numeric` `authoryear` `apa` | `numeric` | `authoryear` 是 (Lin, 2026)，文獻依作者排序；`apa` 是 APA 第 7 版 |
| `backref` | `true` `false` | `true` | 文獻後面要不要標出被引用的頁碼 |
| `cite` | `normal` `super` | `normal` | `super` 讓 `\cite` 變成上標數字（只用在 `numeric`），寫成 `模型\cite{key}`，前面不要空格 |

```latex
\documentclass[bib=refs.bib, bibstyle=authoryear, backref=false]{akizumi-note}
\citet{lin2026} 提出……；後續研究 \citep{lin2026, sutton2018}。
```

`\citep`（括號）、`\citet`（作者當主詞）、`\citeauthor` 在每種 `bibstyle` 都能用，寫法跟 natbib 一樣。

### 3. 〈不用 ax 直接用模板〉裡「投稿會議論文時……`ax new paper` 建出來的就是這種設定。」整段改成新的一節〈投稿論文〉，放在〈不用 ax 直接用模板〉之後

## 投稿論文

會議會要求用它自己的模板，外觀不能改，所以 `paper` 專案用 pdfLaTeX，不載入 akizumi 的外觀，只借兩個不綁編譯引擎的套件：

```latex
\usepackage{akizumi-math}                    % \vb、\norm、\E、\argmin……
\usepackage[refstyle=short]{akizumi-paper}   % 註解、縮寫、表格標記
```

**建立專案**

```sh
ax new paper flora --venue neurips --split
```

| `--venue` | 產生的設定 |
|---|---|
| `neurips` | `\usepackage{neurips_2026}`，署名版是 `[final]`；natbib 由會議樣式載入（要數字引用就把 `\PassOptionsToPackage{numbers, compress}{natbib}` 那行的註解拿掉）；最後留 checklist 的位置 |
| `icml` | `\usepackage{icml2026}`，署名版是 `[accepted]`；`\twocolumn[...]` 作者區塊、`\bibliographystyle{icml2026}` |
| `iclr` | `\usepackage{iclr2026_conference,times}`，署名版自動加 `\iclrfinalcopy` |
| `aaai` | `\usepackage[submission]{aaai2026}` 加上 AAAI 規定不能改的那幾行；**不載入 hyperref**（AAAI 禁止） |
| `plain` | 一般的 `article`，加 hyperref（有 `--bib` 時加 `[numbers]natbib`） |

會議的 `.sty`、`.bst` 每年都會更新，所以**不附在專案裡**：`main.tex` 開頭的註解寫了檔名和下載的地方，`ax new` 結束時也會提醒。年份不同就把檔名改掉。會議版本都會建 `refs.bib`。

匿名切換在 `main.tex` 開頭：

```latex
\newif\ifanonymous \anonymoustrue    % 改成 \anonymousfalse 就是 camera-ready 版
```

它同時切換會議樣式的選項（`[final]`、`[accepted]`、`\iclrfinalcopy`、`[submission]`）和下面的 `\anon`。`--split` 會建出 `sections/introduction.tex`、`related`、`method`、`experiments`、`conclusion` 和 `appendix`，`main.tex` 用 `\input` 接起來。

ICLR 的 `math_commands.tex` 也定義了 `\E`、`\R`、`\Var` 等，跟 akizumi-math 會撞名，兩個選一個用。

**akizumi-paper**

放在序言最後（hyperref 之後；自己要用帶選項的 xcolor 或 cleveref 的話，也放在它們之後）。在 akizumi 的 class 裡一樣能用。

```latex
\newcommenter{jun}{Jun}{teal}
\jun{這個界夠緊嗎？}        % 註解：青綠色的「[Jun: 這個界夠緊嗎？]」
\jun*{改寫過的句子}          % 修改：文字本身變青綠色
```

| 指令 | 結果 |
|---|---|
| `\newcommenter{名字}{標籤}{顏色}` | 定義 `\名字{註解}` 和 `\名字*{修改}`，每位共同作者一個顏色 |
| `\eg` `\ie` `\etal` `\cf` `\wrt` `\etc` | *e.g.*、*i.e.*、*et al.*、*cf.*、w.r.t.、etc.；放在句尾不會多一個句點，後面也不會變成句末的寬空格 |
| `\best{0.91}` `\second{0.88}` | 粗體、底線（數學 `$...$` 也會變粗） |
| `\cmark` `\xmark` | ✓、✗ |
| `\anon[替代文字]{原文}` | 匿名時印替代文字（預設 Anonymous），例如自己先前的論文 |

也會載入 booktabs、multirow、makecell，以及 cleveref（還沒載入的話）。

| 選項 | 作用 |
|---|---|
| `final` | 註解全部消失（不留多餘空格），修改保留成一般顏色的文字；投稿前加上 |
| `anonymous` | `\anon` 印替代文字 |
| `refstyle=short` | `\cref` 寫成 Fig. 1、Figs. 1 and 2、Eq. (2)；節、表維持全名。只影響英文，中日韓的名稱本來就短。預設 `long` |

選項也可以在序言裡用 `\akizumipapersetup{final}` 設定。

### 4. 〈ax new 的選項與專案內容〉的 `config.json` 段落補一句

`defaults` 也接受 `"paper": {"venue": "neurips", "split": true}`。

## en

### 1. In "ax new options and project contents", rows after `--progress`

| `--venue neurips\|icml\|iclr\|aaai\|plain` | The venue of a paper (default `plain`); see "Papers" |
| `--split` | Paper: each section in its own file in `sections/` |
| `--anonymous` `--no-anonymous` | Paper: anonymous submission or camera-ready with names; venues default to anonymous, `plain` to names |

### 2. Replace the "Bibliography" section with

Add `--bib` when creating the project, or add the `bib=refs.bib` option to an existing document:

```latex
\documentclass[bib=refs.bib]{akizumi-note}
...
As MR.Q~\cite{fujimoto2025mrq} shows.
...
\printbibliography
```

By default: numeric, in citation order, ranges compressed to `[1–3]`, and each entry lists the pages that cite it. `ax build` runs biber for you.

Three more options go next to `bib=`:

| Option | Values | Default | Effect |
|---|---|---|---|
| `bibstyle` | `numeric` `authoryear` `apa` | `numeric` | `authoryear` gives (Lin, 2026) with entries sorted by author; `apa` is APA 7th edition |
| `backref` | `true` `false` | `true` | List the pages that cite each entry |
| `cite` | `normal` `super` | `normal` | `super` makes `\cite` a superscript number (`numeric` only); write `models\cite{key}` with no space before it |

```latex
\documentclass[bib=refs.bib, bibstyle=authoryear, backref=false]{akizumi-note}
\citet{lin2026} propose ...; later work \citep{lin2026, sutton2018}.
```

`\citep` (in parentheses), `\citet` (author as subject) and `\citeauthor` work in every `bibstyle`, as in natbib.

### 3. In "Using the templates without ax", replace the paragraph from "A conference paper must use the venue's own template" to "That's what `ax new paper` sets up." with a new section "Papers" right after it

## Papers

A venue requires its own template, whose look you can't change, so a `paper` project uses pdfLaTeX, loads none of the akizumi styling, and borrows two engine-agnostic packages:

```latex
\usepackage{akizumi-math}                    % \vb, \norm, \E, \argmin, ...
\usepackage[refstyle=short]{akizumi-paper}   % comments, abbreviations, table marks
```

**Starting one**

```sh
ax new paper flora --venue neurips --split
```

| `--venue` | What main.tex gets |
|---|---|
| `neurips` | `\usepackage{neurips_2026}`, `[final]` for the camera-ready; the style loads natbib (uncomment the `\PassOptionsToPackage{numbers, compress}{natbib}` line for numeric citations); a place for the checklist at the end |
| `icml` | `\usepackage{icml2026}`, `[accepted]` for the camera-ready; the `\twocolumn[...]` author block, `\bibliographystyle{icml2026}` |
| `iclr` | `\usepackage{iclr2026_conference,times}`; `\iclrfinalcopy` for the camera-ready |
| `aaai` | `\usepackage[submission]{aaai2026}` and AAAI's do-not-change lines; **no hyperref** (AAAI forbids it) |
| `plain` | A plain `article` with hyperref (and `[numbers]natbib` with `--bib`) |

Venues publish new `.sty` and `.bst` files every year, so they are **not included**: a comment at the top of `main.tex` names the file and where to download it, and `ax new` reminds you. For another year, change the name. Venue projects always get `refs.bib`.

The anonymity switch is at the top of `main.tex`:

```latex
\newif\ifanonymous \anonymoustrue    % \anonymousfalse for the camera-ready version
```

It switches the venue's option (`[final]`, `[accepted]`, `\iclrfinalcopy`, `[submission]`) and `\anon` below. `--split` creates `sections/introduction.tex`, `related`, `method`, `experiments`, `conclusion` and `appendix`, joined with `\input` in `main.tex`.

ICLR's `math_commands.tex` also defines `\E`, `\R`, `\Var`, ..., which clash with akizumi-math; use one of the two.

**akizumi-paper**

Load it last in the preamble (after hyperref, and after xcolor or cleveref if you load them with options of your own). It works in the akizumi classes too.

```latex
\newcommenter{jun}{Jun}{teal}
\jun{is this bound tight?}   % comment: "[Jun: is this bound tight?]" in teal
\jun*{a rewritten clause}    % edit: the text itself in teal
```

| Command | Result |
|---|---|
| `\newcommenter{name}{Label}{color}` | Defines `\name{comment}` and `\name*{edit}`; one color per co-author |
| `\eg` `\ie` `\etal` `\cf` `\wrt` `\etc` | *e.g.*, *i.e.*, *et al.*, *cf.*, w.r.t., etc.; no doubled period at a sentence end, and no sentence-wide space after them |
| `\best{0.91}` `\second{0.88}` | Bold, underlined (bold math too) |
| `\cmark` `\xmark` | ✓, ✗ |
| `\anon[replacement]{text}` | The replacement (default Anonymous) while anonymous, e.g. for your own earlier paper |

It also loads booktabs, multirow, makecell, and cleveref unless it is loaded already.

| Option | Effect |
|---|---|
| `final` | Comments disappear (leaving no extra space) and edits stay as ordinary text; add it before submitting |
| `anonymous` | `\anon` prints its replacement |
| `refstyle=short` | `\cref` gives Fig. 1, Figs. 1 and 2, Eq. (2); sections and tables keep full names. English only: CJK names are already short. Default `long` |

The same keys can be set later in the preamble with `\akizumipapersetup{final}`.

### 4. In "ax new options and project contents", add to the `config.json` paragraph

`defaults` also accepts `"paper": {"venue": "neurips", "split": true}`.

## changelog

- Papers: `ax new paper --venue neurips|icml|iclr|aaai|plain [--split] [--no-anonymous]` writes the venue's own preamble (no forced natbib options or hyperref; the venue `.sty` is downloaded, not shipped) with one `\ifanonymous` switch; new engine-agnostic `akizumi-paper.sty` with `\newcommenter` (and `final`), `\anon`, `\eg` `\ie` `\etal` `\cf` `\wrt` `\etc`, `\best` `\second` `\cmark` `\xmark`, `refstyle=short`; bibliography options `bibstyle=numeric|authoryear|apa`, `backref=true|false`, `cite=super`, with `\citep` / `\citet` in every style (`akizumi-bib.sty`).
