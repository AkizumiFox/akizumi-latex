# akizumi-latex 參考手冊

English: [reference.en.md](reference.en.md)

[README](../README.md) 是入門；這裡是完整的功能與選項，需要時再查。完整的範例在 [`examples/`](../examples/)；一頁頁對照原始碼和結果的速查表是 [`examples/cheatsheet.pdf`](../examples/cheatsheet.pdf)。

## ax new 的選項與專案內容

不給參數直接打 `ax new`，會用選單問你種類、資料夾和標題。選項：

| 選項 | 意思 |
|---|---|
| `--title` | 標題（作業不需要，會自動寫成「作業 N」） |
| `--author` | 作者，預設取自 `config.json` |
| `--course` | 課名；作業、講義、考卷放在頁首和標題上方，書和簡報放在標題上方 |
| `--number` `--due` `--id` | 作業編號、繳交期限、學號 |
| `--lang en\|zh\|ja\|ko` | 主語言，預設取自 `config.json` |
| `--thmnames english\|native` | 定理和各種標籤用英文（Theorem、Figure、Section）或主語言（定理、圖、節），預設取自 `config.json` |
| `--text serif\|sans\|times\|palatino` `--paper a4\|letter\|pad` `--layout normal\|margin` | 見〈文件選項〉 |
| `--bib` | 加上 `refs.bib` 和參考文獻 |
| `--code minted` | 用 minted 上色：加上 `code=minted`（見〈用 minted 上色〉）。TeX Live 2024 以前的 TeX 要完整的 shell escape，這時 ax 會在 `.ax.json` 寫 `"shell_escape": true`，`ax build`、`ax watch` 和 latexmkrc 都會加 `-shell-escape`；主檔裡有 `code=minted` 或載入 minted 時，`ax build` 也會自動加 |
| `--progress` | 簡報底部的進度條 |
| `--venue neurips\|icml\|iclr\|aaai\|plain` | 投稿論文的會議（預設 `plain`），見〈投稿論文〉 |
| `--split` | 投稿論文：每一節放在 `sections/` 裡的獨立檔案 |
| `--anonymous` `--no-anonymous` | 投稿論文：匿名投稿版或署名版；會議預設匿名，`plain` 預設署名 |
| `--git` | 建立 git repo 並做第一個 commit |
| `--no-preamble` | 這次不加入你的 `preamble.tex`、`preamble-種類.tex`（見 README〈自訂 preamble〉） |
| `--pin v0.9` | 指定模板版本；預設是最新的 tag。`--pin latest` 表示永遠用安裝的最新檔案（改模板時測試用） |
| `--problems 5` 或 `--problems B4,C2` | 作業：建立 `problems/p1.tex`…`p5.tex`（分組時是 `B1`…`B4`、`C1`、`C2`），`main.tex` 用 `\inputproblem` 逐題載入 |
| `--force` | 資料夾已存在且不是空的也照樣建立 |

`config.json` 的 `defaults` 可以替每種文件設預設選項，命令列給的優先。例如 `"hw": {"titleinfo": "line"}` 讓新作業把作者和日期排成標題下的一行；`"paper": {"venue": "neurips", "split": true}` 讓新論文預設投 NeurIPS、分節存檔。

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

可用的環境：`theorem` `lemma` `proposition` `corollary` `claim` `definition` `assumption` `example` `remark` `proof`，每一種都有不編號的版本（`theorem*` 等）。每個環境左側都有一條細線標出起訖；名稱預設用英文（Theorem、Proof），不論文件主語言；`thmnames=native` 改用主語言（見〈交叉引用〉）。

定理可以在附錄重述並證明：

```latex
\begin{restatable}{theorem}{cramerwold}\label{thm:cw} ... \end{restatable}

% 附錄
\cramerwold*                              % 同一個編號、同一段文字
\begin{proofof}{thm:cw} ... \end{proofof} % 「Proof of Theorem 1.2.」並連回原處
```

`\listoftheorems` 列出所有定理類環境（重述的不會重複列）。

#### 更多定理類環境、編號方式

另外還有 `axiom`（公理）、`conjecture`（猜想）、`property`（性質）、`conclusion`（結論）、`remarks`（註，複數）、`notationthm`（記號），以及 `problem`（問題），同樣都有不編號的 `*` 版本。`notation` 已經是符號表，所以定理型的「記號」叫做 `notationthm`；作業（akizumi-hw）的 `problem` 是題目標題，所以作業裡不會定義定理型的 `problem`。如果文件自己 `\newtheorem`（或 `\declaretheorem`）了其中某個名稱，例如 `\newtheorem{conjecture}[theorem]{Conjecture}`，就以文件的定義為準，舊文件照常編譯。

編號用 `\documentclass` 選項調整：

| 選項 | 值 | 預設 | 作用 |
|---|---|---|---|
| `thmcounter` | `shared` `grouped` `split` | `shared` | `shared`：所有種類共用一個編號；`grouped`：定理類（theorem、lemma…）、定義類（definition、assumption、axiom、notationthm、problem）、附註類（example、remark、remarks）各自編號；`split`：每一種各自編號 |
| `thmwithin` | `chapter` `section` `none` | 講義 `section`，書 `chapter`，其他 `none` | 編號前面加上章或節號；`chapter` 只在書裡有效 |
| `asides` | `numbered` `unnumbered` | `numbered` | `unnumbered`：example、remark、remarks 不編號 |
| `aliases` | `none` `short` | `none` | `short`：另外提供 `thm` `lem` `prop` `cor` `defn` `conj` `exam` `rem` `prob` 等短名稱，名稱和編號都跟完整的環境一樣 |
| `thmname` | `{種類=名稱, …}` | | 換掉某一種的名稱，例如 `thmname={corollary=系理}` |

名稱也能在導言區改：`\akizumisetup{thmname/corollary=系理}` 或 `\akizumisetup{thmname={corollary=系理, remark=備註}}`。`proof`、`solution` 也可以這樣改。改過的名稱在 `\cref` 裡不分單複數。

手動指定編號（抄書時常用），`\label`／`\cref` 照常運作，之後的自動編號不受影響：

```latex
\begin{theorem}[number=3.2]\label{thm:rudin-3-2} ... \end{theorem}
\begin{theorem}[number=3.2, note=Cram\'er--Wold] ... \end{theorem}
```

自己定義新的定理類環境：

```latex
% \akizumiNewTheorem{環境}{英文}{中文}{日文}{韓文}[選項]，留空的名稱用英文
\akizumiNewTheorem{tool}{Tool}{工具}{道具}{도구}[counter=own, prefix=T, within=none]  % T1, T2, ...
\akizumiNewTheorem{unit}{Unit}{}{}{}[style=definition]
```

選項：`style=theorem|definition|remark`（線條和標籤樣式，預設 `theorem`）、`bar=1pt`、`barcolor=mute`、`counter=own|<另一種>`（預設依 `thmcounter`）、`prefix=T`、`within=chapter|section|none`、`plural=Tools`（`\cref` 的英文複數，預設加 s）。名稱跟 `thmnames` 走：預設英文，`thmnames=native` 用主語言。

調整已有種類的編號：

```latex
\akizumiSetTheorem{assumption}{counter=own, prefix=A, within=none}  % A1, A2, ...
```

### 提示框

讀書輔助用的框，外觀和定理一樣是左側細線，可跨頁，文件和簡報都能用：

```latex
\begin{chapterguide}
\guidehead{本章在談什麼}  ...
\guidehead{先備知識}      ...
\end{chapterguide}

\begin{keyidea} 級數收斂，就是尾巴越來越小。 \end{keyidea}
\begin{proofidea} 先用比較法，再用 Cauchy 準則。 \end{proofidea}
\begin{proof} ... \end{proof}

\begin{tip}[根值判別法] ... \end{tip}
\begin{warning} ... \end{warning}      % pitfall 同樣式，標籤是「常見錯誤」
\begin{note} ... \end{note}
\begin{setup} 設 $(a_n)$ 為實數數列。 \end{setup}   % 沒有標籤的淡灰底框
```

| 環境 | 標籤（en / zh） | 樣式 |
|---|---|---|
| keyidea | Key idea / 重點 | 粗藍線、淡藍底 |
| proofidea | Idea of the proof / 證明思路 | 細灰線、灰色標籤 |
| tip | Tip / 提示 | 細淡藍線 |
| warning、pitfall | Warning / 注意、Pitfall / 常見錯誤 | 粗橘線、橘色標籤 |
| note | Note / 附註 | 細灰線、黑色標籤 |
| chapterguide | Chapter guide / 本章導覽（講義、投影片：Guide / 導覽） | 標籤獨立一行、淡藍底；`\guidehead{...}` 是框內小標 |
| setup | （無） | 淡灰底；給了 `[標題]` 就只顯示標題 |

`[...]` 是標題，接在名稱後面，和定理一樣。名稱跟著 `lang=`（日文、韓文也有）；`proofidea` 例外，跟著 `thmnames=`，才會和後面的 Proof 一致。中文名稱後面不加句點。這些環境預設不編號。

**自訂一種**：`\akizumiNewCallout{名稱}{英文}{中文}{日文}{韓文}[選項]`，空白的語言沿用英文：

```latex
\akizumiNewCallout{keypoint}{Key point}{學習要點}{}{}[numbered=chapter, tint]
\begin{keypoint}\label{kp:import} ... \end{keypoint}   % 學習要點 3.1，\cref 可引用
```

選項：

