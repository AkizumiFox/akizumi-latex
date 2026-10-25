## zh

**1. 〈文件選項〉的表格加兩列**（放在 `cjk`、`cjk-bold` 那列之後）：

```markdown
| `legacy` | `true` `false` | `true` | 讓舊文件的內文照樣編譯（見〈從舊文件搬過來〉）。`false` 關掉 |
| `sharedpreamble` | `true` `false` | `true` | 讀往上找到的 `.akizumi/preamble.tex`（見〈同一門課共用 preamble〉）。`false` 不讀 |
```

**2. 〈ax 指令細節〉的表格加一列**（放在 `ax selftest` 之前），並把表格上方那句改成「除了 `new`、`doctor`、`config`、`completion`、`migrate`，其他指令都在專案資料夾裡執行」：

```markdown
| `ax migrate 檔案.tex` | 把舊文件轉成 akizumi 的副本 `檔案-akizumi.tex`，原檔不動；列出跟 akizumi 撞名的巨集（見〈從舊文件搬過來〉） |
```

**3. 新增一節，放在〈ax 指令細節〉之後、〈版本固定〉之前：**

```markdown
## 從舊文件搬過來

### 不用改就能編譯的部分

這幾種寫法在 akizumi 底下照樣能編譯，第一次遇到時 log 裡會有一則警告：

- `\begin{CJK*}{UTF8}{bsmi} … \end{CJK*}` 和 `CJK` 環境：什麼都不做，xeCJK 本來就會處理中日韓文字。
- `\usepackage{CJKutf8}`、`CJK`、`CJKspace`、`CJKpunct`：直接略過。
- `\usepackage{algpseudocode}`：略過。akizumi 已經載入 algpseudocodex，`algorithmic` 的寫法完全一樣，`\algrenewcommand\algorithmiccomment[1]{…}` 也照常生效。
- `\usepackage{algorithm2e}`：照常載入，但會自動加上 `algo2e`，避免跟 akizumi 的 `algorithm` 衝突。`\begin{algorithm}` 會接到 algorithm2e 的環境，所以 `\KwIn`、`\eIf`、`;` 結尾這些寫法都不用改，`\cref` 也照常可用。你自己加了 `algo2e` 的話就維持原樣：`algorithm2e` 環境給 algorithm2e，`algorithm` 留給 algorithmic。
- `\begin{li}[label=(\alph*)]`：舊 preamble 常見的清單，沒人定義時就當成 `enumerate`，選項跟 enumitem 一樣。

想看到原本的錯誤訊息，可以加 `legacy=false` 把這些全部關掉。

### ax migrate

`ax migrate main.tex` 讀進舊文件，把轉好的版本寫到 `main-akizumi.tex`，原檔不會動。轉好後在 ax 專案裡用 `ax build main-akizumi.tex` 編譯，不在專案裡就用 `latexmk -xelatex main-akizumi.tex`。

| 原本 | 轉成 |
|---|---|
| `\documentclass[12pt,letterpaper,…]{memoir}`（或 article、book） | `\documentclass[12pt, paper=letter]{akizumi-hw}`。種類依內容判斷：有 Problem 標題或是作業就是 hw，有兩章以上是 book，其他是 note；可以用 `--kind` 指定。中文內容會加 `lang=zh` |
| `\def\coursename{…}`、`\authorID`、`\authorname`、`\documentname` | `\akizumisetup{course=…, id=…}`、`\author{…}`、`\title{…}`。內文還用到的巨集會保留成 `\newcommand` |
| `\coursecode`、`\headingright`、`\chaptertitleformat` 這類版面巨集 | 註解掉，並列出來 |
| `\setcounter{chapter}{N}`，後面接 `\chapter{Homework …}` | 作業的 `number=N+1`；那一行 `\chapter` 換成 `\maketitle`。沒有接 `\chapter` 時是 `number=N` |
| `\section*{Problem 3: 標題}`、`Question 3`、`第三題` | `\begin{problem}[標題] … \end{problem}`。題號跳號時會補上 `\setcounter{problem}{…}` |
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
| `--kind hw\|note\|exam\|book` | 指定要轉成哪一種 |
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
```

## en

