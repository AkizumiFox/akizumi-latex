# aaron-latex

一套給作業、講義、考卷、簡報、論文共用的 LaTeX 模板，加上一個叫 `ax` 的指令列工具。

- **模板**負責外觀：字型、配色、定理框、程式碼區塊、頁首頁尾。所有文件類型共用同一個核心，改一次就全部同步。
- **`ax`** 負責流程：一行指令建立新專案、編譯、同時產生題目卷和解答、打包上傳 Overleaf，並把每個專案固定在某個模板版本，模板日後改版也不會讓舊作業壞掉。

本文件從零開始：先安裝，再做出第一份文件，然後依需要往下查。

---

## 1. 需要先有什麼

| 項目 | 怎麼確認 | 沒有的話 |
|---|---|---|
| macOS | | 模板本身跨平台，但 `ax` 和字型設定以 macOS 為主 |
| TeX Live 2026（MacTeX） | `xelatex --version` | 安裝 [MacTeX](https://tug.org/mactex/) |
| Command Line Tools | `git --version` | `xcode-select --install` |
| Python 3 | `python3 --version` | macOS 內建 |
| Skim（選用） | `/Applications/Skim.app` | `brew install --cask skim`；存檔自動重新整理、可從 PDF 跳回原始碼 |

編譯一律用 **XeLaTeX**（中文和字型需要它）。唯一的例外是投稿用的 `paper`，用 pdfLaTeX。

## 2. 安裝

```sh
git clone <這個 repo> ~/w/latex-templates
cd ~/w/latex-templates
./install.sh
```

`install.sh` 做三件事：

1. 把整個 repo 用 symlink 掛進 TeX 的個人目錄（`~/Library/texmf/tex/latex/aaron-latex`），之後任何資料夾的 `.tex` 都找得到模板；在 repo 裡改模板會立刻生效。
2. 把 `ax`、`aaron-both` 連到 `~/bin`。
3. 如果偵測到 TeX Live 的 biber 啟動失敗（見[疑難排解](#13-疑難排解)），也把修正版連到 `~/bin/biber`。

`~/bin` 要在 `PATH` 裡；不在的話 `install.sh` 會提示你加進 `~/.zshrc`。

接著告訴 `ax` 你是誰，之後每個新專案都會自動填入：

```sh
mkdir -p ~/.config/ax
cat > ~/.config/ax/config.json <<'EOF'
{
  "author": "Aaron Lin",
  "id": "B12345678",
  "lang": "zh"
}
EOF
```

三個欄位都可省略。`lang` 是預設語言（`zh` 或 `en`）；`id` 只有作業會用到。

最後檢查一次環境：

```sh
ax doctor
```

全部 `ok` 就可以開始。有 `BAD` 的項目，右邊會說明原因。

## 3. 第一份文件

以一份中文作業為例：

```sh
ax new hw ode-hw3 --course 常微分方程 --number 3 --due 2026/10/28
cd ode-hw3
ax watch
```

`ax watch` 會先編譯一次、打開 PDF，之後每次存檔就重編。現在用編輯器打開 `main.tex`：

```latex
% !TEX program = xelatex
\documentclass[lang=zh]{aaron-hw}
\aaronsetup{course={常微分方程}, number=3, due=2026/10/28, id=B12345678}
\author{Aaron Lin}

\begin{document}
\maketitle

\begin{problem}
% Problem statement.
\begin{solution}
% Solution.
\end{solution}
\end{problem}

\end{document}
```

標題「作業 3」、課名、繳交期限、學號都由 `\aaronsetup` 自動排好。把題目和解答填進去：

```latex
\begin{problem}[一階線性方程]
解初值問題 $y' + 2y = e^{-x}$，$y(0) = 1$。
\begin{solution}
積分因子為 $\mu(x) = e^{2x}$，所以 $(e^{2x}y)' = e^{x}$，積分得
\[ y(x) = e^{-x} + C e^{-2x}. \]
由 $y(0)=1$ 得 $C = 0$。
\end{solution}
\end{problem}
```

存檔，PDF 會自動更新。如果寫錯了，`ax watch` 會印出出錯的檔案和行號，**並保留上一份成功的 PDF**，不會變成空白或壞掉的檔案。按 `Ctrl-C` 停止。

要交作業時：

```sh
ax build      # 編譯一次，得到 main.pdf
ax both       # 同時得到 main.pdf（只有題目）與 main-solutions.pdf（含解答）
```

`ax both` 適合當助教發題目、再發解答的情況。

## 4. 選哪一種文件

```sh
ax new <種類> <資料夾> [選項]
```

不給任何參數直接打 `ax new`，它會用選單問你種類、資料夾和標題。

| 種類 | 用途 | 範例 |
|---|---|---|
| `hw` | 作業：題目、解答、解答開關 | `ax new hw ode-hw3 --course 常微分方程 --number 3` |
| `note` | 講義、筆記、報告 | `ax new note rl4 --title "Self-Predictive Representations" --course "Reinforcement Learning"` |
| `exam` | 考卷、小考（配分、評分表） | `ax new exam mid --title 期中考 --course 常微分方程` |
| `slides` | 簡報 | `ax new slides talk --title "The JEPA Flood" --course "ELSA Lab" --progress` |
| `book` | 論文、長篇講義（章、封面、目錄） | `ax new book thesis --title 自我預測表徵 --course "國立臺灣大學 碩士論文" --bib` |
| `paper` | 投稿論文的內文（pdfLaTeX，只用數學巨集） | `ax new paper neurips --title "Distributional Critics" --bib` |

`ax new` 的選項：

| 選項 | 意思 |
|---|---|
| `--title` | 標題（作業不需要，會自動寫成「作業 N」） |
| `--author` | 作者，預設取自 `config.json` |
| `--course` | 課名；書是標題上方那一行，簡報是日期那一行 |
| `--number` `--due` `--id` | 作業編號、繳交期限、學號 |
| `--lang zh\|en` | 主語言，預設取自 `config.json` |
| `--text serif\|sans` `--paper a4\|letter\|pad` `--layout normal\|margin` | 見[文件選項](#6-文件選項) |
| `--bib` | 加上 `refs.bib` 和參考文獻 |
| `--progress` | 簡報底部的進度條 |
| `--git` | 建立 git repo 並做第一個 commit |

每個新專案的內容：

```
ode-hw3/
├── main.tex      序言已經填好
├── latexmkrc     編譯設定（XeLaTeX、輸出到 build/、SyncTeX）
├── .ax.json      記錄種類和模板版本
├── .gitignore
├── figures/
└── refs.bib      加了 --bib 才有
```

中間檔都在 `build/`，資料夾裡只會多出一份 `main.pdf`。

## 5. 寫內容

以下指令在所有文件類型都能用（簡報也是，除非另外註明）。

### 定理、定義、證明

```latex
\begin{definition}[Collapse]\label{def:collapse}
若 $\Var[f(\vb{o})] = 0$，稱編碼器 $f$ collapse。
\end{definition}

\begin{theorem}[Cram\'er--Wold]\label{thm:cw}
A random vector $\vb{z}$ is $\mathcal{N}(\vb{0},\vb{I})$ iff $\vb{u}\T\vb{z} \sim \mathcal{N}(0,1)$ for every unit $\vb{u}$.
\end{theorem}

\begin{proof}
Characteristic functions agree on every line through the origin.
\end{proof}
```

可用的環境：`theorem` `lemma` `proposition` `corollary` `claim` `definition` `assumption` `example` `remark` `proof`，每一種都有不編號的版本（`theorem*` 等）。每個環境左側都有一條細線標出起訖；名稱一律用英文（Theorem、Proof），不論文件主語言。

定理可以在附錄重述並證明：

```latex
\begin{restatable}{theorem}{cramerwold}\label{thm:cw} ... \end{restatable}

% 附錄
\cramerwold*                              % 同一個編號、同一段文字
\begin{proofof}{thm:cw} ... \end{proofof} % 「Proof of Theorem 1.2.」並連回原處
```

`\listoftheorems` 列出所有定理類環境（重述的不會重複列）。

### 數學

| 寫法 | 結果 |
|---|---|
| `\vb{x}`、`\vb{A}` | 向量、矩陣用正體粗體；希臘字母自動改用粗斜體／粗正體 |
| `\vb{x}\T` | 轉置 |
| `\norm{x}`、`\abs{x}`、`\inner{x, y}`、`\set{x}` | 配對括號；加星號 `\norm*{...}` 自動調整大小 |
| `\E`、`\Var`、`\Cov`、`\KL`、`\tr`、`\rank`、`\diag`、`\sg` | 運算子 |
| `\argmin`、`\argmax` | 下標放在正下方 |
| `\R`、`\N`、`\Z`、`\mathbb{1}` | 黑板粗體（bboldx，含數字和小寫） |
| `\int f(x) \dd x` | 正體的 d |

數學模式裡可以直接寫中文，例如 `$x_{最大}$`。

### 交叉引用

一律用 `\cref`，它會自動帶出名稱：

```latex
見\cref{thm:cw}、\cref{def:collapse}、\cref{eq:loss}。
```

英文文件輸出「Theorem 1.2」「Definition 1.1」「Equation (1.1)」；`lang=zh` 時章節、圖、表、公式、題目改成「第 1 節」「圖 1」「表 1」「式 (1.1)」「第 1 題」，定理名稱維持英文。

### 參考文獻

建立專案時加 `--bib`，或在已有的文件加上 `bib=refs.bib` 選項：

```latex
\documentclass[bib=refs.bib]{aaron-note}
...
如 MR.Q~\cite{fujimoto2025mrq} 所示。
...
\printbibliography
```

數字編號、依引用順序，`[1–3]` 自動壓縮，每筆文獻後面標出被引用的頁碼。`ax build` 會自動執行 biber。

### 程式碼

```latex
\begin{codeblock}[lang=Python, title=sigreg.py]
def sigreg(z, num_dirs=64):
    u = torch.randn(z.shape[1], num_dirs)   # 隨機方向
    return epps_pulley(z @ u).mean()
\end{codeblock}

\inputcode[lang=Python]{train.py}     % 直接讀檔
\code{loss.backward()}                % 行內
```

淡灰底、有行號（`numbers=false` 關閉）。太長的行會自動折行並標示 ↪，跨頁時續頁右上角標 `cont.`。簡報裡的 frame 要加 `[fragile]`。

### 演算法、符號表

```latex
\begin{algorithm}[t]
  \caption{SIGReg training step}\label{alg:sigreg}
  \begin{algorithmic}[1]
    \Require batch $\{\vb{o}_i\}$, weight $\lambda$
    \State $\vb{Z} \gets f_\theta(\vb{o})$
  \end{algorithmic}
\end{algorithm}

\begin{notation}
  \notn{$\vb{z}_t$}{latent state at time $t$}
  \notn{$\sg(\cdot)$}{stop-gradient}
\end{notation}
```

### 圖

```latex
\begin{figure}[t]
  \centering
  \begin{subfigure}{0.45\linewidth} \includegraphics[width=\linewidth]{figures/a.pdf} \caption{...} \end{subfigure}
  \begin{subfigure}{0.45\linewidth} ... \end{subfigure}
  \caption{...}\label{fig:x}
\end{figure}
```

TikZ 圖可以用跟簡報一致的樣式：

```latex
\begin{tikzpicture}
  \node[aaron/box] (a) {encoder};
  \node[aaron/box, right=1cm of a] (b) {$\vb{z}$};
  \draw[aaron/arrow] (a) -- node[above, aaron/note] {sg} (b);
\end{tikzpicture}
```

### 中英混排

不需要任何標記。中英文之間要不要打空格都可以，間距會自動處理。`\emph{強調}` 在中文顯示為粗體（中文沒有斜體），英文仍是斜體。

### 其他小工具

| 指令 | 作用 |
|---|---|
| `\todo{補推導}` | 橘色的 `[TODO: 補推導]` |
| `\blindfootnote{...}` | 沒有編號的註腳，例如「本講義改編自⋯」 |
| `\sidenote{...}`、`\marginnote{...}` | 邊欄註記（`layout=margin` 時才在邊欄，否則變成一般註腳） |
| `\muted{...}` | 灰色文字 |

### 作業與考卷專用

```latex
\begin{problem}[標題]          % 作業：第 N 題
  \begin{parts} \item ... \item ... \end{parts}   % (a) (b)
  \begin{solution} ... \end{solution}
\end{problem}
```

考卷用 [exam](https://ctan.org/pkg/exam) 的寫法：`\begin{questions} \question[10] ... \begin{parts} \part[5] ...`，`\gradetable` 產生評分表。

解答開關：作業預設顯示解答，`\documentclass[solutions=false]{aaron-hw}` 隱藏；考卷預設隱藏，`solutions=true` 顯示。用 `ax both` 就不用手動切換。

### 簡報專用

```latex
\begin{frame}[plain,noframenumbering]\titlepage\end{frame}
\q{這是討論問題嗎？}                % 藍色 Q: 開頭的提問
\standoutframe{Questions?}          % 整頁藍底一句話
\appendix                           % 之後的投影片另外編號，不算進總頁數
\dividerframe{Appendix}
```

每個 `\section` 前會自動插入一頁「Part N」。

### 書專用

```latex
\frontmatter \maketitle \tableofcontents
\mainmatter
\chapter{緒論}
\chaptertoc            % 本章小目錄
...
\appendix \chapter{證明細節}
\backmatter \printbibliography
```

`\maketitle` 是整頁封面；頁首左邊是章名、右邊是節名。

## 6. 文件選項

寫在 `\documentclass[...]` 裡（簡報寫在 `\usetheme[...]{Aaron}`）：

| 選項 | 值 | 預設 | 作用 |
|---|---|---|---|
| `lang` | `en` `zh` | `en` | 主語言：日期格式、目錄／圖／表名稱、題號、中文行距 |
| `text` | `serif` `sans` | `serif` | 內文字型。`serif` 用 New Computer Modern（和數學同一套設計），`sans` 整份用 Lato |
| `bb` | `light` `regular` `ams` | `light` | 黑板粗體的粗細；`ams` 是傳統 AMS 字型（只有大寫） |
| `paper` | `a4` `letter` `pad` | `a4` | 紙張；`pad` 是 3:4 的平板閱讀版面 |
| `layout` | `normal` `margin` | `normal` | `margin` 留寬邊欄放 `\sidenote`（講義、書） |
| `bib` | 檔名 | | 載入參考文獻，例如 `bib=refs.bib` |
| `solutions` | `true` `false` | 作業 `true`，考卷 `false` | 是否印出解答 |
| `10pt` `11pt` `12pt` | | `11pt` | 字級 |
| `cjk`、`cjk-bold` | 字型名稱 | 蘋方 | 換掉中文無襯線字型 |

簡報另有 `progress`（底部進度條）。

## 7. ax 指令總覽

| 指令 | 作用 |
|---|---|
| `ax new` | 建立專案（見第 4 節） |
| `ax build` | 編譯一次。只有成功才更新 `main.pdf`；失敗時印出第一個錯誤的檔案、行號和那一行，保留舊 PDF |
| `ax watch` | 存檔就重編；有 Skim 就用 Skim 開，否則用預覽程式 |
| `ax both` | 作業／考卷：`main.pdf`（題目）和 `main-solutions.pdf`（解答） |
| `ax doctor` | 檢查工具、字型、模板安裝和版本 |
| `ax upgrade` | 把專案換到最新的模板版本 |
| `ax freeze` | 把模板檔複製進專案，從此不依賴這個 repo |
| `ax pack` | 打包成 `<資料夾名>-overleaf.zip` |
| `ax --version` | 目前最新的模板版本 |

`ax build` 錯誤訊息的樣子：

```
failed  main.tex
  ./main.tex:11: Undefined control sequence.
    l.11 \undefinedmacro
                         here
  kept the previous main.pdf
```

`l.11` 那兩行是原始碼第 11 行，斷開的地方就是出錯的位置。

`ax build` 還會處理兩種常見狀況：latexmk 記住上一次的失敗而不肯重跑時，自動清掉重試一次；編譯超過 10 分鐘（通常是在等輸入）就停止。

## 8. 版本：舊文件不會壞

模板會持續修改，但三個月前的作業應該照原樣編譯。做法是**每個專案記住自己用的模板版本**：

- 建立專案時，`.ax.json` 記下當時最新的版本（例如 `"template": "v0.4"`）。
- 之後模板改到 v0.5，這個專案仍然用 v0.4 編譯。各版本的檔案放在 `~/Library/Caches/ax/<版本>/`。
- 想要新外觀時，在專案裡跑 `ax upgrade`，再 `ax build` 確認。

這也適用於編輯器：專案的 `latexmkrc` 會向 `ax` 查詢版本，所以從編輯器直接呼叫 latexmk 也是同一個版本。

要把專案交出去或封存：

```sh
ax freeze    # 把該版本的 .sty / .cls 複製進專案，之後只靠自己就能編
ax pack      # 打包成 zip，內含模板檔，可直接上傳 Overleaf
```

上傳 Overleaf 後，在 Menu → Compiler 選 **XeLaTeX**（`paper` 選 pdfLaTeX）。Overleaf 沒有蘋方和宋體，中文會自動改用 Noto CJK，外觀會略有不同但能編譯。

## 9. 在編輯器裡用

**終端機 + 任意編輯器**：開著 `ax watch`，在編輯器裡存檔即可。這是最簡單的方式。

**Skim 反向搜尋**：專案已開啟 SyncTeX。在 Skim 的設定 → 同步裡選你的編輯器，之後在 PDF 上 Cmd-Shift-點擊就會跳到原始碼對應的行。

**VS Code（LaTeX Workshop）**：它預設的 latexmk 配方帶有 `-pdf`，會強制用 pdfLaTeX 而編譯失敗。在專案或使用者設定裡加入一個沿用 `latexmkrc` 的配方：

```json
{
  "latex-workshop.latex.tools": [
    { "name": "latexmk-rc", "command": "latexmk",
      "args": ["-interaction=nonstopmode", "-file-line-error", "%DOC%"] }
  ],
  "latex-workshop.latex.recipes": [
    { "name": "latexmk (latexmkrc)", "tools": ["latexmk-rc"] }
  ],
  "latex-workshop.latex.outDir": "%DIR%/build"
}
```

（這段設定未在本機的 VS Code 上實測。）

## 10. 不用 ax 也可以

模板就是普通的 LaTeX class，任何資料夾都能直接用：

```latex
\documentclass[lang=zh]{aaron-note}
\title{講義}
\author{Aaron Lin}
\begin{document}
\maketitle
...
\end{document}
```

```sh
latexmk -xelatex main.tex
```

可用的 class：`aaron-hw`、`aaron-note`、`aaron-exam`、`aaron-book`；簡報是 `\documentclass[aspectratio=169]{beamer}` 加 `\usetheme{Aaron}`。

投稿會議論文時，會議會要求用它自己的模板，外觀不能改。這時只載入數學巨集：

```latex
\usepackage{aaron-math}    % \vb、\norm、\E、\argmin……；pdfLaTeX 也能用
```

`ax new paper` 建出來的就是這種設定。

## 11. 外觀規則（參考）

**字型**

| 用途 | 字型 |
|---|---|
| 內文 | New Computer Modern Book（襯線），中文宋體 |
| 標題、章節、定理標籤、頁首頁尾、簡報 | Lato，中文蘋方 |
| 數學 | Computer Modern；黑板粗體 bboldx |
| 程式碼 | JetBrains Mono（有安裝才用） |

**定理類環境的左側線**：只用一種藍色，靠粗細和深淺區分。

| 環境 | 線 | 標籤 |
|---|---|---|
| theorem、lemma、proposition、corollary、claim | 粗、藍 | 藍色粗體 |
| definition、assumption | 粗、淡藍 | 藍色粗體 |
| example、remark | 細、灰 | 黑色粗體 |
| proof、solution | 最細、淺灰 | 灰色粗體，結尾 □ |

內文一律直體；可跨頁；標題不會單獨留在頁尾。

**配色**（可直接用在 `\color{...}`、TikZ）：`ink` 內文、`mute` 次要文字、`accent` 藍色重點、`warn` 橘色警示、`rule` 細線、`wash` 淡灰底，另有 `softred` `softamber` `softgreen` 三個淡色塊。

**其他指令**：`\aaronsep`（「A · B」的分隔點，前面不要留空格）、`\aaronrule`（細線）、表格欄型 `Y`（自動換行的左對齊欄）。

## 12. 維護這套模板

```
aaron-math.sty        數學巨集（引擎無關）
aaron-core.sty        共用核心：字型、配色、定理、程式碼、版面、參考文獻
aaron-hw.cls          作業
aaron-note.cls        講義
aaron-exam.cls        考卷（基於 exam）
aaron-book.cls        論文、書
beamerthemeAaron.sty  簡報
skeletons/            ax new 用的內文骨架
examples/             每種文件的完整範例，兼當測試
bin/                  ax、aaron-both、biber 修正
```

改完模板後：

```sh
make check      # 從頭重編 examples/ 裡所有範例，有錯就停下並印出錯誤
make test-ax    # 在暫存資料夾用 ax 建立並編譯每一種專案
```

發佈新版本（讓新專案用上、舊專案可以 `ax upgrade`）：

1. 更新 `CHANGELOG.md`。
2. 把各檔 `\ProvidesPackage` / `\ProvidesClass` 裡的版本號改掉。
3. `make check && make test-ax`。
4. `git commit`，然後 `git tag -a v0.5 -m v0.5`。

沒有打 tag 的修改只影響 `examples/` 和直接用模板的文件，不會影響已經固定版本的專案。

## 13. 疑難排解

**`ax doctor` 說 biber 有問題，或參考文獻全是問號**
TeX Live 2026 的 biber 啟動時呼叫 `lipo -extract_family`，新版 Command Line Tools 已經移除這個參數，錯誤訊息是 `extracting arm64 binary with lipo failed`。`install.sh` 偵測到時會把 `bin/biber` 連到 `~/bin/biber`：它用 `lipo -thin` 取出本機架構的版本執行，TeX Live 更新 biber 時會自動重新取出。等 TeX Live 修好後刪掉 `~/bin/biber` 即可。

**改了模板，專案的 PDF 沒變**
專案固定在舊版本（見第 8 節）。跑 `ax upgrade`；或者模板的修改還沒打 tag。

**換到另一台電腦，中文字型不一樣**
蘋方、宋體只有 macOS 有。找不到時會依序改用 Noto CJK TC、TeX Live 內建的 Fandol，並在 log 裡警告，不會編譯失敗。

**編譯時出現 `XeTeX is required to compile this document.`**
用了 pdfLaTeX。終端機請用 `ax build` 或 `latexmk`（會讀 `latexmkrc`）；編輯器設定見第 9 節。

**`ax` 找不到**
`~/bin` 不在 `PATH` 裡。在 `~/.zshrc` 加上 `export PATH="$HOME/bin:$PATH"`，重開終端機。

**其他錯誤**
先跑 `ax doctor`。完整的編譯紀錄在 `build/main.log`。

---

版本紀錄見 [`CHANGELOG.md`](CHANGELOG.md)。