| 選項 | 值 | 說明 |
|---|---|---|
| `numbered` | `false`、`true`、計數器名 | `true` 全文流水號；`chapter`、`section` 等表示每章（節）重編，顯示成 3.1 |
| `tint` | `false`、`true`、顏色 | 淡底色；`true` 用線的顏色 7% |
| `bar` | 長度 | 線寬，預設 `1pt` |
| `color` | 顏色 | 線的顏色，預設 `accentsoft` |
| `labelcolor` | 顏色 | 標籤顏色，預設 `accent` |
| `head` | `inline`、`block` | 標籤接在內文前，或自成一行 |
| `thmname` | `false`、`true` | `true` 時名稱跟著 `thmnames=` |
| `plural` | 文字 | `\cref` 的英文複數，預設英文名稱加 s |

`\akizumiCalloutSetup{keyidea}{numbered=chapter}` 修改現成或自訂的框，例如讓 keyidea 按章編號。

**選讀標記**：`\optional` 在標題前加一顆灰色星號，目錄和 PDF 書籤裡也會顯示（書籤裡是 ★）：

```latex
\section{\optional Arzelà–Ascoli 定理}
\begin{remark}[\optional 複數高斯積分] ... \end{remark}
```

舊文件不受影響：導言區自己定義過的 `keyidea`、`\pitfall`、`\optional`、`\guidehead` 等名稱優先，現成的版本就不定義（簡報裡 `note` 是 beamer 的 `\note`，所以簡報沒有 `note` 框）。

### 數學

數學裡的大寫字母一律是正體粗體（矩陣）：寫 `A` 就是 $\vb{A}$，不必每次寫 `\vb{A}`。`\mathcal{A}`、`\mathbb{R}`、`\mathrm{A}` 照常換字型，小寫和希臘字母不變，簡報也一樣。個別不是矩陣的大寫（$Y(s)$、$C^1$、算子 $D$）寫 `\mathnormal{Y}`：一般的數學斜體，間距正確（`\mathit` 是文字斜體，上標會貼太近）。`x'\T` 這種撇號接轉置可以直接寫。`matrices=all` 讓 Σ、Λ 這些希臘大寫也變粗體；`matrices=normal` 回到一般的斜體大寫（例如集合、隨機變數用大寫的文件）。單獨用 `\usepackage{akizumi-math}`（投稿論文）時預設是 `normal`。

| 寫法 | 結果 |
|---|---|
| `\vb{x}`、`\vb{A}` | 向量、矩陣用正體粗體；希臘字母自動改用粗斜體／粗正體（`vb=upright` 讓小寫希臘字母也是正體）。`\bvec` 是同一個指令 |
| `\vb{x}\T` | 轉置 |
| `\norm{x}`、`\abs{x}`、`\inner{x, y}`、`\set{x}`、`\floor{x}`、`\ceil{x}` | 配對括號；加星號 `\norm*{...}` 自動調整大小，`\norm[\big]{...}` 指定大小 |
| `\set{x \given x > 0}`、`\Prob{A \given B}` | `\given` 是有間距的 \|，在 `\set`、`\Prob` 裡會跟著括號變大 |
| `\E`、`\Var`、`\Cov`、`\Corr`、`\KL`、`\sg` | 期望值、變異數等運算子 |
| `\tr`、`\rank`、`\diag`、`\spn`、`\nullity`、`\im`、`\adj`、`\col`、`\row`、`\nul`、`\id` | 線性代數（`\spn` 印出 span） |
| `\supp`、`\vol`、`\Bd`、`\Int`、`\diam`、`\lcm` | 分析、拓撲、數論 |
| `\argmin`、`\argmax`、`\plim` | 下標放在正下方 |
| `\Prob{A}`、`\Normal{\mu}{\sigma^2}`、`\Bern{p}`、`\Bin{n}{p}`、`\Pois{\lambda}`、`\Geom{p}`、`\Unif{a}{b}` | 機率與分布，括號規則同上 |
| `X \indep Y`、`X_i \iid F` | 獨立、獨立同分布 |
| `\R`、`\N`、`\Z`、`\Q`、`\C`、`\mathbb{1}` | 黑板粗體（bboldx，含數字和小寫） |
| `\mathscr{F}` | 花體（RSFS） |
| `\mathbbm{1}`、`\mathbbmss{R}` | bbm 的寫法照樣能編譯，印成 `\mathbb`（不用 bbm 的點陣字型） |
| `\cvec{1, 2, 3}`、`\cvec[p]{a, b}` | 行向量；方括號，`[p]` 改圓括號（也可 `v`、`V`、`B`） |
| `\int f(x) \dd x` | 正體的 d |

數學模式裡可以直接寫中文，例如 `$x_{最大}$`。

**和自己的巨集共存。** 上面每個名稱都只在還沒有人定義時才提供。之後在 preamble 用 `\newcommand`、`\DeclareMathOperator` 或 `\DeclarePairedDelimiter` 定義同名巨集，不會報「already defined」，而是改用你的定義；`\def`、`\renewcommand` 本來就會蓋掉。所以舊的 shortcuts 檔、ICLR／NeurIPS 的 `math_commands.tex` 可以直接 `\input`。想保留 LaTeX 原本的報錯，加 `mathclash=error`。想讓某些名稱完全不定義，用 `mathskip={vb, E}`。`ax doctor` 會列出專案裡重新定義了哪些 akizumi-math 巨集，以及哪些檔案用單字母 `\def` 蓋掉了 `\c`、`\v` 這類重音指令。`\NewDocumentCommand` 不在此列，請改用 `\RenewDocumentCommand`。

**字母捷徑（要開才有）。** 用 `letters=` 選擇，可以多選，例如 `letters={bold, cal}`：

| 值 | 提供 |
|---|---|
| `bold` | `\va`…`\vz`、`\vA`…`\vZ`、`\vzero`、`\vone`，即 `\vb{a}` 等。單獨寫 `\vb`（後面沒有大括號）是粗體 b |
| `cal` | `\sA`…`\sZ`，即 `\mathcal{A}` 等 |
| `bb` | `\nA`…`\nZ`，即 `\mathbb{A}` 等 |
| `greek` | `\valpha`…`\vomega`、`\vGamma`…`\vOmega`，即 `\vb{\alpha}` 等 |
| `all` | 以上四組 |
| `single` | `\a`…`\z` 在數學裡是粗體；在內文裡 `\c{c}`、`\v{s}`、`\d{h}`、`\i`、`\o` 照舊是重音和特殊字母。大寫單字母不提供，因為 `\R`、`\E`、`\T` 已經有用途 |

已經存在的名稱不會被覆蓋。

### 交叉引用

一律用 `\cref`，它會自動帶出名稱：

```latex
見\cref{thm:cw}、\cref{def:collapse}、\cref{eq:loss}。
```

引用預設一律是英文，不論文件主語言：「Theorem 1.2」「Figure 1」「Equation (1.1)」「Section 2」「Appendix A」。只有作業和考卷的題號跟著語言（第 1 題、問 1、문제 1）。加 `thmnames=native` 時改用主語言：

| | 章節 | 圖 | 公式 | 題目 |
|---|---|---|---|---|
| `lang=zh` | 第 1 節 | 圖 1 | 式 (1.1) | 第 1 題 |
| `lang=ja` | 第 1 節 | 図 1 | 式 (1.1) | 問 1 |
| `lang=ko` | 제1절 | 그림 1 | 식 (1.1) | 문제 1 |

定理名稱在 `thmnames=native` 時：

| | theorem | lemma | corollary | remark | proof | solution |
|---|---|---|---|---|---|---|
| `zh` | 定理 | 引理 | 推論 | 註 | 證明 | 解 |
| `ja` | 定理 | 補題 | 系 | 注意 | 証明 | 解答 |
| `ko` | 정리 | 보조정리 | 따름정리 | 참고 | 증명 | 풀이 |

`proofof` 跟著變成「定理 1.2 的證明」「定理 1.2 の証明」「정리 1.2의 증명」。

### 參考文獻

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

#### 編號、標籤和程式碼列表

```latex
\begin{codeblock}[numbered, label=lst:fit, title=fit.py, lang=python]
...
\end{codeblock}
見 \cref{lst:fit}。     % 「Listing 1.2」；lang=zh 時是「程式碼 1.2」

\begin{code}[label=lst:loop]{python}{走訪串列}   % 一定編號，舊寫法相容
for x in xs: ...
\end{code}

\listofcodes             % 所有編號過的程式碼，標題是「程式碼列表」
```

`numbered`、`label=…`、`kind=…` 任一個都會讓區塊編號，標題列左邊印出種類和號碼，右邊接 `title`，並列入 `\listofcodes`。書依章編號，講義依節編號，其他文件從 1 開始。沒加這些選項的區塊跟以前一樣。

自訂種類：

```latex
\akizumiNewCodeKind[env=example, counter=code]{example}{Example}{範例}
\akizumiNewCodeKind[env=code]{idiom}{Idiom}{片語}   % \begin{code} 改成「片語 N」
```

選項：`counter=<種類>` 和該種類共用號碼；`within=chapter|section|none`；`env=<名稱>` 另外定義 `\begin{名稱}[選項]{語言}{標題}`（同名的定理環境，例如 `example`，會被取代）；`ja=`、`ko=` 日韓文名稱（預設分別用中文、英文）；`plural=` 英文複數（預設加 s，給 `\cref` 用）。內建種類叫 `code`。

#### 行範圍、搜尋路徑、程式輸出

```latex
\codedir{src/, code/}                        % \inputcode 找不到檔案時依序找這些資料夾
\inputcode[lang=cpp, lines=10-24]{main.cpp}  % 只印第 10–24 行，行號照原檔（10–24）
\inputcode[output, title=輸出]{run.txt}       % 程式輸出：白底細框、無行號、不上色
```

`output` 在 `codeblock` 也能用。

#### 終端機和輸入輸出範例

