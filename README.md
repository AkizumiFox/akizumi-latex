# aaron-latex

一份共用核心，套到所有文件類型。字型、配色、數學巨集只在 `aaron-core.sty` / `aaron-math.sty` 定義一次。

| 檔案 | 用途 |
|---|---|
| `aaron-math.sty` | 數學巨集，引擎無關，論文也能用 |
| `aaron-core.sty` | 字型、配色、定理、標題、頁首頁尾（需 XeLaTeX） |
| `aaron-hw.cls` | 作業 |
| `aaron-note.cls` | 講義／文件 |
| `aaron-exam.cls` | 考卷（包 `exam`） |
| `aaron-book.cls` | 論文、長篇講義、書（章、封面、每章小目錄） |
| `beamerthemeAaron.sty` | 簡報 |

## ax：建立與編譯專案

```sh
ax new hw ode-hw3 --lang zh --course 常微分方程 --number 3 --due 2026/10/28
ax new note rl4 --title "Self-Predictive Representations" --bib --layout margin
ax new slides talk --title "The JEPA Flood" --course "ELSA Lab" --progress
ax new book thesis --lang zh --title 自我預測表徵 --bib
ax new paper neurips --title "..." --bib      # pdfLaTeX，只載入 aaron-math
```

`ax new` 產生 `main.tex`（序言已填好）、`latexmkrc`、`.gitignore`、`figures/`、需要時的 `refs.bib`，以及記錄模板版本的 `.ax.json`。沒給的標題會互動式詢問。作者、學號、預設語言放在 `~/.config/ax/config.json`（`{"author": "Aaron Lin", "id": "...", "lang": "zh"}`）。

在專案資料夾裡：

| 指令 | 作用 |
|---|---|
| `ax build` | 編譯一次。只有成功才覆蓋外面的 PDF；失敗時印出第一個錯誤的 `檔案:行號` 和那一行，保留舊 PDF。latexmk 卡在上次失敗的狀態時會自動清掉重試，超過 10 分鐘就停 |
| `ax watch` | 存檔就重編，成功才更新 PDF；有 Skim 就用 Skim 開 |
| `ax both` | 作業／考卷：`main.pdf`（不含解答）與 `main-solutions.pdf` |
| `ax doctor` | 檢查 XeLaTeX、biber、字型、模板安裝與版本 |
| `ax upgrade` | 改用最新的模板版本 |
| `ax freeze` | 把目前版本的 `.sty`／`.cls` 複製進專案，之後不再依賴模板 repo（交件、封存時用） |
| `ax pack` | 打包成 `<專案名>-overleaf.zip`，上傳後把編譯器設為 XeLaTeX（paper 為 pdfLaTeX） |

### 版本固定

新專案固定在當下最新的版本 tag（例如 `v0.3`）。之後模板改版，舊專案仍然用 `v0.3` 編譯，要換版本才跑 `ax upgrade`。專案的 `latexmkrc` 會呼叫 `ax texinputs` 取得該版本的路徑，所以從編輯器直接呼叫 latexmk 也一樣固定。各版本解開在 `~/Library/Caches/ax/<tag>/`。

發佈新版本：改完模板、更新 `CHANGELOG.md`、`make check`、commit，然後 `git tag -a v0.4 -m v0.4`。

## 安裝

```sh
./install.sh     # symlink 到 $(kpsewhich -var-value TEXMFHOME)/tex/latex/aaron-latex，並把 ax、aaron-both 連到 ~/bin
```

之後任何資料夾都能直接用，編譯時用 `xelatex`（或 `latexmk -xelatex`）。

## 字型

- 內文：**New Computer Modern Book**（襯線），跟數學字型同一套設計，文字和公式不會一句話裡換兩種風格；中文內文用宋體（Songti TC）
- 結構：**Lato**，用在標題、章節、定理／題目標籤、頁首頁尾、圖表標籤，以及整份簡報。TeX Live 內建，用檔名載入；關掉了它的 ti 連字
- `text=sans` 可讓內文也改回 Lato（例如 `\documentclass[text=sans]{aaron-note}`），簡報永遠是 Lato
- 數學：Computer Modern，跟 beamer + fontspec 的預設一樣，簡報和文件的公式看起來一致
- Blackboard：**bboldx**（細體），大小寫、數字、希臘字母都有，所以 `\mathbb{1}`、`\mathbb{k}` 可以用；粗體用 `\mathbfbb`。
  選項 `bb=light|regular|ams` 可每份文件切換，例如 `\documentclass[bb=regular]{aaron-note}`、`\usetheme[bb=ams]{Aaron}`。
  只設在 aaron-core；論文單獨載入 aaron-math 時維持會議模板原本的 `\mathbb`
