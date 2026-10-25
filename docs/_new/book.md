## zh

放在 docs/reference.md〈書專用〉一節，接在「`\maketitle` 是整頁封面；頁首左邊是章名、右邊是節名。」之後；檔案結構清單（〈維護這套模板〉）在 `akizumi-book.cls` 下面加一行 `akizumi-booklayout.sty  書的版面（雙面、部、章副標題、封面欄位）`。

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

## en

Goes in docs/reference.en.md, section "Books", after the sentence saying `\maketitle` is a full cover page and the header shows the chapter left and the section right. In the file list under "Maintaining the templates", add `akizumi-booklayout.sty  book layout (two-sided, parts, chapter subtitles, cover fields)` below `akizumi-book.cls`.

```latex
\documentclass[openright, partreset, chaptername=Lecture]{akizumi-book}
\title{Algorithms}
\subtitle{A Second Course}             % or \akizumisetup{subtitle=...}
\akizumisetup{institution={National Taiwan University}, term={Winter 2026}}
...
\frontmatter \maketitle
\preface                               % "Preface", listed in the contents; \preface[Foreword]
\tableofcontents
\mainmatter
\part[sub=基礎]{Foundations}
\chapter[sub=向量空間]{Vector Spaces}
\chapter[short=Maps]{Linear Maps Between Vector Spaces}   % short title for contents and header
\paragraph{Run-in.} ...
```

Book layout options (in `\documentclass[...]`):

| Option | Effect |
|---|---|
| `twoside` | Two-sided: chapter on the left of even-page headers, section on the right of odd ones; pages left empty only to reach a right-hand page stay blank |
| `openright` | Chapters and parts start on odd pages (implies `twoside`) |
| `partreset` | Chapter numbers restart at 1 in each `\part` |
| `chaptername=Lecture` | Chapter label "Lecture 3", also in `\cref`. A `*` marks where the number goes: `chaptername={第 * 講}`, `{Episode *}`. Appendices are unchanged |

- `\chapter[sub=...]{...}`: a second-language subtitle under the chapter title (muted, not bold), left out of the contents and header. `short=` gives the short title for the contents and header; both can be combined. Without `sub=` or `short=`, the bracket is the usual short title. `\chapter*` and `\part` accept `sub=` too.
- `\part`: a page of its own, centred, with a muted "Part II" (第 2 部分 etc. in CJK) over the large title.
- Cover fields: `subtitle` (under the title), `institution` and `term` (at the bottom of the page). Without them the cover is unchanged.
- `\preface[title]`: an unnumbered chapter, listed in the contents with its header set; the default title is Preface / 序言 / まえがき / 머리말.
- `\paragraph` and `\subparagraph` are run-in bold Lato headings (`\subparagraph` muted).
- The contents number columns widen by themselves so two-digit numbers like 13.10 or 12.10.4 do not run into the title (takes effect on the next run; books with one-digit numbers keep the usual widths).

## changelog

- Books: `twoside` / `openright` with mirrored headers, styled `\part` pages and `partreset`, `\chapter[sub=..., short=...]` for a second-language subtitle, `chaptername=Lecture` or `{第 * 講}`, cover `subtitle` / `institution` / `term`, `\preface`, run-in Lato `\paragraph` / `\subparagraph`, and contents number columns that widen for numbers like 13.10 (new `akizumi-booklayout.sty`).
