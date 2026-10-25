## zh

### 放在〈寫內容 › 程式碼〉現有段落之後（接在「簡報裡的 frame 要加 `[fragile]`。」後面）

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
\inputcode[lang=cpp, lines=10-24]{main.cpp}  % 只印第 10–24 行（行號從 1 起）
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

`\iosample` 的兩個參數是一般文字，每行用 `\\` 分開；`\\` 後面直接接 `[` 也沒問題。

#### 行內程式碼

```latex
\code{x_1 % #}                    % 原樣印出，括號要成對
\code|a{b|                        % 跟 \verb 一樣換分隔符
\code[cpp]{std::vector<int> v;}   % 指定語言就上色
\section{The \code{a\_b} function}
\begin{theorem}[\code{sort} 是穩定的] ...
```

`\code` 可以放在別的指令的參數裡（章節標題、定理名稱、註腳、簡報的一般 frame）。這時 TeX 已經先讀過內容，所以 `%`、`#` 要寫成 `\%`、`\#`，`_` `&` `$` `{` `}` 也可以寫成 `\_` 等，印出來都是字元本身。頁首、目錄、PDF 書籤也正常。

#### 語言

`lang=` 和 `\code[…]` 的語言名稱不分大小寫，兩種引擎的名字都認得：`cpp` 和 `C++`、`py` 和 `Python`、`hs` 和 `Haskell`、`sh` 和 `bash`、`tex` 都可以。listings 內建 Haskell、SQL，模板另外加了 `Agda`（Unicode 符號照印）、`Datalog`（`#`、`//` 註解，`:-` 上色）、`Stata`（`*` 行首註解、`//`、`/* */`）。

### 放在〈文件選項〉表格裡（加兩列）

| `code` | `listings` `minted` | `listings` | 程式碼上色引擎。`minted` 用 Pygments，顏色更準、語言更多；需要 shell escape 和 Pygments（TeX Live 2024 起內附的 `latexminted` 就夠），缺了會警告並改用 listings |
| `verbatim` | `plain` `styled` | `plain` | `styled` 讓 `verbatim` 環境也用程式碼的淡灰底和小字 |

### 放在〈ax new 的選項與專案內容〉表格裡（加一列，放在 `--bib` 後面）

| `--code minted` | 用 minted 上色：加上 `code=minted`，並在 `.ax.json` 寫 `"shell_escape": true`，`ax build`、`ax watch` 和 latexmkrc 都會加 `-shell-escape`。主檔裡有 `code=minted` 或載入 minted 時，`ax build` 也會自動加 |

### 放在〈維護這套模板〉的檔案列表（`akizumi-core.sty` 下一行）

```
akizumi-code.sty        程式碼進階功能：編號與列表、種類、行內上色、終端機、minted（由 core 載入）
```

## en

### After the existing text in "Writing › Code" (after "On slides the frame needs `[fragile]`.")

#### Numbers, labels and the list of listings

```latex
\begin{codeblock}[numbered, label=lst:fit, title=fit.py, lang=python]
...
\end{codeblock}
See \cref{lst:fit}.      % "Listing 1.2"; 程式碼 1.2 with lang=zh

\begin{code}[label=lst:loop]{python}{Loop over a list}   % always numbered
for x in xs: ...
\end{code}

\listofcodes             % every numbered block, titled "List of Listings"
```

Any of `numbered`, `label=…` or `kind=…` numbers a block: the title bar shows the kind and number, then the `title`, and the block goes into `\listofcodes`. Books number per chapter, notes per section, other documents from 1. Blocks without these options look as before.

Your own kinds:

```latex
\akizumiNewCodeKind[env=example, counter=code]{example}{Example}{範例}
\akizumiNewCodeKind[env=code]{idiom}{Idiom}{片語}   % \begin{code} becomes "Idiom N"
```

Options: `counter=<kind>` shares that kind's numbers; `within=chapter|section|none`; `env=<name>` also defines `\begin{name}[options]{language}{title}` (a theorem-like environment of that name, such as `example`, is replaced); `ja=`, `ko=` for the Japanese and Korean names (default: the Chinese and English ones); `plural=` for the English plural used by `\cref` (default: add s). The built-in kind is `code`.

#### Line ranges, search path, program output

```latex
\codedir{src/, code/}                        % where \inputcode looks when the file is not found
\inputcode[lang=cpp, lines=10-24]{main.cpp}  % only lines 10-24 (numbered from 1)
\inputcode[output, title=output]{run.txt}    % program output: white, hairline frame, no numbers, no colour
```

`output` works on `codeblock` too.

#### Terminal and input / output samples

```latex
% lines starting with "$ ", ">>> ", "... ", "# " in body colour, output muted
\begin{terminal}[title=zsh]
$ python main.py
3
\end{terminal}

\iosample{1 2 \\ 3 4}{3 \\ 7}   % "input" left, "output" right, each as wide as its content
\iosample{}{[89.2, 74.8] \\}     % an empty side is left out
```

The two arguments of `\iosample` are ordinary text with `\\` between lines; `\\` followed by `[` is safe.

#### Inline code

```latex
\code{x_1 % #}                    % printed as is; braces must balance
\code|a{b|                        % other delimiters, as with \verb
\code[cpp]{std::vector<int> v;}   % a language highlights it
\section{The \code{a\_b} function}
\begin{theorem}[\code{sort} is stable] ...
```

`\code` works inside other commands' arguments (section titles, theorem names, footnotes, ordinary slide frames). There TeX has read the text already, so write `%` and `#` as `\%` and `\#`; `\_`, `\&`, `\$`, `\{`, `\}` also print the bare character. Running headers, the contents and PDF bookmarks work too.

#### Languages

Language names in `lang=` and `\code[…]` ignore case, and either engine's names work: `cpp` or `C++`, `py` or `Python`, `hs` or `Haskell`, `sh` or `bash`, `tex`. listings brings Haskell and SQL; the template adds `Agda` (Unicode symbols print), `Datalog` (`#` and `//` comments, `:-` coloured) and `Stata` (`*` at line start, `//`, `/* */` comments).

### In the "Document options" table (two rows)

| `code` | `listings` `minted` | `listings` | Highlighting engine. `minted` uses Pygments (better colours, more languages); it needs shell escape and Pygments (the `latexminted` that ships with TeX Live 2024+ is enough) and otherwise warns and stays with listings |
| `verbatim` | `plain` `styled` | `plain` | `styled` gives `verbatim` the code background and size |

### In the "ax new options" table (one row, after `--bib`)

| `--code minted` | Highlight with minted: adds `code=minted` and writes `"shell_escape": true` to `.ax.json`, so `ax build`, `ax watch` and latexmkrc pass `-shell-escape`. `ax build` also adds it when the main file has `code=minted` or loads minted |

### In the file list of "Maintaining the templates" (after `akizumi-core.sty`)

```
akizumi-code.sty        more for code: numbering and list, kinds, inline highlighting, terminal, minted (loaded by core)
```

## changelog

- Code: `codeblock[numbered, label=…, kind=…]` with `\listofcodes` and `\cref`; `\akizumiNewCodeKind` for kinds such as Example that can share numbers and get their own `\begin{…}{lang}{title}`; `\begin{code}{lang}{title}`; `lines=a-b`, `\codedir`, `\inputcode[output]`; `terminal` and `\iosample{in}{out}`; `\code[lang]{…}` highlights and works inside other commands' arguments; Agda, Datalog and Stata for listings; `verbatim=styled`; opt-in `code=minted` (falls back to listings with a warning), `ax new --code minted` and automatic `-shell-escape`.