```latex
% 以「$ 」「>>> 」「... 」「# 」開頭的行用正文顏色，其他行（輸出）用灰色
\begin{terminal}[title=zsh]
$ python main.py
3
\end{terminal}

\iosample{1 2 \\ 3 4}{3 \\ 7}   % 左「輸入」右「輸出」，寬度縮到內容大小
\iosample{}{[89.2, 74.8] \\}     % 一邊留空就只印另一邊
```

`\iosample` 的兩個參數是一般文字，每行用 `\\` 分開；`\\` 後面直接接 `[` 也沒問題。框上的標題可以換：`\iosample[input=input.txt, output=\$\ ./a.out]{…}{…}`，整份文件則用 `\akizumisetup{iosample/input=…, iosample/output=…}`。

#### 行內程式碼

```latex
\code{x_1 % #}                    % 原樣印出，括號要成對
\code|a{b|                        % 跟 \verb 一樣換分隔符
\code[cpp]{std::vector<int> v;}   % 指定語言就上色
\section{The \code{a\_b} function}
\begin{theorem}[\code{sort} 是穩定的] ... \end{theorem}
```

`\code` 可以放在別的指令的參數裡（章節標題、定理名稱、註腳、簡報的一般 frame）。這時 TeX 已經先讀過內容，所以 `%`、`#` 要寫成 `\%`、`\#`，`_` `&` `$` `{` `}` 也可以寫成 `\_` 等，印出來都是字元本身。頁首、目錄、PDF 書籤也正常。

#### 用 minted 上色

預設用 listings 上色。要 Pygments 的顏色和語言，就在 `\documentclass` 加 `code=minted`（簡報寫在 `\usetheme[code=minted]{Akizumi}`；新專案用 `ax new --code minted`）。`codeblock`、`\inputcode`、`\code`、`terminal` 的寫法完全一樣，不用改內文。

TeX Live 2024 起內附的 `latexminted` 在預設的受限 shell escape 下就能跑，不用 `-shell-escape`。更舊的 TeX 要完整的 shell escape：ax 會自動加，直接用 latexmk 時加 `-shell-escape`。找不到 Pygments，或用 `-no-shell-escape` 編譯時，會警告並改用 listings，文件照樣編得出來。

#### 語言

`lang=` 和 `\code[…]` 的語言名稱不分大小寫，兩種引擎的名字都認得：`cpp` 和 `C++`、`py` 和 `Python`、`hs` 和 `Haskell`、`sh` 和 `bash`、`tex` 都可以。listings 內建 Haskell、SQL，模板另外加了 `Agda`（Unicode 符號照印）、`Datalog`（`#`、`//` 註解，`:-` 上色）、`Stata`（`*` 行首註解、`//`、`/* */`）。

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

### 索引、符號列表

`\documentclass[index=true]{akizumi-book}`（講義、作業、考卷也可以）打開書末索引和附頁碼的符號列表。沒開的時候 `\index` 什麼都不做，所以可以先標著；`\printindex`、`\nota`、`\printnotation` 則會停下來，提醒你加 `index=true`。

<!-- snippet: options=index=true -->
```latex
\index{分割}  \index{分割!網目}  \index{Riemann sum}  \index{sum@$\Sigma$-notation}
\index{網目|see{分割}}
\nota{$\norm{x}$}{$x\in\R^n$ 的歐氏範數}   % 放在符號第一次定義的地方
...
\printnotation   % 符號表，可以放在目錄後面
\printindex      % 索引，雙欄，新的一頁
```

- 索引用 imakeidx：雙欄、列進目錄，標題依 `lang` 是「Index／索引／索引／색인」。`!` 分子項目、`@` 前面是排序用的字、`|see{...}` 是參見，跟 makeindex 一樣。頁碼可以點。
- `\nota{符號}{意義}` 不印任何東西，只記下這一頁；`\printnotation` 依出現順序列出「符號／意義／頁碼」，外觀跟 `notation` 表格一樣（書裡是一章，其他類別是一節，不換頁）。內容裡的 `! @ | "` 會自動跳脫，可以直接寫。preamble 自己定義了 `\nota` 或 `\printnotation` 的話，用你的。
- 多份索引：在 preamble 寫 `\akizumiNewIndex{persons}{人名索引}`，內文 `\index[persons]{高斯}`，最後 `\printindex[persons]`。可選參數直接傳給 imakeidx，例如 `\akizumiNewIndex[columns=3]{...}{...}`。
- 索引器由 latexmk 跑，所以 `ax build`、`ax watch`、Cursor 都會自動產生索引（ax 寫的 `latexmkrc` 裡有設定；舊專案跑一次 `ax upgrade` 更新 latexmkrc）。有 upmendex 就用它，中文依 `index-sort` 排序（預設筆畫，和繁體中文辭典一樣；也可以 `zhuyin`、`pinyin`、`radical`），日文、韓文用該語言的排序；沒有 upmendex 才退回 makeindex，中文只能照字碼排。`ax doctor` 會顯示有沒有 upmendex（TeX Live 套件 `upmendex`）。
- 日文漢字的讀音 upmendex 不知道，要寫成 `\index{せきぶん@積分}`。
- 不用 latexmk 時要自己跑：`upmendex -s build/main.ist build/main.idx`（符號表是 `main-notation.idx`）。

### 邏輯與程式語言符號

要另外載入：`\usepackage{akizumi-logic}`。不載入的文件完全不受影響。也可以在 pdfLaTeX 的一般文件裡用（顏色和英文字樣會自己補上）。

```latex
\usepackage[connectives=classic]{akizumi-logic}

\begin{fitch}                               % Fitch 證明（fitch 套件），等於 \[ \begin{nd} ... \end{nd} \]
  \hypo{1}{A \limp B}   \by{\RulePremise}{}
  \open
  \hypo{2}{A}           \by{\RuleA[\RuleImpI]}{}   % A / →I
  \have{3}{B}           \by{\RuleImpE}{1,2}        % 1, 2 →E
  \close
  \have{4}{A \limp B}   \by{\RuleImpI}{2-3}
\end{fitch}

\begin{prooftree}                           % 推論規則（ebproof）
  \hypo{\Gamma \vdash t : \sigma \limp \tau} \hypo{\Gamma \vdash s : \sigma}
  \infer2[app]{\Gamma \vdash t\,s : \tau}
\end{prooftree}

\begin{truthtable}{cc|ccc}                  % 真值表，格子都是數學模式
  A & B & A & \main{\land} & B \\ \midrule
  \tvrow{TT|T!TT}                           % 一個字一格；| 和空白略過，- 是空格，! 標主連接詞
\end{truthtable}

\begin{calc}                                % 演算式推導，可以跨頁
  \fn{sum}\;[1,2]
  \step{=}{def.\ of $\fn{sum}$}             % 提示放在 { } 裡、獨立一行
  1 + \fn{sum}\;[2]
  \step{=}{}                                % 提示留空：關係符號接在下一個式子前
  3
\end{calc}

\begin{funcdef}                             % 函數定義：兩欄，靠左
  \fn{zip} &: \fn{List}\;a \to \fn{List}\;b \to \fn{List}\;(a, b) \\
  \fn{zip}\;[]\;ys &= []
\end{funcdef}

$\sem{e}\rho$  $\sem*{\frac{a}{b}}$  $\sem[\big]{e}$  % 語意括號 ⟦ ⟧
```

- **連接詞**：`\limp`（蘊含）、`\liff`（雙條件），`\land` `\lor` `\lnot` 也跟著選項走。`connectives=modern`（預設，∧ ∨ ¬ → ↔）、`classic`（& ∨ ~ ⊃ ≡，Bergmann 那類教科書）、`arrows`（∧ ∨ ¬ ⇒ ⇔）。`\implies` 不會被改。
- **規則名稱**：`\RuleAndI` `\RuleAndE` `\RuleOrI` `\RuleOrE` `\RuleImpI` `\RuleImpE` `\RuleIffI` `\RuleIffE` `\RuleNotI` `\RuleNotE` `\RuleBotI` `\RuleBotE` `\RuleDNI` `\RuleDNE` `\RuleAllI` `\RuleAllE` `\RuleExI` `\RuleExE` `\RuleEqI` `\RuleEqE`，可加下標 `\RuleAndE[1]`（∧E₁）。另有 `\RuleR` `\RuleMT` `\RuleRAA` `\RuleLEM`、`\RuleA`（A，`\RuleA[\RuleNotI]` 是「A / ¬I」）、`\RuleAssumption` `\RulePremise`（字跟著 `lang`）。名稱都以 `\Rule` 開頭，不會蓋掉 `\ni`（∋）、`\ne`（≠）、`\r` 這些既有指令。`rulecase=lower` 改成小寫 →i、→e。
- **Fitch 證明**：用 TeX Live 的 `fitch` 套件（`\hypo` `\have` `\open` `\close` `\by`，`ndresume` 接續上一段）。範圍線、行號和理由是灰色，理由字小一號。`\by{規則}{行號}` 預設排成「1, 2 →E」；`just=rule-first` 排成「→E, 1, 2」。fitch 自己的短指令（`\ii` `\ne` `\r` ⋯）預設不裝，要的話加 `fitchrules`。
- **lmodern**：載入 akizumi-logic 後，proofpack 之類會載 lmodern 的套件不會再把內文字型換掉。
- `\rulename{...}` 是規則標籤的樣式（小一號、灰色），ebproof 的標籤自動套用，也可以手動用。
- `\fn{map}` 是無襯線的函數名稱。

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

