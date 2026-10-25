# akizumi-latex 參考手冊

[README](../README.md) 是入門；這裡是完整的功能與選項，需要時再查。完整的範例在 [`examples/`](../examples/)。

## ax new 的選項與專案內容

不給參數直接打 `ax new`，會用選單問你種類、資料夾和標題。選項：

| 選項 | 意思 |
|---|---|
| `--title` | 標題（作業不需要，會自動寫成「作業 N」） |
| `--author` | 作者，預設取自 `config.json` |
| `--course` | 課名；作業、講義、考卷放在頁首和標題上方，書和簡報放在標題上方 |
| `--number` `--due` `--id` | 作業編號、繳交期限、學號 |
| `--lang zh\|en` | 主語言，預設取自 `config.json` |
| `--text serif\|sans` `--paper a4\|letter\|pad` `--layout normal\|margin` | 見〈文件選項〉 |
| `--bib` | 加上 `refs.bib` 和參考文獻 |
| `--progress` | 簡報底部的進度條 |
| `--git` | 建立 git repo 並做第一個 commit |
| `--no-preamble` | 這次不加入你的 `preamble.tex`、`preamble-種類.tex`（見 README〈自訂 preamble〉） |
| `--pin v0.7` | 指定模板版本；預設是最新的 tag。`--pin latest` 表示永遠用安裝的最新檔案（改模板時測試用） |
| `--force` | 資料夾已存在且不是空的也照樣建立 |

`config.json` 的 `defaults` 可以替每種文件設預設選項，命令列給的優先。

每個新專案的內容：

```
ode-hw3/
├── main.tex      序言已經填好
├── latexmkrc     編譯設定（XeLaTeX、輸出到 build/、SyncTeX）；沒有電腦專屬的路徑
├── .ax.json      記錄種類和模板版本
├── .vscode/      Cursor／VS Code 的編譯設定
├── .gitignore
├── figures/
└── refs.bib      加了 --bib 才有
```

中間檔都在 `build/`，資料夾裡只會多出一份 `main.pdf`。

## 寫內容

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
\documentclass[bib=refs.bib]{akizumi-note}
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
  \node[akizumi/box] (a) {encoder};
  \node[akizumi/box, right=1cm of a] (b) {$\vb{z}$};
  \draw[akizumi/arrow] (a) -- node[above, akizumi/note] {sg} (b);
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

解答開關：作業預設顯示解答，`\documentclass[solutions=false]{akizumi-hw}` 隱藏；考卷預設隱藏，`solutions=true` 顯示。用 `ax both` 就不用手動切換。

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

## 文件選項

寫在 `\documentclass[...]` 裡（簡報寫在 `\usetheme[...]{Akizumi}`）：

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

## ax 指令細節

除了 `new`、`doctor`、`config`、`completion`，其他指令都在專案資料夾裡執行；在它的子資料夾（例如 `figures/`）裡也可以，`ax` 會像 git 一樣往上找 `.ax.json`。

| 指令 | 作用 |
|---|---|
| `ax` | 在專案裡：顯示種類、模板版本（有新版會提示）、PDF 什麼時候更新的、常用指令。不在專案裡：顯示說明 |
| `ax new` | 建立專案（見〈ax new 的選項〉） |
| `ax build` | 編譯一次，顯示花了幾秒。只有成功才更新 `main.pdf`；失敗時印出第一個錯誤的檔案、行號和那一行，附上白話提示，保留舊 PDF |
| `ax watch` | 存檔就重編，每次成功或失敗都會說；有 Skim 就用 Skim 開 |
| `ax open` | 用系統預設的閱讀器打開 PDF；`--solutions` 打開解答 |
| `ax both` | 作業／考卷：`main.pdf`（題目）和 `main-solutions.pdf`（解答） |
| `ax doctor` | 檢查工具、字型、模板安裝和版本，最後列出有問題的項目和修法 |
| `ax upgrade` | 把專案換到最新的模板版本，順便更新 `latexmkrc` 和編輯器設定 |
| `ax freeze` | 把模板檔複製進專案，從此不依賴這個 repo |
| `ax pack` | 打包成 `<資料夾名>-overleaf.zip`，告訴你上傳後要選哪個編譯器 |
| `ax config` | 設定資料夾、`config.json`、preamble、模板快取各在哪裡 |
| `ax completion zsh\|bash\|powershell` | 印出 Tab 補全腳本；裝法見 `ax completion --help` |
| `ax selftest` | 重編所有範例、建立並編譯每種專案（改模板後用，見〈維護這套模板〉） |
| `ax --version` | 目前最新的模板版本 |

`ax build` 失敗時的樣子：

```
✗ 編譯失敗：main.tex
  ./main.tex:10：Missing $ inserted.
    l.10 x_
           1 不在數學模式
  提示：數學符號（_、^、\alpha 等）要放在 $...$ 裡
  上一份 main.pdf 保留著，沒有被覆蓋
  完整紀錄：build/main.log
```

`l.10` 那兩行是原始碼第 10 行，斷開的地方就是出錯的位置。

`ax build` 還會處理幾種常見狀況：

- latexmk 記住上一次的失敗而不肯重跑時，自動清掉重試一次。
- 編譯超過 10 分鐘（通常是在等輸入）就停止。
- 打錯指令、文件種類或選項值時，猜你想打什麼，例如 `ax biuld` → `ax build`。
- 輸出導到檔案或設定了 `NO_COLOR` 時，不加顏色和轉圈動畫。

## 版本固定

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

## 不用 ax 直接用模板

模板就是普通的 LaTeX class，任何資料夾都能直接用：

