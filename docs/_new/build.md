## zh

**放在〈書專用〉最後（`\maketitle` 那段之後）：**

#### 每章一個資料夾：`\chapterdir`

長篇講義或書常常每章一個資料夾，圖、程式碼、小節檔都放在裡面。`\chapterdir` 讓那一章的檔名不必每次寫完整路徑：

```latex
\chapterdir{basic-op}
\include{basic-op/chapter}     % \include 要寫完整路徑（.aux 依路徑命名）
```

之後：

- `\includegraphics{loop}` 依序找 `basic-op/`、`basic-op/figures/`，再找文件原本的 `\graphicspath`；
- `\input{section1}`、`\inputcode{hello.py}`、`\lstinputlisting{...}` 依序找 `basic-op/`、`basic-op/code/`，再找原本的位置；
- `\thechapterdir` 是目前的資料夾名稱（第一次呼叫前是空的）。

子資料夾名稱可以換：`\chapterdir[figures=img, code=ref-codes]{basic-op}`。`\chapterdir{}` 回到只找主資料夾。設定是全域的，寫在章檔案裡面也可以。任何文件類別都能用，不限書。

**放在〈ax 指令細節〉的表格裡（`ax both` 那列之後）：**

| `ax build --chapter N` | 只編第 N 章，輸出 `main-chN.pdf`，`main.pdf` 不動。章號、頁碼和跨章引用沿用上一次完整編譯的結果，所以先跑過一次 `ax build`。`N` 可以是章號、附錄字母（`A`）、`\include` 的檔名或資料夾名；`--chapter 3,5` 一次編兩章。`ax watch --chapter N` 同理 |
| `ax count` | 數字數：英文字數加中日韓字數（中日韓逐字算，韓文也是），不算指令、數學、程式碼、`\label`／`\ref`／`\cite`、註解和前言；會跟著 `\input`／`\include`／`\subfile`（和 `\chapterdir`）走，多個檔案時逐檔列出。`--limit 3000` 超過就提醒 |

**放在〈ax 指令細節〉的表格之後、「`ax build` 失敗時的樣子」之前：**

##### 編譯前的步驟和 shell escape：`.ax.json`

```json
{
  "kind": "note", "main": "main.tex", "template": "v0.9",
  "prebuild": ["python scripts/make_figures.py", "stata-mp -b do analysis.do"],
  "shell_escape": true
}
```

- `prebuild`：`ax build`、`ax both`、`ax watch` 編譯前，在專案資料夾依序執行（`ax watch` 只在開始時跑一次，不是每次存檔）。每個步驟交給系統的 shell（macOS／Linux 是 `/bin/sh`，Windows 是 `cmd`），所以可以用 `&&`；也可以寫成清單 `["python", "make.py"]`，不經過 shell。任何一步失敗（結束碼不是 0）就停下來，印出失敗的指令、結束碼和最後幾行輸出，PDF 保留上一份。`--no-prebuild` 跳過這些步驟。`ax doctor` 會檢查步驟用到的程式在不在 PATH 上。
- `shell_escape: true`：讓 LaTeX 可以執行外部程式（`minted`、`svg`、Stata 的 `texdoc` 等）。`ax build`／`both`／`watch` 都會加上 `-shell-escape`；ax 寫的 `latexmkrc` 也會讀這個設定，所以 Cursor／VS Code 直接呼叫 latexmk 時一樣。舊專案的 `latexmkrc` 不認得這個設定，第一次 `ax build` 時會自動更新它。

這兩個設定都會執行專案裡寫的指令，只用在自己的專案。

**放在〈ax 指令細節〉的 `ax doctor` 說明（表格那列）後面補一句：** 在專案裡還會檢查 `prebuild` 用到的程式、用了 `svg` 套件或 `\includesvg` 時的 inkscape（以及有沒有開 `shell_escape`），和專案 `\usepackage` 的套件是否都找得到（不在 TeX Live 裡的，例如 `stata.sty`，要放進專案資料夾）。

