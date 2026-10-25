## zh

放在〈寫內容 › 定理、定義、證明〉，接在「`\listoftheorems` 列出所有定理類環境」那段之後，新增小節：

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
\akizumiNewTheorem{tool}{Tool}{工具}{道具}{도구}[counter=own, prefix=T]  % T1, T2, ...
\akizumiNewTheorem{unit}{Unit}{}{}{}[style=definition]
```

選項：`style=theorem|definition|remark`（線條和標籤樣式，預設 `theorem`）、`bar=1pt`、`barcolor=mute`、`counter=own|<另一種>`（預設依 `thmcounter`）、`prefix=T`、`within=chapter|section|none`、`plural=Tools`（`\cref` 的英文複數，預設加 s）。名稱跟 `thmnames` 走：預設英文，`thmnames=native` 用主語言。

調整已有種類的編號：

```latex
\akizumiSetTheorem{assumption}{counter=own, prefix=A, within=none}  % A1, A2, ...
```

另外：〈文件選項〉表格加上 `thmcounter`、`thmwithin`、`asides`、`aliases`、`thmname` 各一列（內容同上，註明「見〈定理、定義、證明〉」）；〈維護這套模板〉的檔案清單在 `akizumi-core.sty` 下面加一行 `akizumi-theorems.sty   定理選項、額外的定理種類、\akizumiNewTheorem（由 core 載入）`。

## en

Goes in "Writing content › Theorems, definitions, proofs", as a new subsection after the paragraph on `\listoftheorems`:

#### More kinds, numbering

There are also `axiom`, `conjecture`, `property`, `conclusion`, `remarks` (plural), `notationthm` (Notation) and `problem`, each with a starred unnumbered form. `notation` is already the notation table, so the theorem-like Notation is `notationthm`; in homework (akizumi-hw) `problem` is the problem heading, so the theorem-like `problem` is not defined there. A document that `\newtheorem`s (or `\declaretheorem`s) one of these names itself, e.g. `\newtheorem{conjecture}[theorem]{Conjecture}`, keeps its own definition, so old documents still compile.

Numbering is set with `\documentclass` options:

| Option | Values | Default | Effect |
|---|---|---|---|
| `thmcounter` | `shared` `grouped` `split` | `shared` | `shared`: one counter for every kind; `grouped`: theorem-like (theorem, lemma, ...), definition-like (definition, assumption, axiom, notationthm, problem) and aside (example, remark, remarks) kinds count separately; `split`: every kind counts on its own |
| `thmwithin` | `chapter` `section` `none` | notes `section`, books `chapter`, others `none` | prefix the number with the chapter or section; `chapter` only works in books |
| `asides` | `numbered` `unnumbered` | `numbered` | `unnumbered`: example, remark and remarks get no number |
| `aliases` | `none` `short` | `none` | `short`: adds `thm` `lem` `prop` `cor` `defn` `conj` `exam` `rem` `prob`, with the same name and counter as the full environment |
| `thmname` | `{kind=name, ...}` | | renames a kind, e.g. `thmname={corollary=系理}` |

Names can also change in the preamble: `\akizumisetup{thmname/corollary=系理}` or `\akizumisetup{thmname={corollary=系理, remark=備註}}`, also for `proof` and `solution`. A renamed kind has no plural form in `\cref`.

A manual number (handy when transcribing a book); `\label` and `\cref` work as usual and later automatic numbers are unaffected:

```latex
\begin{theorem}[number=3.2]\label{thm:rudin-3-2} ... \end{theorem}
\begin{theorem}[number=3.2, note=Cram\'er--Wold] ... \end{theorem}
```

Defining a new theorem-like environment:

```latex
% \akizumiNewTheorem{env}{English}{Chinese}{Japanese}{Korean}[options]; empty names fall back to English
\akizumiNewTheorem{tool}{Tool}{工具}{道具}{도구}[counter=own, prefix=T]  % T1, T2, ...
\akizumiNewTheorem{unit}{Unit}{}{}{}[style=definition]
```

Options: `style=theorem|definition|remark` (bar and label style, default `theorem`), `bar=1pt`, `barcolor=mute`, `counter=own|<another kind>` (default from `thmcounter`), `prefix=T`, `within=chapter|section|none`, `plural=Tools` (English plural for `\cref`, default adds an s). Names follow `thmnames`: English by default, the main language with `thmnames=native`.

Changing how an existing kind is numbered:

```latex
\akizumiSetTheorem{assumption}{counter=own, prefix=A, within=none}  % A1, A2, ...
```

Also add to the "Document options" table: `thmcounter`, `thmwithin`, `asides`, `aliases`, `thmname` (one row each, as above, "see Theorems, definitions, proofs"), and to the file list in "Maintaining the templates", under `akizumi-core.sty`: `akizumi-theorems.sty   theorem options, extra kinds, \akizumiNewTheorem (loaded by core)`.

## changelog

- Theorem options: `thmcounter=shared|grouped|split`, `thmwithin=chapter|section|none`, `asides=unnumbered`, `aliases=short` (`thm`, `lem`, `prop`, `cor`, ...), `thmname={corollary=系理}`; new kinds `axiom`, `conjecture`, `property`, `conclusion`, `remarks`, `notationthm`, `problem` (not in homework); `\begin{theorem}[number=3.2]` for manual numbers; `\akizumiNewTheorem{tool}{Tool}{工具}{道具}{도구}[prefix=T]` and `\akizumiSetTheorem` (new file `akizumi-theorems.sty`).