- 中文無襯線（結構文字、`text=sans` 的內文）：蘋方-繁（`PingFangTC-Regular` / `PingFangTC-Semibold`），可用 `cjk=`、`cjk-bold=` 選項換掉
- 等寬：JetBrains Mono（有安裝才用）

## 用法

```latex
\documentclass[lang=zh, solutions=false]{aaron-hw}       % 作業；solutions=false 隱藏所有解答
\documentclass{aaron-note}                               % 講義
\documentclass[lang=zh, solutions=true]{aaron-exam}      % 考卷；solutions=true 印出解答
\documentclass[aspectratio=169,11pt]{beamer}
\usetheme[lang=zh]{Aaron}                                % 簡報

\aaronsetup{course=常微分方程, number=3, due=2026/10/28, id=B12345678, kicker={...}}
```

共用指令：`\muted{}`、`\aaronrule`、`\aaronsep`（「A · B」分隔號，前面不要留空格）、表格欄型 `Y`、配色 `ink mute accent warn rule wash softred softamber softgreen`。
簡報另有 `\q{}`（討論問題）和 `\dividerframe{Appendix}`。
數學：`\vb{x}`（向量、矩陣用正體粗體；希臘字母自動改用 `\bm`，大寫正體、小寫斜體）、`x\T`、`\norm{}`、`\abs{}`、`\inner{}`、`\set{}`、`\E`、`\Var`、`\Cov`、`\KL`、`\argmin`、`\argmax`、`\tr`、`\rank`、`\diag`、`\sg`、`\R`、`\N`、`\Z`、`\dd`。

## 定理類環境

全部都有左側細線，標出從哪裡開始、到哪裡結束。只用一種藍色，靠線的粗細和深淺區分類型：

| 環境 | 線 | 標籤 |
|---|---|---|
| `theorem` `lemma` `proposition` `corollary` | 1.6pt accent | 藍色粗體 |
| `definition` | 1.6pt 淡藍 | 藍色粗體 |
| `example` `remark` | 1pt 灰 | 黑色粗體 |
| `proof`、作業與考卷的 `solution` | 0.8pt 淺灰 | 灰色粗體＋∎ |

另有 `claim`（同 theorem）、`assumption`（同 definition），以及每一種的無編號版本：`theorem*`、`definition*`⋯⋯

內文一律直體，不用斜體；可以跨頁；標題前會先預留空間，不會孤零零掉在頁尾。名稱不分語言，一律用英文（Theorem、Proof、Solution）。簡報裡的定理、證明也是同一套左線。

## 重述定理、證明放附錄、定理列表

```latex
\begin{restatable}[Cram\'er--Wold]{theorem}{cramerwold}\label{thm:cw} ... \end{restatable}
% 附錄裡：
\cramerwold*                          % 同一個編號、同一段內容
\begin{proofof}{thm:cw} ... \end{proofof}   % 「Proof of Theorem 1.2.」並連回去
\listoftheorems                       % 全部；[ignoreall, show={definition}] 只列定義
```

重述的那一份不會在列表裡重複出現。

## 演算法、符號表

```latex
\begin{algorithm}[t] \caption{...}\label{alg:x}
  \begin{algorithmic}[1] \Require ... \State ... \end{algorithmic}
\end{algorithm}

\begin{notation}
  \notn{$\vb{z}_t$}{latent state}
\end{notation}
```

## 版面

- `paper=a4|letter|pad`：`pad` 是 3:4 的平板閱讀版面
- `layout=margin`（講義、書）：右側留寬邊，`\sidenote{}` 有編號、`\marginnote{}` 沒編號，註腳也自動移到邊欄；`marginfigure`、`margintable`、`fullwidth`。沒開 `layout=margin` 時這些指令照樣能編，會退回成一般註腳和浮動體