## en

**At the end of "Books" (after the `\maketitle` paragraph):**

#### One folder per chapter: `\chapterdir`

Long notes and books often keep each chapter in its own folder with its figures, code and section files. `\chapterdir` saves writing the folder in every file name:

```latex
\chapterdir{basic-op}
\include{basic-op/chapter}     % give \include the full path (.aux files are named after it)
```

From there on:

- `\includegraphics{loop}` looks in `basic-op/`, then `basic-op/figures/`, then the document's own `\graphicspath`;
- `\input{section1}`, `\inputcode{hello.py}` and `\lstinputlisting{...}` look in `basic-op/`, then `basic-op/code/`, then the usual places;
- `\thechapterdir` is the current folder (empty before the first call).

The subfolder names can change: `\chapterdir[figures=img, code=ref-codes]{basic-op}`. `\chapterdir{}` goes back to the main folder only. The setting is global, so the call may sit inside a chapter file. It works in every class, not only books.

**In the table of "ax commands in detail" (after the `ax both` row):**

| `ax build --chapter N` | Build chapter N alone into `main-chN.pdf`; `main.pdf` is left as it is. Chapter and page numbers and references to other chapters come from the last full build, so run `ax build` once first. `N` may be a chapter number, an appendix letter (`A`), or the `\include`d file's or folder's name; `--chapter 3,5` builds two. `ax watch --chapter N` works the same way |
| `ax count` | Count English words plus CJK characters (CJK counted per character, Korean too), leaving out commands, math, code, `\label` / `\ref` / `\cite`, comments and the preamble. Follows `\input` / `\include` / `\subfile` (and `\chapterdir`) and lists each file when there are several. `--limit 3000` warns above the limit |

**After that table, before "When `ax build` fails":**

##### Steps before compiling, and shell escape: `.ax.json`

```json
{
  "kind": "note", "main": "main.tex", "template": "v0.9",
  "prebuild": ["python scripts/make_figures.py", "stata-mp -b do analysis.do"],
  "shell_escape": true
}
```

- `prebuild`: run in the project folder, in order, before `ax build`, `ax both` and `ax watch` compile (`ax watch` runs them once when it starts, not on every save). Each step goes to the system shell (`/bin/sh` on macOS / Linux, `cmd` on Windows), so `&&` works; a list such as `["python", "make.py"]` runs without a shell. The first step that fails (non-zero exit code) stops the build: ax prints the command, its exit code and the last lines of its output, and the PDF stays as it was. `--no-prebuild` skips the steps. `ax doctor` checks that the programs they call are on PATH.
- `shell_escape: true`: lets LaTeX run programs (`minted`, `svg`, Stata's `texdoc`, ...). `ax build` / `both` / `watch` pass `-shell-escape`, and the `latexmkrc` ax writes reads the setting too, so Cursor / VS Code calling latexmk directly behave the same. An older project's `latexmkrc` does not know the setting; the first `ax build` updates it.

Both settings run commands written in the project; use them only in your own projects.

**Add to the `ax doctor` row:** inside a project it also checks the programs `prebuild` calls, inkscape when the `svg` package or `\includesvg` is used (and whether `shell_escape` is on), and that every package the project `\usepackage`s is found (ones outside TeX Live, such as `stata.sty`, belong in the project folder).

## changelog

- Build pipeline: `.ax.json` `"prebuild"` steps run before `ax build` / `both` / `watch` and stop the build with the failing command and its output; `"shell_escape": true` reaches latexmk from ax and from the project `latexmkrc`; `ax build --chapter N` (and `ax watch --chapter N`) builds one `\include`d chapter into `main-chN.pdf` with its real number; `\chapterdir{dir}` points figures, `\input` and code files at a chapter's folder; `ax count` counts English words and CJK characters (`--limit N`); `ax doctor` checks prebuild programs, inkscape for svg, and packages missing from TeX Live.