**1. Two rows in the [Document options](#document-options) table** (after the `cjk`, `cjk-bold` row):

```markdown
| `legacy` | `true` `false` | `true` | Old document bodies compile unchanged (see [Moving old documents over](#moving-old-documents-over)); `false` turns this off |
| `sharedpreamble` | `true` `false` | `true` | Reads the `.akizumi/preamble.tex` found upwards (see [One preamble for a whole course](#one-preamble-for-a-whole-course)); `false` skips it |
```

**2. One row in the [ax commands in detail](#ax-commands-in-detail) table** (before `ax selftest`), and the sentence above the table becomes "All commands but `new`, `doctor`, `config`, `completion` and `migrate` run inside a project folder":

```markdown
| `ax migrate FILE.tex` | Rewrite an old document for akizumi as a copy, `FILE-akizumi.tex`, leaving the original alone; list macros that clash with akizumi's (see [Moving old documents over](#moving-old-documents-over)) |
```

**3. A new section after "ax commands in detail", before "Version pinning":**

```markdown
## Moving old documents over

### What compiles without changes

These compile under akizumi as they are; the log carries one warning the first time each is met:

- `\begin{CJK*}{UTF8}{bsmi} … \end{CJK*}` and the `CJK` environment do nothing: xeCJK sets Chinese, Japanese and Korean already.
- `\usepackage{CJKutf8}`, `CJK`, `CJKspace`, `CJKpunct` are skipped.
- `\usepackage{algpseudocode}` is skipped. akizumi loads algpseudocodex, which takes the same `algorithmic` commands, and `\algrenewcommand\algorithmiccomment[1]{…}` works as before.
- `\usepackage{algorithm2e}` loads with `algo2e` added, so it no longer clashes with akizumi's `algorithm`. `\begin{algorithm}` then starts an algorithm2e block, so `\KwIn`, `\eIf` and lines ending in `;` stay as they are, and `\cref` works. If you pass `algo2e` yourself, nothing is redirected: `algorithm2e` is algorithm2e's, `algorithm` stays algorithmic's.
- `\begin{li}[label=(\alph*)]`, the list old preambles define, is an `enumerate` with enumitem options when nothing else defines `li`.

`legacy=false` turns all of this off, to see the original errors.

### ax migrate

`ax migrate main.tex` writes a converted copy to `main-akizumi.tex` and leaves the original alone. Build the copy with `ax build main-akizumi.tex` inside an ax project, or `latexmk -xelatex main-akizumi.tex` elsewhere.

| Before | After |
|---|---|
| `\documentclass[12pt,letterpaper,…]{memoir}` (or article, book) | `\documentclass[12pt, paper=letter]{akizumi-hw}`. The kind is guessed: hw with Problem headings or for homework, book with two chapters or more, note otherwise; `--kind` picks it. Chinese text adds `lang=zh` |
| `\def\coursename{…}`, `\authorID`, `\authorname`, `\documentname` | `\akizumisetup{course=…, id=…}`, `\author{…}`, `\title{…}`. Macros the body still uses are kept as `\newcommand` |
| Layout macros such as `\coursecode`, `\headingright`, `\chaptertitleformat` | Commented out and listed |
| `\setcounter{chapter}{N}` followed by `\chapter{Homework …}` | `number=N+1` for homework; that `\chapter` becomes `\maketitle`. Without a `\chapter` after it, `number=N` |
| `\section*{Problem 3: Title}`, `Question 3`, `第三題` | `\begin{problem}[Title] … \end{problem}`, with `\setcounter{problem}{…}` where numbers skip |
| `\begin{CJK*}{UTF8}{bsmi}`, `\end{CJK*}` | Removed |
| `\usepackage{CJKutf8}`, `math-notes`, `algpseudocode`, and packages akizumi loads already | Commented out; options they carried (geometry's `margin=1in`, say) are listed for you to check |
| A `\newcommand{\R}{…}` in the main file that clashes with akizumi | Becomes `\renewcommand`, so your meaning stays |

Every line it changes stays behind as a `% ax migrate: …` comment.

The clash report covers the main file's preamble and the local files it reads with `\input` or `\usepackage` (such as `shortcuts.tex`), with file and line:

- `\newcommand`, `\DeclareMathOperator` or `\newtheorem` of a name akizumi has: LaTeX stops with "already defined".
- `\def` or `\renewcommand` replacing akizumi's `\E`, `\R`, `\T`, ...: the meaning may differ from akizumi's.
- One-letter definitions such as `\def\c` or `\def\v` replace LaTeX's accents (`\c{c}`, `\v{s}`, `\S`).

A file with many clashes gets a suggestion to drop it and move over only the macros you need. Files read in are reported, never changed.

| Option | Effect |
|---|---|
| `-o FILE` | Write to another file name |
| `--in-place` | Rewrite the file itself, keeping the original as `main.tex.bak` |
| `--kind hw\|note\|exam\|book` | The kind to convert to |
| `--dry-run` | List the changes, write nothing |
| `--force` | Overwrite the output file if it exists |

### One preamble for a whole course

The homework of one course usually shares macros and the course name. Put them in `.akizumi/preamble.tex` in the course folder:

    econometrics/
      .akizumi/preamble.tex     \akizumisetup{course={Econometrics I}}
                                \newcommand{\plim}{\operatorname*{plim}}
      hw01/main.tex
      hw02/main.tex

When a document builds, akizumi looks in its folder and up to eight folders above for `.akizumi/preamble.tex`, and reads the nearest one right after `\documentclass`, before your own preamble, so the document can still override it with `\renewcommand` or `\akizumisetup`. Slides read it too (after `\usetheme{Akizumi}`); papers do not, since they only load akizumi-math.

`ax` (project status), `ax config` and `ax new` show which one applies, and `ax pack` includes it as `.akizumi/preamble.tex`. Editing it makes `ax watch` rebuild, since latexmk sees it as part of the document.

It needs a template version with akizumi-compat; projects pinned to an older one need `ax upgrade` first. It goes well with `preamble.tex` in the config folder, which `ax new` copies into each project: that copy becomes part of the project, while the shared one stays in the course folder, so one change reaches every homework. `sharedpreamble=false` leaves it out.
```

## changelog

- Old documents: `CJK` / `CJK*` environments and `\usepackage{CJKutf8|CJKspace|algpseudocode}` are ignored with a warning, algorithm2e loads beside `algorithm`, and `li` lists work (`legacy=false` turns this off); `ax migrate FILE.tex` rewrites a copy of a memoir / math-notes document for akizumi (course macros, `\setcounter{chapter}`, `\section*{Problem k}`, CJK wrappers) and reports macros that clash with akizumi's; a course folder's `.akizumi/preamble.tex` is read by every document below it (`sharedpreamble=false` to skip).
