## zh

放在 docs/reference.md 的〈寫內容〉裡，〈演算法、符號表〉之後新增一節 `### 索引、符號列表`；〈文件選項〉的表格加兩列（最後一段）。

### 索引、符號列表

`\documentclass[index=true]{akizumi-book}`（講義、作業、考卷也可以）打開書末索引和附頁碼的符號列表。沒開的時候 `\index` 什麼都不做，所以可以先標著。

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

〈文件選項〉表格加：

| 選項 | 值 | 預設 | 作用 |
|---|---|---|---|
| `index` | `false` `true` | `false` | 書末索引和符號列表：`\index`、`\nota`、`\printindex`、`\printnotation`（見〈索引、符號列表〉） |
| `index-sort` | `stroke` `zhuyin` `pinyin` `radical` | `stroke` | `lang=zh` 時索引的中文排序（需要 upmendex） |

## en

Goes in docs/reference.en.md under "Writing content", as a new section `### Index and list of notation` right after "Algorithms, notation tables"; the two option rows go in the table under "Document options" (end of this part).

### Index and list of notation

`\documentclass[index=true]{akizumi-book}` (also notes, homework, exams) turns on a subject index and a list of notation with page numbers. Without it `\index` does nothing, so entries can be marked in advance.

```latex
\index{partition}  \index{partition!mesh}  \index{sum@$\Sigma$-notation}
\index{mesh|see{partition}}
\nota{$\norm{x}$}{Euclidean norm of $x\in\R^n$}   % where the symbol is defined
...
\printnotation   % list of notation, e.g. after the contents
\printindex      % the index: two columns, on a new page
```

- The index uses imakeidx: two columns, listed in the contents, headed Index / 索引 / 索引 / 색인 by `lang`. `!` makes a subentry, text before `@` is the sort key, `|see{...}` a cross-reference, as in makeindex. Page numbers are links.
- `\nota{symbol}{meaning}` prints nothing and records the page; `\printnotation` lists Symbol / Meaning / Page in order of appearance, styled like the `notation` table (a chapter in books, a section elsewhere, without a page break). `! @ | "` in the text are escaped for you. A `\nota` or `\printnotation` defined in your preamble wins.
- More indexes: `\akizumiNewIndex{persons}{Index of Names}` in the preamble, `\index[persons]{Gauss}` in the text, `\printindex[persons]` at the end. The optional argument goes to imakeidx, e.g. `\akizumiNewIndex[columns=3]{...}{...}`.
- latexmk runs the indexer, so `ax build`, `ax watch` and Cursor all make the index (the `latexmkrc` ax writes sets this up; in older projects run `ax upgrade` once to refresh it). It uses upmendex when installed: Chinese sorts by `index-sort` (default stroke count, as in Traditional Chinese dictionaries; also `zhuyin`, `pinyin`, `radical`), Japanese and Korean by their own collation. Without upmendex it falls back to makeindex, which sorts CJK by code point. `ax doctor` shows whether upmendex is there (TeX Live package `upmendex`).
- upmendex does not know the readings of Japanese kanji: write `\index{せきぶん@積分}`.
- Without latexmk, run it yourself: `upmendex -s build/main.ist build/main.idx` (the notation list is `main-notation.idx`).

Rows for the "Document options" table:

| Option | Values | Default | Effect |
|---|---|---|---|
| `index` | `false` `true` | `false` | Subject index and list of notation: `\index`, `\nota`, `\printindex`, `\printnotation` (see "Index and list of notation") |
| `index-sort` | `stroke` `zhuyin` `pinyin` `radical` | `stroke` | Chinese sort order of the index with `lang=zh` (needs upmendex) |

## changelog

- `index=true`: subject index (imakeidx, two columns, in the contents, localized heading) and a list of notation (`\nota{sym}{meaning}`, `\printnotation`, with pages, styled like the notation table); `\akizumiNewIndex` for more indexes; latexmk runs upmendex (CJK sorting, `index-sort=stroke|zhuyin|pinyin|radical`) or makeindex, so `ax build`, `ax watch` and Cursor build the index; `ax doctor` reports upmendex, `ax selftest` builds an indexed project.