TikZ 預設只載入 `arrows.meta`、`positioning`、`calc`、`shapes.geometric`。要畫立體圖、角度、大括號、網底、自動機時，在 `\documentclass` 加 `tikz=full`（簡報寫在 `\usetheme[tikz=full]{Akizumi}`），會再載入 `3d`、`angles`、`quotes`、`decorations.pathreplacing`、`decorations.markings`、`patterns`、`fit`、`backgrounds`、`shapes`、`tikzmark`、`automata`、`intersections`。加 `plots` 會載入 pgfplots（`compat=1.18`），線條依序用 `accent`、`warn`、`plotgreen`、`plotpurple`、`mute` 上色，熱圖預設用淡灰到 `accent` 的 colormap，座標軸和格線用淺灰。

```latex
\documentclass[tikz=full, plots]{akizumi-note}
...
\begin{tikzpicture}
\begin{axis}[axis lines=middle, grid=major]
  \addplot+[domain=0:4] {x/(1+x)};   % 第一條自動是 accent 色
\end{axis}
\end{tikzpicture}
```

常見的圖都有現成的樣式，不需要每份文件自己定義：

| 用途 | 樣式 | 說明 |
|---|---|---|
| 陣列 | `akizumi/cell`、`akizumi/hlcell`、`akizumi/hlcell2`、`akizumi/index` | 0.9 cm 的格子，相隔 0.9 cm 擺放時邊線會重疊；`hlcell` 是目前的索引（藍），`hlcell2` 是第二個焦點（橘）；`index` 是格子下方的小灰字 |
| 流程圖 | `akizumi/start`、`akizumi/process`、`akizumi/decision`、`akizumi/io`、`akizumi/group` | 起訖、處理、判斷（菱形）、輸入輸出（平行四邊形）、虛線分組框（配合 `fit` 和 `on background layer`）；箭頭用 `akizumi/arrow` |
| 自動機 | `[akizumi/automaton]`、`akizumi/state`、`akizumi/accepting` | 寫在 `tikzpicture` 的選項上之後，`state`、`accepting`、`initial`、`edge` 都套用這套外觀；`initial`、迴圈邊和 `edge["$a$"]` 需要 `tikz=full` |
| 賽局樹 | `akizumi/game/decision`、`/chance`、`/terminal`、`/branch`、`/action`、`/payoff`、`/infoset` | 決策點（實心）、自然（空心）、終點（小灰點）、分支箭頭、行動標籤、報酬、資訊集（灰色虛線） |
| 物理 | `\pic {akizumi/current in};`、`\pic {akizumi/current out};`、`akizumi/wire` | 流入、流出紙面的電流符號，蓋在導線上；`\pic[accent] at (A) {akizumi/current in};` 可以換顏色 |

<!-- snippet: options=tikz=full -->
```latex
\begin{tikzpicture}[akizumi/automaton]
  \node[state, initial] (q0) {$q_0$};
  \node[state, accepting, right=of q0] (q1) {$q_1$};
  \path[->] (q0) edge["$a$"] (q1) (q1) edge[loop above] node {$b$} ();
\end{tikzpicture}
```

### 多語混排

不需要任何標記。中英文之間要不要打空格都可以，間距會自動處理。`\emph{強調}` 在中日韓文顯示為粗體（沒有斜體），英文仍是斜體。

中文、日文、韓文也可以混在同一份文件：主語言的字型缺的字（例如日文字型沒有的繁體字、中文字型沒有的韓文），自動用另外兩種語言的字型補上。韓文的詞之間照原文保留空格。

### 中文報告

課堂報告、心得、計畫書常用的版面：

<!-- snippet: ci-skip=macos -->
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

### 其他小工具

| 指令 | 作用 |
|---|---|
| `\todo{補推導}` | 橘色的 `[TODO: 補推導]` |
| `\blindfootnote{...}` | 沒有編號的註腳，例如「本講義改編自⋯」 |
| `\sidenote{...}`、`\marginnote{...}` | 邊欄註記（`layout=margin` 時才在邊欄，否則變成一般註腳） |
| `\muted{...}` | 灰色文字 |

### 習題與解答（書、講義）

```latex
\begin{exercise}[標題]\label{ex:union}   % Exercise 3.2（thmnames=native：習題 3.2）
求 $A\cup B$。
\end{exercise}
\begin{solution}                           % 緊接在習題後面
$A\cup B=[-2,3]$。
\end{solution}

\section{Exercises}
\begin{exercises}[title]                   % 節末題目列表；title 印「Exercises」，title=練習 自訂
\label{drills:sets}                        % 第一個 \item 之前的 \label 指向這一節
\item 題目……
  \begin{enumerate} \item 子題 \item 子題 \end{enumerate}   % 自動變成 (a) (b)
  \begin{solution} ... \end{solution}
\item 下一題
\end{exercises}

\begin{example-problem}[title=Two Sum, source=LeetCode 1]   % 例題，出處靠右
...
\end{example-problem}
\printsolutions                            % 把目前收集到的解答印在這裡
```

- `exercise` 有自己的計數器：書按章（3.2）、講義按節、作業和考卷不分（1, 2, …）；`exercisewithin=chapter|section|none` 可改。`exercises` 清單的每一題接續同一個計數器，所以 `\cref` 和解答都對得上。
- `example-problem`（例題）另有計數器；只有標題時可寫 `[最短路徑]`，標題含 `=` 時要寫 `title={...}`。例題後面的 `solution` 一律就地印出。
- `parts`：(a) (b) 子題，和作業的寫法一樣。
- 名稱跟著 `thmnames`：Exercise / 習題 / 演習 / 연습문제，Sample Problem / 例題 / 例題 / 예제。

解答放哪裡由 `solutions` 決定：

| 值 | 效果 |
|---|---|
| `inline`（預設） | 就地印出，左側細線，和作業的解答一樣 |
| `chapter` | 收集起來，在每章結尾（講義是每節結尾）印「Solutions」 |
| `end` | 收集到全書最後，或 `\printsolutions` 所在的位置，按章分組 |
| `hide` | 不印 |

`chapter` 和 `end` 會把解答原文寫到 `build/<檔名>-sol.tex` 再讀回來，所以解答裡可以放 `\verb`、`codeblock`；習題結尾會有「Solution on p. 12」連到解答，解答開頭的「Exercise 3.2」連回習題（頁碼要編兩次，`ax build` 會自動處理）。`true`／`false` 等同 `inline`／`hide`，命令列的 `\def\akizumisolutions{false}` 也有效。

作業和考卷保留原本的 `solution`、`parts`，`solutions=true|false` 照舊；`exercise`、`exercises`、`example-problem` 也能用。

### 作業與考卷專用

<!-- snippet: class=akizumi-hw -->
```latex
\begin{problem}[標題]          % 作業：第 N 題
  \begin{parts} \item ... \item ... \end{parts}   % (a) (b)
  \begin{solution} ... \end{solution}
\end{problem}
```

分組題號與手動題號：

<!-- snippet: class=akizumi-hw -->
```latex
\problemset{B}                          % 之後是 B1、B2…；\problemset{C} 從 C1 重新開始
\begin{problem}[label=B2$'$] ... \end{problem}             % 直接指定題號，不佔用計數
\begin{problem}[label=C3, title=緊緻性] ... \end{problem}   % 題號加標題
```

方括號裡只有 `label=`、`title=` 這兩個鍵時當成選項，其他內容一律當標題，所以 `[$f(x)=x^2$]` 照舊是標題。`\label`、`\cref` 都會顯示 B1、B2′ 這種題號。

一題一個檔：

<!-- snippet: class=akizumi-hw -->
```latex
\inputproblem{problems/p1}              % 等於 \begin{problem}\input{problems/p1}\end{problem}
\inputproblem[柯西數列]{problems/B1}     % 方括號和 problem 的一樣：標題或 label=、title=
```

題目檔裡寫題目和 `solution`，`ax both` 一樣適用。`problembreak=true`（或 `\documentclass[problembreak]{akizumi-hw}`）讓每一題從新的一頁開始，第一題除外。

小題：

<!-- snippet: class=akizumi-hw -->
```latex
\begin{parts}[label=(\roman*)]          % 方括號接 enumitem 的參數；預設 (a) (b)
  \item ...
  \begin{subparts} \item ... \end{subparts}   % (i) (ii)，同樣可加參數
\end{parts}
```

標題與頁首：

| 選項 | 意思 |
|---|---|
| `kind=homework\|assignment\|exercise\|report` | 標題的字：Homework／Assignment／Exercise／Report；中文 作業／作業／習題／報告，日文 課題／課題／演習／レポート，韓文 과제／과제／연습문제／보고서。預設 `homework` |
| `header=author\|name-id` | 內頁頁首右邊：作者（預設），或「作者 · 學號」 |
| `problembreak=true\|false` | 每題換頁，預設 `false` |

這三個是 `\documentclass` 選項，也可以寫在 `\akizumisetup{...}`。頁首其他部分怎麼改見〈頁首與頁尾〉。