## 書（aaron-book）

```latex
\documentclass[lang=zh, bib=refs.bib]{aaron-book}
\frontmatter \maketitle \tableofcontents
\mainmatter \chapter{緒論} \chaptertoc ...
\appendix \chapter{證明細節}
```

`\maketitle` 是整頁封面；章名上方是灰色的「第 1 章」／「附錄 A」，下方一條細線；`\chaptertoc` 放本章小目錄；頁首左邊是章名、右邊是節名。

## 題目卷與解答一次產生

```sh
aaron-both hw.tex     # → hw.pdf（不含解答）與 hw-solutions.pdf
```

適用 aaron-hw 和 aaron-exam；`install.sh` 會把它連到 `~/bin`。

## 簡報補充

- `\usetheme[progress]{Aaron}`：底部一條細的進度條
- `\standoutframe{Questions?}`：整頁 accent 色、一句話
- `\appendix` 之後的投影片另外編號，不算進總頁數

## 交叉引用與參考文獻

- `\cref{lem:a}` → 「Lemma 1.3」，名稱自動帶出；`\cref{lem:a,thm:b}` → 「Lemma 1.3 and Theorem 1.2」。`lang=zh` 時章節、圖、表、公式、題目改成「第 1 節」「圖 1」「表 1」「式 (1.1)」「第 1 題」
- `bib=refs.bib`（多個檔案用逗號）載入 biblatex：數字編號、依引用順序、`[1–3]` 自動壓縮，每筆文獻後面標出被引用的頁碼。在文末寫 `\printbibliography`
- 講義的公式依章節編號（1.1），頁首右側顯示目前的章節

## TikZ

`\node[aaron/box]`、`\draw[aaron/arrow]`、`\node[aaron/label]`、`\node[aaron/note]`、`aaron/alert`，跟簡報裡的圖同一個樣子；已載入 `positioning`、`arrows.meta`、`calc`。

## 程式碼

```latex
\begin{codeblock}[lang=Python, title=train.py]   % numbers=false 可關閉行號
...
\end{codeblock}
\inputcode[lang=Python]{train.py}
\code{inline_code()}
```

淡灰底、無框。過長的行會自動折行，並以灰色 ↪ 標示；跨頁時乾淨地切開，續頁右上角標 `cont.`。中文註解可以用。簡報裡要放在 `[fragile]` frame。

## 中英混排

`lang=zh|en` 只決定文件的**主語言**：日期格式、目錄／圖／表名稱、作業與考卷題號（「第 1 題」或「Problem 1」），以及行距（中文 1.2 倍、取消英文句尾的加寬空白）。

混排不需要任何標記：xeCJK 會逐字切換字型，中英文之間的間距也會自動加，打不打空格結果都一樣。`\emph` 在中文會改成粗體（中文沒有斜體），英文仍是 Lato Italic。數學模式裡也可以直接寫中文。

## 其他

- `\todo{...}`：橘色 `[TODO: ...]`；如果另外載入 todonotes，就讓給它
- `\blindfootnote{...}`：沒有編號的註腳
- 註腳固定在頁底（`footmisc[bottom]`）

論文（NeurIPS / ICML 等）只載入 `\usepackage{aaron-math}`。

完整範例在 `examples/`；`cd examples && latexmk -r latexmkrc hw.tex`。改過模板後跑 `make check`，會從頭重編所有範例，有錯就停下來並印出錯誤。版本紀錄見 `CHANGELOG.md`。

## 換電腦時

蘋方、宋體只有 macOS 有。找不到時會自動改用 Noto CJK TC，再找不到就用 TeX Live 內建的 Fandol，並在 log 裡警告，不會編譯失敗。

## 已知問題：biber

TeX Live 2026 的 biber 啟動時會呼叫 `lipo -extract_family`，但新版 Command Line Tools 的 `lipo` 已經拿掉這個參數，結果是 `extracting arm64 binary with lipo failed`。`~/bin/biber` 是繞過這個問題的腳本：它用 `lipo -thin` 取出本機架構的版本執行，TeX Live 更新 biber 時會自動重新取出。等 TeX Live 修好後刪掉 `~/bin/biber` 即可。
