## zh

放在〈寫內容〉底下，緊接在「### 定理、定義、證明」之後，新增一節：

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
| chapterguide | Chapter guide / 本章導覽 | 標籤獨立一行、淡藍底；`\guidehead{...}` 是框內小標 |
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

## en

Under "Writing content", right after "### Theorems, definitions, proofs", add:

### Callouts

Reading-aid boxes with the same left bar as the theorems. They break across pages and work in documents and slides:

```latex
\begin{chapterguide}
\guidehead{What this chapter is about}  ...
\guidehead{Prerequisites}               ...
\end{chapterguide}

\begin{keyidea} A series converges when its tails become small. \end{keyidea}
\begin{proofidea} Compare, then use the Cauchy criterion. \end{proofidea}
\begin{proof} ... \end{proof}

\begin{tip}[Root test] ... \end{tip}
\begin{warning} ... \end{warning}      % pitfall: same look, labelled "Pitfall"
\begin{note} ... \end{note}
\begin{setup} Let $(a_n)$ be a real sequence. \end{setup}   % faint box, no label
```

| Environment | Label (en / zh) | Look |
|---|---|---|
| keyidea | Key idea / 重點 | thick accent bar, faint accent background |
| proofidea | Idea of the proof / 證明思路 | thin grey bar, muted label |
| tip | Tip / 提示 | thin light-accent bar |
| warning, pitfall | Warning / 注意, Pitfall / 常見錯誤 | thick orange bar, orange label |
| note | Note / 附註 | thin grey bar, ink label |
| chapterguide | Chapter guide / 本章導覽 | label on its own line, faint accent background; `\guidehead{...}` makes headings inside |
| setup | (none) | faint grey background; with `[title]` only the title shows |

`[...]` is a title after the name, as with theorems. Names follow `lang=` (Japanese and Korean too), except `proofidea`, which follows `thmnames=` so it matches the Proof after it. CJK names take no period. These environments are unnumbered.

**Your own kind**: `\akizumiNewCallout{name}{English}{zh}{ja}{ko}[keys]`; empty languages use the English:

```latex
\akizumiNewCallout{keypoint}{Key point}{學習要點}{}{}[numbered=chapter, tint]
\begin{keypoint}\label{kp:import} ... \end{keypoint}   % Key point 3.1, works with \cref
```

Keys:

| Key | Values | Meaning |
|---|---|---|
| `numbered` | `false`, `true`, a counter | `true`: 1, 2, ... through the document; `chapter`, `section`, ...: restart with that counter, shown as 3.1 |
| `tint` | `false`, `true`, a color | faint background; `true` is the bar color at 7% |
| `bar` | length | bar width, default `1pt` |
| `color` | color | bar color, default `accentsoft` |
| `labelcolor` | color | label color, default `accent` |
| `head` | `inline`, `block` | label runs into the text, or sits on its own line |
| `thmname` | `false`, `true` | `true`: the name follows `thmnames=` |
| `plural` | text | English plural for `\cref`, default the English name plus s |

`\akizumiCalloutSetup{keyidea}{numbered=chapter}` changes a ready-made or custom kind, here numbering key ideas per chapter.

**Optional material**: `\optional` puts a muted star before a title; it shows in the contents and in PDF bookmarks (as ★):

```latex
\section{\optional The Arzelà–Ascoli theorem}
\begin{remark}[\optional Complex Gaussian integrals] ... \end{remark}
```

Existing documents are unaffected: a preamble's own `keyidea`, `\pitfall`, `\optional`, `\guidehead` and so on win, and the ready-made one is not defined (on slides `note` stays beamer's `\note`, so slides have no `note` box).

## changelog

- Callouts: `keyidea`, `proofidea`, `tip`, `warning` / `pitfall`, `note`, `chapterguide` with `\guidehead`, and the unlabelled `setup` box, in the left-bar look, breakable, in documents and slides, named in every language; `\akizumiNewCallout{name}{en}{zh}{ja}{ko}[numbered=chapter, tint, ...]` and `\akizumiCalloutSetup` for your own; `\optional` marks optional sections and remarks with a star that also shows in PDF bookmarks.