考卷用 [exam](https://ctan.org/pkg/exam) 的寫法：`\begin{questions} \question[10] ... \begin{parts} \part[5] ...`，`\gradetable` 產生評分表。

解答開關：作業預設顯示解答，`\documentclass[solutions=false]{akizumi-hw}` 隱藏；考卷預設隱藏，`solutions=true` 顯示。用 `ax both` 就不用手動切換。作業的 `solution` 裡可以放 `verbatim`、`codeblock`。

### 簡報專用

<!-- snippet: beamer -->
```latex
\begin{frame}[plain,noframenumbering]\titlepage\end{frame}
\begin{frame}{討論}\q{這是討論問題嗎？}\end{frame}   % 藍色 Q: 開頭的提問
\standoutframe{Questions?}          % 整頁藍底一句話
\appendix                           % 之後的投影片另外編號，不算進總頁數
\dividerframe{Appendix}
```

每個 `\section` 前會自動插入一頁「Part N」。

### 書專用

<!-- snippet: class=akizumi-book options=bib=refs.bib -->
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

```latex
\documentclass[lang=zh, openright, chaptername={第 * 講}]{akizumi-book}
\title{程式設計}
\subtitle{Programming in C}          % 或 \akizumisetup{subtitle=...}
\akizumisetup{institution={國立臺灣大學}, term={2026 冬季}}
...
\frontmatter \maketitle
\preface                               % 「序言」，列入目錄；\preface[前言] 換標題
...
\tableofcontents
\mainmatter
\part[sub=Foundations]{基礎}
\chapter[sub=Basic Operations]{基本運算}
\chapter[short=遞迴]{遞迴與分治}         % 目錄和頁首用短標題
\paragraph{小標} ...
```

書的版面選項（寫在 `\documentclass[...]`）：

| 選項 | 作用 |
|---|---|
| `twoside` | 雙面：偶數頁頁首左邊是章名、奇數頁右邊是節名；只為了換頁而空出的頁面完全空白 |
| `openright` | 章和部從奇數頁開始（自動是雙面） |
| `partreset` | 每個 `\part` 章號從 1 重新開始 |
| `chaptername=Lecture` | 章標籤寫成「Lecture 3」，`\cref` 也跟著改；有 `*` 時 `*` 是章號的位置，例如 `chaptername={第 * 講}`、`{Episode *}`。附錄照舊 |

- `\chapter[sub=...]{...}`：章名下方的第二語言副標題（灰色、不加粗），不進目錄和頁首。`short=` 是目錄和頁首用的短標題，兩個可以一起寫。方括號裡沒有 `sub=`、`short=` 時跟原本一樣是短標題。`\chapter*` 和 `\part` 也接受 `sub=`。
- `\part`：單獨一頁、置中，灰色「Part II」（中日韓文為「第 2 部分」等）在大標題上方。
- 封面欄位：`subtitle`（標題下方）、`institution` 和 `term`（頁面底部）。都不寫時封面跟以前一樣。
- `\preface[標題]`：不編號的章，列入目錄並設好頁首；預設標題 Preface／序言／まえがき／머리말。
- `\paragraph`、`\subparagraph` 是接在段落開頭的 Lato 粗體小標（`\subparagraph` 為灰色）。
- 目錄的編號欄會自動加寬，像 13.10、12.10.4 這樣的兩位數節號不會擠到標題（多編譯一次生效；一位數節號的書寬度不變）。
#### 每章一個資料夾：`\chapterdir`

長篇講義或書常常每章一個資料夾，圖、程式碼、小節檔都放在裡面。`\chapterdir` 讓那一章的檔名不必每次寫完整路徑：

<!-- snippet: class=akizumi-book -->
```latex
\chapterdir{basic-op}
\include{basic-op/chapter}     % \include 要寫完整路徑（.aux 依路徑命名）
```

之後：

- `\includegraphics{loop}` 依序找 `basic-op/`、`basic-op/figures/`，再找文件原本的 `\graphicspath`；
- `\input{section1}`、`\inputcode{hello.py}`、`\lstinputlisting{...}` 依序找 `basic-op/`、`basic-op/code/`，再找原本的位置；
- `\thechapterdir` 是目前的資料夾名稱（第一次呼叫前是空的）。

子資料夾名稱可以換：`\chapterdir[figures=img, code=ref-codes]{basic-op}`。`\chapterdir{}` 回到只找主資料夾。設定是全域的，寫在章檔案裡面也可以。任何文件類別都能用，不限書。

## 文件選項

寫在 `\documentclass[...]` 裡（簡報寫在 `\usetheme[...]{Akizumi}`）：

| 選項 | 值 | 預設 | 作用 |
|---|---|---|---|
| `lang` | `en` `zh` `ja` `ko` | `en` | 主語言：日期格式、目錄／圖／表名稱、題號、行距、中日韓字型 |
| `text` | `serif` `sans` `times` `palatino` | `serif` | 內文字型。`serif` 用 New Computer Modern（和數學同一套設計），`sans` 整份用 Lato，`times`、`palatino` 用 TeX Gyre Termes／Pagella（數學仍是 Computer Modern）。標題、標籤一律 Lato |
| `bb` | `light` `regular` `ams` | `light` | 黑板粗體的粗細；`ams` 是傳統 AMS 字型（只有大寫） |
| `paper` | `a4` `letter` `pad` | `a4` | 紙張；`pad` 是 3:4 的平板閱讀版面 |
| `layout` | `normal` `margin` | `normal` | `margin` 留寬邊欄放 `\sidenote`（講義、書） |
| `thmnames` | `english` `native` | `english` | 名稱和標籤用英文或主語言：定理、證明、解答、習題、提示框，以及引用和標題裡的 Figure、Table、Equation、Section、Chapter、Appendix、Algorithm、Listing、List of Theorems。日期、目錄、參考文獻、題號、評分表一律跟著 `lang`（見〈交叉引用〉） |
| `thmcounter` | `shared` `grouped` `split` | `shared` | 定理類環境共用一個編號、分三類編號，或每種各自編號（見〈定理、定義、證明〉） |
| `thmwithin` | `chapter` `section` `none` | 講義 `section`，書 `chapter`，其他 `none` | 定理編號前面加上章或節號 |
| `asides` | `numbered` `unnumbered` | `numbered` | `unnumbered`：example、remark、remarks 不編號 |
| `aliases` | `none` `short` | `none` | `short`：另外提供 `thm` `lem` `prop` `cor` 等短名稱 |
| `thmname` | `{種類=名稱, …}` | | 換掉某一種的名稱，例如 `thmname={corollary=系理}` |
| `titleinfo` | `row` `line` `none` | `row` | 標題下方的資訊：`row` 一列附小標籤的欄位（課程、作者、學號、日期；作業是繳交期限；`\akizumisetup{info={授課教師=…}}` 加欄位，四欄換行；標籤可以改名：`\akizumisetup{label/author=小組成員, label/id=組別}`，可改的有 `label/course`、`label/author`、`label/id`、`label/date`、`label/due`）；`line` 一行灰字「作者 · 學號 · 日期」；`none` 不印。標題上方的 `kicker=`（例如 `Lecture 9`）以加字距的大寫藍字印出。標題頁沒有頁首。舊的 `byline=true` 等同 `line`。也可以寫在 `\akizumisetup{titleinfo=…}`。欄位太長時會在欄內換行 |
| `bib` | 檔名 | | 載入參考文獻，例如 `bib=refs.bib` |
| `solutions` | `true` `false`；書、講義另有 `inline` `chapter` `end` `hide` | 作業 `true`，考卷 `false`，書和講義 `inline` | 是否印出解答、印在哪裡（見〈習題與解答〉） |
| `exercisewithin` | `chapter` `section` `none` | 書 `chapter`，講義 `section`，其他 `none` | 習題、例題的編號單位 |
| `eqwithin` | `chapter` `section` `none` | 講義 `section`，書 `chapter`，其他 `none` | 方程式的編號單位。只用 `\section*` 的講義寫 `thmwithin=none, eqwithin=none, codewithin=none`，編號就是 (1)、定理 1、Listing 1，不會變成 0.1 |
| `codewithin` | `chapter` `section` `none` | 書 `chapter`，講義 `section`，其他 `none` | 有編號的程式碼區塊的編號單位 |
| `10pt` `11pt` `12pt` `13pt` `14pt`、`fontsize` | 例如 `fontsize=13pt` | `11pt` | 字級。`13pt`、`14pt` 或任意 `fontsize=` 由 scrextend 處理 |
| `cjk`、`cjk-bold` | 字型名稱 | 蘋方 | 換掉中文無襯線字型 |
| `par` | `skip` `indent` | `skip` | 段落。`indent` 每段（含標題後第一段）首行縮排 2 字，段落間不留空白，適合中文報告 |
| `secnum` | `arabic` `zh` | `arabic` | `zh` 章節編號改成「一、」「（一）」「1.」；書的章是「第一章」。定理、公式號碼仍用阿拉伯數字（定理 1.2），`\cref` 寫成「第一節」「一（一）」 |
| `kai` | | | 中文內文改用楷書：Kaiti TC（macOS）> 標楷體 BiauKai（macOS）> DFKai-SB（Windows）> AR PL UKai（Linux）> STKaiti > 文鼎楷書 bkai00mp（TeX Live 中文套件集）> FandolKai（TeX Live 內附，只有簡體字，會出警告）。`text=sans` 也有效，標題仍是蘋方。macOS 的楷體是第一次用到時才下載，全新的電腦第一次編譯會等下載完成；也可以先在「字體簿」下載「楷體-繁」或「標楷體」 |
| `cjk-serif`、`cjk-serif-bold` | 字型名稱 | 宋體 | 換掉襯線內文（`text=serif\|times\|palatino`）的中文字型和粗體，例如 `cjk-serif-bold=Noto Serif CJK TC SemiBold`。只給 `cjk-serif` 或楷書沒有粗體時，粗體用描粗 |
| `delims` | `manual` `auto` | `manual` | `auto` 讓 `\abs`、`\norm`、`\set`、`\Prob` 這些配對括號不加星號就自動調整大小，加星號反而維持原本大小 |
| `letters` | `bold` `cal` `bb` `greek` `all` `single` | 無 | 字母捷徑，見〈數學〉 |
| `matrices` | `latin` `all` `normal` | `latin` | 數學裡的大寫字母：`latin` A–Z 正體粗體；`all` 連希臘大寫；`normal` 一般斜體（見〈數學〉） |
| `vb` | `auto` `upright` | `auto` | `upright` 讓 `\vb{\alpha}` 的小寫希臘字母也是正體粗體（upgreek） |
| `units` | `false` `true` | `false` | 載入 siunitx：`\qty{9.8}{\metre\per\second\squared}`、`\unit{kg}`、`\num{12345}` |
| `mathclash` | `yield` `error` | `yield` | 自己定義和 akizumi-math 同名的巨集時，`yield` 改用你的，`error` 照 LaTeX 原本的方式報錯 |
| `mathskip` | 名稱清單 | | 這些巨集完全不定義，例如 `mathskip={vb, E}` |
| `code` | `listings` `minted` | `listings` | 程式碼上色引擎。`minted` 用 Pygments，顏色更準、語言更多（見〈用 minted 上色〉）；缺了 Pygments 會警告並改用 listings |
| `verbatim` | `plain` `styled` | `plain` | `styled` 讓 `verbatim` 環境也用程式碼的淡灰底和小字 |
| `tikz` | `basic` `full` | `basic` | `full`（只寫 `tikz` 也一樣）多載入 3d、angles、patterns、tikzmark、automata 等 TikZ 函式庫（見〈圖〉） |
| `plots` | `true` `false` | `false` | 載入 pgfplots，配色跟模板一致 |
| `index` | `false` `true` | `false` | 書末索引和符號列表：`\index`、`\nota`、`\printindex`、`\printnotation`（見〈索引、符號列表〉） |
| `index-sort` | `stroke` `zhuyin` `pinyin` `radical` | `stroke` | `lang=zh` 時索引的中文排序（需要 upmendex） |
| `legacy` | `true` `false` | `true` | 讓舊文件的內文照樣編譯（見〈從舊文件搬過來〉）。`false` 關掉 |
| `sharedpreamble` | `true` `false` | `true` | 讀往上找到的 `.akizumi/preamble.tex`（見〈同一門課共用 preamble〉）。`false` 不讀 |

簡報另有 `progress`（底部進度條）；`tikz`、`plots` 在簡報也能用。簡報的數學選項寫在 `\documentclass` 之前：`\PassOptionsToPackage{delims=auto, letters=bold}{akizumi-math}`。

### 頁首與頁尾

頁尾預設只印頁碼；頁首左邊是課名（講義沒有課名時是標題），右邊是目前的節名，書是左章右節、作業是右邊作者。節號用強調色。第一頁（標題頁）不印頁首，課名、作者、日期都在標題下方（見文件選項 `titleinfo`）。太長的節名會在碰到另一邊之前截斷加「…」。

| 選項 | 值 | 預設 | 作用 |
|---|---|---|---|
| `header` | `default` `minimal` `title` `none` | `default` | 頁首樣式：`minimal` 只留左邊；`title` 左標題、右作者；`none` 不要頁首 |
| `footer` | `page` `page-total` `none` | `page` | 頁尾：`3`、`3 / 5`，或不印 |

這兩個寫在 `\documentclass[...]` 或 `\akizumisetup{...}`（考卷只有 `footer`）。每一格也可以自己指定，填關鍵字或任何文字：

```latex
\akizumisetup{
  header/left   = title,               % 左：標題
  header/center = date,                % 中：日期
  header/right  = {Draft · \akizumiPage},  % 右：自己的文字
  footer/center = page-total,          % 頁尾中間：3 / 5
  firstpage     = same,                % 第一頁和其他頁一樣
}
```

| 鍵 | 說明 |
|---|---|
| `header/left` `header/center` `header/right` | 內頁頁首的三格 |
| `footer/left` `footer/center` `footer/right` | 頁尾的三格 |
| `firstpage/left` `firstpage/center` `firstpage/right` | 標題頁的頁首 |
| `firstpage` | `empty`（預設，不印頁首）、`title`（左課名、右作者 · 日期）、`same`（和內頁一樣） |
| `header/number` | `accent`（預設，節號強調色加粗）或 `plain` |
| `headerstyle` `footerstyle` | 字型和顏色，預設 `\sffamily\footnotesize\color{mute}` |

關鍵字：`course` `title` `author` `date` `id` `byline`（作者 · 學號 · 日期）`section` `chapter` `page` `pages`（總頁數）`page-total` `none`。要和文字混在一起時用對應的指令：`\akizumiCourse` `\akizumiTitle` `\akizumiAuthor` `\akizumiDate` `\akizumiID` `\akizumiByline` `\akizumiSection` `\akizumiChapter` `\akizumiPage` `\akizumiPages`。`twoside` 的書左右對調：左邊的格子印在偶數頁、右邊的印在奇數頁。以前的 `headleft=`、`headright=` 照樣能用，等同 `header/left`、`header/right`。

## ax 指令細節

除了 `new`、`doctor`、`config`、`completion`、`migrate`、`docs`、`selftest`，其他指令都在專案資料夾裡執行；在它的子資料夾（例如 `figures/`）裡也可以，`ax` 會像 git 一樣往上找 `.ax.json`。

`ax` 的訊息有中文和英文，跟著系統語言；`config.json` 裡寫 `"ui": "en"` 或 `"ui": "zh"`，或設環境變數 `AX_LANG`，可以改掉。

| 指令 | 作用 |
|---|---|
| `ax` | 在專案裡：顯示種類、模板版本（有新版會提示）、PDF 什麼時候更新的，接著是動作選單（編譯、監看、打開 PDF⋯）。不在專案裡：首頁選單（建立新文件、最近的專案、檢查環境、查文件）。用方向鍵或 j/k 選、Enter 確認、q 離開；輸出不是終端機時（例如接到管線）改印文字版狀態或說明 |
| `ax new` | 建立專案（見〈ax new 的選項〉） |
| `ax build` | 編譯一次，顯示花了幾秒。只有成功才更新 `main.pdf`；失敗時印出第一個錯誤的檔案、行號和那一行，附上白話提示，保留舊 PDF |
| `ax watch` | 存檔就重編，每次成功或失敗都會說；有 Skim 就用 Skim 開 |
| `ax watch --bg` | 在背景監看，終端機馬上還給你；輸出寫到 `build/watch.log`，關掉終端機也繼續跑。同一個專案只會有一個 |
| `ax watch --status` / `--log` / `--stop` | 背景監看有沒有在跑、上次編譯成功或失敗（失敗時附第一個錯誤）／即時看輸出／停止。背景監看在跑時 `ax build`、`ax both` 會提醒兩邊會搶 `build/` |
| `ax open` | 用系統預設的閱讀器打開 PDF；`--solutions` 打開解答 |
| `ax both` | 作業／考卷：`main.pdf`（題目）和 `main-solutions.pdf`（解答） |
| `ax build --chapter N` | 只編第 N 章，輸出 `main-chN.pdf`，`main.pdf` 不動。章號、頁碼和跨章引用沿用上一次完整編譯的結果，所以先跑過一次 `ax build`。`N` 可以是章號、附錄字母（`A`）、`\include` 的檔名或資料夾名；`--chapter 3,5` 一次編兩章，輸出 `main-ch3+5.pdf`。`ax watch --chapter N` 同理 |
| `ax count` | 數字數：英文字數加中日韓字數（中日韓逐字算，韓文也是），不算指令、數學、程式碼、`\label`／`\ref`／`\cite`、註解和前言；會跟著 `\input`／`\include`／`\subfile`（和 `\chapterdir`）走，多個檔案時逐檔列出。`--limit 3000` 超過就提醒 |
| `ax doctor` | 檢查工具、字型、模板安裝和版本，最後列出有問題的項目和修法；也會看有沒有 upmendex（索引的中日韓排序）。在專案裡還會檢查 `prebuild` 用到的程式、用了 `svg` 套件或 `\includesvg` 時的 inkscape（以及有沒有開 `shell_escape`）、專案 `\usepackage` 的套件是否都找得到（不在 TeX Live 裡的，例如 `stata.sty`，要放進專案資料夾），以及重新定義了哪些 akizumi-math 巨集、哪些檔案用單字母 `\def` 蓋掉了重音指令 |
| `ax upgrade` | 把專案換到最新的模板版本，順便更新 `latexmkrc` 和編輯器設定 |
| `ax freeze` | 把模板檔複製進專案，從此不依賴這個 repo |
| `ax pack` | 打包成 `<資料夾名>-overleaf.zip`，告訴你上傳後要選哪個編譯器 |
| `ax config` | 設定資料夾、`config.json`、preamble、模板快取各在哪裡 |
| `ax completion zsh\|bash\|powershell` | 印出 Tab 補全腳本；裝法見 `ax completion --help` |
| `ax migrate 檔案.tex` | 把舊文件轉成 akizumi 的副本 `檔案-akizumi.tex`，原檔不動；列出跟 akizumi 撞名的巨集（見〈從舊文件搬過來〉） |
| `ax selftest` | 重編所有範例、建立並編譯每種專案、編譯手冊裡的片段（改模板後用，見〈維護這套模板〉） |
| `ax docs 主題` | 在這份手冊裡找主題，把最相關的一節印在終端機（標題、內文、表格）。中英文都能查，也可以是選項或巨集：`ax docs 定理`、`ax docs theorem`、`ax docs thmcounter`、`ax docs '\cref'`，一般的說法也行（`ax docs 按節編號`、`ax docs 解答放最後`）；結果依終端機寬度排版；打錯字會自動更正，找不到時列出相近的標題。`--web` 在瀏覽器打開 GitHub 上的手冊並跳到那一節，`--en` 看英文版，`--cheatsheet` 打開速查表 PDF。只打 `ax docs` 用系統預設的程式打開這份檔案 |
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

### 編譯前的步驟和 shell escape：`.ax.json`

```json
{
  "kind": "note", "main": "main.tex", "template": "v0.9",
  "prebuild": ["python scripts/make_figures.py", "stata-mp -b do analysis.do"],
  "shell_escape": true,
  "pdf": "期末報告.pdf"
}
```

- `prebuild`：`ax build`、`ax both`、`ax watch` 編譯前，在專案資料夾依序執行（`ax watch` 只在開始時跑一次，不是每次存檔）。每個步驟交給系統的 shell（macOS／Linux 是 `/bin/sh`，Windows 是 `cmd`），所以可以用 `&&`；也可以寫成清單 `["python", "make.py"]`，不經過 shell。任何一步失敗（結束碼不是 0）就停下來，印出失敗的指令、結束碼和最後幾行輸出，PDF 保留上一份。`--no-prebuild` 跳過這些步驟。`ax doctor` 會檢查步驟用到的程式在不在 PATH 上。
- `shell_escape: true`：讓 LaTeX 可以執行外部程式（`minted`、`svg`、Stata 的 `texdoc` 等）。`ax build`／`both`／`watch` 都會加上 `-shell-escape`；ax 寫的 `latexmkrc` 也會讀這個設定，所以 Cursor／VS Code 直接呼叫 latexmk 時一樣。舊專案的 `latexmkrc` 不認得這個設定，第一次 `ax build` 時會自動更新它。
- `pdf`：輸出的 PDF 檔名，取代 `main.pdf`。`ax build`、`ax watch`（含 `--bg`）把成功的結果複製成這個名字，`ax open` 打開它；`ax both` 的解答是 `期末報告-solutions.pdf`；`ax build --chapter` 照樣是 `main-chN.pdf`。ax 寫的 `latexmkrc` 也會讀它，所以 Cursor 編譯成功後一樣會更新這個檔案（預覽仍然顯示 `build/main.pdf`）。舊專案的 `latexmkrc` 在下一次 `ax build` 時更新。`ax migrate --project` 遇到資料夾裡 git 追蹤的 PDF 跟主檔不同名時（例如 `HW3 報告.pdf`），會自動寫上這一項。

`prebuild` 和 `shell_escape` 都會執行專案裡寫的指令，只用在自己的專案。

## 從舊文件搬過來

### 不用改就能編譯的部分

這幾種寫法在 akizumi 底下照樣能編譯，第一次遇到時 log 裡會有一則警告：

- `\begin{CJK*}{UTF8}{bsmi} … \end{CJK*}` 和 `CJK` 環境：什麼都不做，xeCJK 本來就會處理中日韓文字。
- `\usepackage{CJKutf8}`、`CJK`、`CJKspace`、`CJKpunct`：直接略過。
- `\usepackage{algpseudocode}`：略過。akizumi 已經載入 algpseudocodex，`algorithmic` 的寫法完全一樣，`\algrenewcommand\algorithmiccomment[1]{…}` 也照常生效。
- `\usepackage{algorithm2e}`：照常載入，但會自動加上 `algo2e`，避免跟 akizumi 的 `algorithm` 衝突。`\begin{algorithm}` 會接到 algorithm2e 的環境，所以 `\KwIn`、`\eIf`、`;` 結尾這些寫法都不用改，`\cref` 也照常可用。你自己加了 `algo2e` 的話就維持原樣：`algorithm2e` 環境給 algorithm2e，`algorithm` 留給 algorithmic。
- `\begin{li}[label=(\alph*)]`：舊 preamble 常見的清單，沒人定義時就當成 `enumerate`，選項跟 enumitem 一樣。
- ctex 的 `\chinese`：`\begin{enumerate}[label=\chinese*、]` 照樣編成 一、二、三。

想看到原本的錯誤訊息，可以加 `legacy=false` 把這些全部關掉。

### ax migrate

`ax migrate main.tex` 讀進舊文件，把轉好的版本寫到 `main-akizumi.tex`，原檔不會動。轉好後在 ax 專案裡用 `ax build main-akizumi.tex` 編譯，不在專案裡就用 `latexmk -xelatex main-akizumi.tex`。

| 原本 | 轉成 |
|---|---|
| `\documentclass[12pt,letterpaper,…]{memoir}`（或 article、book） | `\documentclass[12pt, paper=letter]{akizumi-hw}`。種類依內容判斷：有 Problem 標題或是作業就是 hw，有兩章以上是 book，其他是 note；可以用 `--kind` 指定。中文內容會加 `lang=zh` |
| `\def\coursename{…}`、`\authorID`、`\authorname`、`\documentname` | `\akizumisetup{course=…, id=…}`、`\author{…}`、`\title{…}`。內文還用到的巨集會保留成 `\newcommand` |
| `\coursecode`、`\headingright`、`\chaptertitleformat` 這類版面巨集 | 註解掉，並列出來 |
| `\setcounter{chapter}{N}`（preamble 或內文），後面接 `\chapter{Homework …}` | 作業的 `number=N+1`（`\chapter*` 不加一）；那一行 `\chapter` 換成 `\maketitle`。沒有接 `\chapter` 時是 `number=N`。講義則把 `\chapter{X}` 變成 `\title{X}`，有 `\setcounter` 時再加 `kicker={Chapter N}` |
| `\section*{Problem 3: 標題}`、`Question 3`、`第三題` | `\begin{problem}[標題] … \end{problem}`。題號跳號時會補上 `\setcounter{problem}{…}`；`Problem 1.1`、`Problem 2.a` 變成 `[label=1.1]` |
| 只有 `\section*`、沒有編號 `\section` 的講義 | 加上 `thmwithin=none, eqwithin=none, codewithin=none` |
| `13pt`、`14pt` 等字級 | 保留；memoir 的其他字級變成 `fontsize=` |
| `\begin{CJK*}{UTF8}{bsmi}`、`\end{CJK*}` | 刪掉 |
| `\usepackage{CJKutf8}`、`math-notes`、`algpseudocode`，以及 akizumi 已經載入的套件 | 註解掉；原本帶的選項（例如 geometry 的 `margin=1in`）會列出來讓你確認 |
| 主檔裡 `\newcommand{\R}{…}` 這種跟 akizumi 撞名的定義 | 改成 `\renewcommand`，保留你原本的意思 |

被改掉的行都留成 `% ax migrate: …` 註解，看得出原本寫什麼。

撞名報告會一起掃主檔 preamble，以及它用 `\input`、`\usepackage` 讀進來的本機檔案（例如 `shortcuts.tex`）。每一項都有檔名和行號：

- `\newcommand`、`\DeclareMathOperator`、`\newtheorem` 用了 akizumi 已有的名稱：LaTeX 會停在 already defined。
- `\def`、`\renewcommand` 蓋掉 akizumi 的定義，例如 `\E`、`\R`、`\T`，意思可能跟 akizumi 不同。
- `\def\c`、`\def\v` 這類單字母定義會蓋掉 LaTeX 的重音指令（`\c{c}`、`\v{s}`、`\S`）。

一個檔案撞名太多時，ax 會建議整個拿掉，只搬需要的巨集。被讀進來的檔案只報告，不會改。

| 參數 | 作用 |
|---|---|
| `-o 檔案` | 寫到別的檔名 |
| `--in-place` | 直接改原檔，原檔先備份成 `main.tex.bak` |
| `--kind hw\|note\|exam\|book\|slides` | 指定要轉成哪一種 |
| `--dry-run` | 只列出會改什麼，不寫檔 |
| `--force` | 輸出檔已經存在也覆寫 |

### 同一門課共用 preamble

同一門課的作業通常共用一組巨集和課名。把它們寫在課程資料夾的 `.akizumi/preamble.tex`：

    econometrics/
      .akizumi/preamble.tex     \akizumisetup{course={計量經濟學一}}
                                \newcommand{\plim}{\operatorname*{plim}}
      hw01/main.tex
      hw02/main.tex

編譯時，akizumi 從文件所在的資料夾往上找，最多找八層，用最近的那一份 `.akizumi/preamble.tex`。它在 `\documentclass` 之後、你自己的 preamble 之前讀進來，所以文件裡還可以用 `\renewcommand` 或 `\akizumisetup` 蓋掉它。簡報也會讀（在 `\usetheme{Akizumi}` 之後）；paper 不會讀，因為 paper 只載入 akizumi-math。

`ax`（專案狀態）、`ax config`、`ax new` 會顯示目前用到哪一份。`ax pack` 會把它一起打包成 `.akizumi/preamble.tex`。改了共用 preamble，`ax watch` 也會重編，因為 latexmk 把它當成文件的一部分。

這個功能從加入 akizumi-compat 的版本開始才有，固定在舊版本的專案要先 `ax upgrade`。它跟 `preamble.tex`（設定資料夾裡、`ax new` 時複製進專案的那份）可以同時使用：那份會成為專案的一部分，共用的這份則留在課程資料夾裡，改一次，所有作業都會跟著變。不要共用時加 `sharedpreamble=false`。

## 版本固定

模板會持續修改，但三個月前的作業應該照原樣編譯。做法是**每個專案記住自己用的模板版本**：

- 建立專案時，`.ax.json` 記下當時最新的版本（例如 `"template": "v0.4"`）。
- 之後模板改到 v0.5，這個專案仍然用 v0.4 編譯。各版本的檔案放在快取資料夾：macOS `~/Library/Caches/ax/<版本>/`，Linux `~/.cache/ax/<版本>/`，Windows `%LOCALAPPDATA%\ax\Cache\<版本>\`（`ax config` 會顯示）。
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

投稿會議論文見下一節〈投稿論文〉。

## 投稿論文

會議會要求用它自己的模板，外觀不能改，所以 `paper` 專案用 pdfLaTeX，不載入 akizumi 的外觀，只借兩個不綁編譯引擎的套件：

```latex
\usepackage{akizumi-math}                    % \vb、\norm、\E、\argmin……
\usepackage[refstyle=short]{akizumi-paper}   % 註解、縮寫、表格標記
```

akizumi-math 的選項照樣能用，例如 `\usepackage[delims=auto, letters=bold]{akizumi-math}`。

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

ICLR 的 `math_commands.tex` 也定義了 `\E`、`\R`、`\Var` 等。放在 akizumi-math 後面載入就好，同名的巨集以會議的為準（見〈數學〉的「和自己的巨集共存」）。

**akizumi-paper**

放在序言最後（hyperref 之後；自己要用帶選項的 xcolor 或 cleveref 的話，也放在它們之後）。在 akizumi 的 class 裡一樣能用。

<!-- snippet: packages=akizumi-paper -->
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
akizumi-paper.sty       投稿論文的寫作小工具：註解、縮寫、表格標記（引擎無關）
akizumi-logic.sty       邏輯與程式語言符號（要自己載入）
akizumi-core.sty        共用核心：字型、配色、定理、程式碼、版面；以下由它載入
akizumi-code.sty        程式碼進階功能：編號與列表、種類、行內上色、終端機、minted
akizumi-theorems.sty    定理選項、額外的定理種類、\akizumiNewTheorem
akizumi-callout.sty     提示框、\akizumiNewCallout、\optional
akizumi-exercise.sty    習題、例題與解答的位置
akizumi-tikz.sty        TikZ 函式庫、pgfplots、圖的樣式
akizumi-bib.sty         參考文獻（bib= 時載入）
akizumi-index.sty       索引、符號列表
akizumi-zhlayout.sty    中文報告版面
akizumi-compat.sty      舊文件相容、共用 preamble
akizumi-build.sty       \chapterdir
akizumi-hw.cls          作業
akizumi-problems.sty    作業的題號、分組、一題一檔、kind=、header=
akizumi-note.cls        講義
akizumi-exam.cls        考卷（基於 exam）
akizumi-book.cls        論文、書
akizumi-booklayout.sty  書的版面（雙面、部、章副標題、封面欄位）
beamerthemeAkizumi.sty  簡報
skeletons/            ax new 用的內文骨架
examples/             每種文件的完整範例，兼當測試
bin/                  ax（ax.cmd 給 Windows）、akizumi-both、biber 修正（macOS）
install.py            安裝（三個系統共用）
.github/workflows/    在 Linux、Windows、macOS 上自動測試
```

改完模板後：

```sh
ax selftest             # 重編 examples/ 的所有範例，再用 ax 建立並編譯每一種專案
ax selftest examples    # 只重編範例（同 make check）
ax selftest projects    # 只測 ax 專案（同 make test-ax）
ax selftest docs        # 只編譯這份文件（中英文版）裡的 LaTeX 片段
```

`ax selftest docs` 把兩份參考手冊裡每個 ```` ```latex ```` 區塊都編譯一次，失敗時印出 `檔案:行號`。有 `\documentclass` 的區塊照原樣編譯；其他的是片段，放進預設的 `akizumi-note`（語言跟著文件），`\usepackage`、`\akizumisetup`、`\newcommand` 這類導言區指令自動移到 `\begin{document}` 之前。片段用到的檔案（程式碼、題目檔、`refs.bib`）會自動產生替身，圖片找不到時畫一個框。區塊前一行可以加 HTML 註解（看文件時不會顯示）調整做法：

| 註解 | 作用 |
|---|---|
| `<!-- snippet: skip -->` | 不編譯：示意用、不完整的片段（少用） |
| `<!-- snippet: class=akizumi-hw options=lang=zh,solutions -->` | 換文件類型或選項 |
| `<!-- snippet: beamer -->` | 放進 Akizumi 簡報的一頁（片段本身有 frame 就不再包） |
| `<!-- snippet: preamble -->` | 整段都是導言區，內文留空 |
| `<!-- snippet: packages=akizumi-paper -->` | 先載入這些套件 |
| `<!-- snippet: ci-skip=macos,windows -->` | CI 的這些系統上不編譯（例如要下載楷體） |

可以一次寫好幾個，用空格隔開。改了手冊裡的範例就跑一次 `ax selftest docs`。

Linux 與 Windows 的測試在 GitHub Actions 上跑：推送版本 tag 時自動執行，也可以手動 `gh workflow run test`，結果在 repo 的 Actions 頁面。

發佈新版本（讓新專案用上、舊專案可以 `ax upgrade`）：

1. 更新 `CHANGELOG.md`。
2. 把各檔 `\ProvidesPackage` / `\ProvidesClass` 裡的版本號改掉。
3. `ax selftest`。
4. `git commit`，然後 `git tag -a v0.9 -m v0.9 && git push && git push --tags`（推 tag 會觸發三個系統的測試）。

沒有打 tag 的修改只影響 `examples/` 和直接用模板的文件，不會影響已經固定版本的專案。

## 疑難排解

**`ax doctor` 說 biber 有問題，或參考文獻全是問號（macOS）**
TeX Live 2026 的 biber 啟動時呼叫 `lipo -extract_family`，新版 Command Line Tools 已經移除這個參數，錯誤訊息是 `extracting arm64 binary with lipo failed`。`install.py` 偵測到時會把 `bin/biber` 連到 `~/bin/biber`：它用 `lipo -thin` 取出本機架構的版本執行，TeX Live 更新 biber 時會自動重新取出。biber 2.22 起已經修好（2026-10 在 GitHub Actions 的 macOS 上確認過）：執行 `sudo tlmgr update --self && sudo tlmgr update biber`，確認 `/Library/TeX/texbin/biber --version` 正常後刪掉 `~/bin/biber` 即可，之後重跑 `install.py` 也不會再連回來。Linux、Windows 沒有這個問題。

**改了模板，專案的 PDF 沒變**
專案固定在舊版本（見〈版本固定〉）。跑 `ax upgrade`；或者模板的修改還沒打 tag。

**換到另一台電腦，中日韓字型不一樣**
每個系統用找得到的第一個字型：

| 語言 | 無襯線（標題、標籤、簡報） | 襯線（內文） |
|---|---|---|
| 中文（`lang=en` 裡的中文也是） | 蘋方（macOS）→ Noto Sans CJK TC → 微軟正黑體（Windows）→ Fandol | 宋體 → Noto Serif CJK TC → 細明體 → Fandol |
| 日文 | Hiragino Sans（macOS）→ Noto Sans CJK JP → Yu Gothic（Windows）→ 原ノ味 | Hiragino Mincho → Noto Serif CJK JP → Yu Mincho → 原ノ味 |
| 韓文 | Apple SD Gothic Neo（macOS）→ Noto Sans CJK KR → Malgun Gothic（Windows）→ Baekmuk | AppleMyungjo → Noto Serif CJK KR → Batang → Baekmuk |

沒有粗體的字型（細明體、AppleMyungjo、Batang）粗體借用同語言的無襯線粗體。日文或韓文一個字型都沒有時改用中文字型並警告。`ax doctor` 會檢查 `config.json` 設定的語言的字型。

新版 macOS 的蘋方是用到時才下載的字型，全新的電腦上可能還沒有；在「字體簿」裡下載「PingFang TC」即可，沒下載時會自動改用後面的字型。

Fandol 一定有（TeX Live 內建），但主要是簡體字型，用到它時 log 會警告，部分繁體字可能缺字。原ノ味、Baekmuk 只在 TeX Live 的日文、韓文套件集裡。想在各系統看起來一致，就在每台電腦裝 [Noto CJK](https://github.com/notofonts/noto-cjk)（Linux：`fonts-noto-cjk`）。

**編譯時出現 `XeTeX is required to compile this document.`**
用了 pdfLaTeX。終端機請用 `ax build` 或 `latexmk`（會讀 `latexmkrc`）；編輯器設定見 README〈在 Cursor 裡寫〉。

**`ax` 找不到**
先開一個新的終端機（`install.py` 改的 PATH 只對新視窗生效）。還是找不到的話：macOS 把 `~/bin`、Linux 把 `~/.local/bin` 加進 `PATH`（`~/.zshrc` 或 `~/.bashrc` 加 `export PATH="$HOME/bin:$PATH"`）；Windows 重新執行 `py install.py`。

**Windows：`ax build` 說 PDF 被鎖住**
有些閱讀器（例如 Acrobat）開著 PDF 時會鎖住檔案，`ax` 換不掉它，新的 PDF 會留在 `build/main.pdf`。改用不鎖檔的閱讀器（SumatraPDF、Cursor 內建預覽）即可。

**從 PDF 複製出來的字有點怪：「bĳection」、「︒」**
只影響文字層，畫面是對的。內文字型 New Computer Modern 把 ij 排成一個連字（和 fi、fl 同一個 OpenType 功能，關掉會連 fi、fl 一起拆開）；宋體把置中的「。」「、」和直排符號共用同一個字形。兩者在 Unicode 相容正規化下都等於原字，多數閱讀器搜尋得到；要貼到別處時，貼上後取代一次即可。

**換頁之後多出一頁空白**
通常是一個不能拆開、又比整頁還高的公式或證明（例如很長的 Fitch 證明）放在 `\item` 開頭：hyperref 在每個 `\item` 放的連結錨點多了一個可以換頁的位置。內容本身就放不進一頁，把證明拆成兩段，或在前面加 `\enlargethispage{2\baselineskip}`。

**其他錯誤**
先跑 `ax doctor`。完整的編譯紀錄在 `build/main.log`。

---

版本紀錄見 [`CHANGELOG.md`](../CHANGELOG.md)。