```latex
\documentclass[lang=zh]{akizumi-note}
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

可用的 class：`akizumi-hw`、`akizumi-note`、`akizumi-exam`、`akizumi-book`；簡報是 `\documentclass[aspectratio=169]{beamer}` 加 `\usetheme{Akizumi}`。

投稿會議論文時，會議會要求用它自己的模板，外觀不能改。這時只載入數學巨集：

```latex
\usepackage{akizumi-math}    % \vb、\norm、\E、\argmin……；pdfLaTeX 也能用
```

`ax new paper` 建出來的就是這種設定。

## 外觀規則

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

**其他指令**：`\akizumisep`（「A · B」的分隔點，前面不要留空格）、`\akizumirule`（細線）、表格欄型 `Y`（自動換行的左對齊欄）。

## 維護這套模板

```
akizumi-math.sty        數學巨集（引擎無關）
akizumi-core.sty        共用核心：字型、配色、定理、程式碼、版面、參考文獻
akizumi-hw.cls          作業
akizumi-note.cls        講義
akizumi-exam.cls        考卷（基於 exam）
akizumi-book.cls        論文、書
beamerthemeAkizumi.sty  簡報
skeletons/            ax new 用的內文骨架
examples/             每種文件的完整範例，兼當測試
bin/                  ax（ax.cmd 給 Windows）、akizumi-both、biber 修正（macOS）
install.py            安裝（三個系統共用）
.github/workflows/    在 Linux、Windows 上自動測試
```

改完模板後：

```sh
ax selftest             # 重編 examples/ 的所有範例，再用 ax 建立並編譯每一種專案
ax selftest examples    # 只重編範例（同 make check）
ax selftest projects    # 只測 ax 專案（同 make test-ax）
```

Linux 與 Windows 的測試在 GitHub Actions 上跑：推送版本 tag 時自動執行，也可以手動 `gh workflow run test`，結果在 repo 的 Actions 頁面。

發佈新版本（讓新專案用上、舊專案可以 `ax upgrade`）：

1. 更新 `CHANGELOG.md`。
2. 把各檔 `\ProvidesPackage` / `\ProvidesClass` 裡的版本號改掉。
3. `ax selftest`。
4. `git commit`，然後 `git tag -a v0.8 -m v0.8 && git push && git push --tags`（推 tag 會觸發 Linux、Windows 測試）。

沒有打 tag 的修改只影響 `examples/` 和直接用模板的文件，不會影響已經固定版本的專案。

## 疑難排解

**`ax doctor` 說 biber 有問題，或參考文獻全是問號（macOS）**
TeX Live 2026 的 biber 啟動時呼叫 `lipo -extract_family`，新版 Command Line Tools 已經移除這個參數，錯誤訊息是 `extracting arm64 binary with lipo failed`。`install.py` 偵測到時會把 `bin/biber` 連到 `~/bin/biber`：它用 `lipo -thin` 取出本機架構的版本執行，TeX Live 更新 biber 時會自動重新取出。biber 2.22 起已經修好（2026-10 在 GitHub Actions 的 macOS 上確認過）：執行 `sudo tlmgr update --self && sudo tlmgr update biber`，確認 `/Library/TeX/texbin/biber --version` 正常後刪掉 `~/bin/biber` 即可，之後重跑 `install.py` 也不會再連回來。Linux、Windows 沒有這個問題。

**改了模板，專案的 PDF 沒變**
專案固定在舊版本（見〈版本固定〉）。跑 `ax upgrade`；或者模板的修改還沒打 tag。

**換到另一台電腦，中文字型不一樣**
每個系統用找得到的第一個字型：

| 用途 | 依序嘗試 |
|---|---|
| 無襯線（標題、標籤、簡報） | 蘋方（macOS）→ Noto Sans CJK TC → 微軟正黑體（Windows）→ Fandol |
| 襯線（內文） | 宋體（macOS）→ Noto Serif CJK TC → 細明體（Windows，粗體借用正黑體）→ Fandol |

新版 macOS 的蘋方是用到時才下載的字型，全新的電腦上可能還沒有；在「字體簿」裡下載「PingFang TC」即可，沒下載時會自動改用後面的字型。

Fandol 一定有（TeX Live 內建），但主要是簡體字型，用到它時 log 會警告，部分繁體字可能缺字。想在各系統看起來一致，就在每台電腦裝 [Noto CJK](https://github.com/notofonts/noto-cjk)（Linux：`fonts-noto-cjk`）。

**編譯時出現 `XeTeX is required to compile this document.`**
用了 pdfLaTeX。終端機請用 `ax build` 或 `latexmk`（會讀 `latexmkrc`）；編輯器設定見 README〈在 Cursor 裡寫〉。

**`ax` 找不到**
先開一個新的終端機（`install.py` 改的 PATH 只對新視窗生效）。還是找不到的話：macOS 把 `~/bin`、Linux 把 `~/.local/bin` 加進 `PATH`（`~/.zshrc` 或 `~/.bashrc` 加 `export PATH="$HOME/bin:$PATH"`）；Windows 重新執行 `py install.py`。

**Windows：`ax build` 說 PDF 被鎖住**
有些閱讀器（例如 Acrobat）開著 PDF 時會鎖住檔案，`ax` 換不掉它，新的 PDF 會留在 `build/main.pdf`。改用不鎖檔的閱讀器（SumatraPDF、Cursor 內建預覽）即可。

**其他錯誤**
先跑 `ax doctor`。完整的編譯紀錄在 `build/main.log`。

---

版本紀錄見 [`CHANGELOG.md`](CHANGELOG.md)。
