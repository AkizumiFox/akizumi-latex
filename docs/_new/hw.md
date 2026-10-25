## zh

放在 docs/reference.md〈寫內容〉→〈作業與考卷專用〉，取代原本作業那段程式碼（考卷那段不變）；`--problems` 那一行加到〈ax new 的選項與專案內容〉的選項表（`--force` 之前）。

選項表新增一列：

| `--problems 5` 或 `--problems B4,C2` | 作業：建立 `problems/p1.tex`…`p5.tex`（分組時是 `B1`…`B4`、`C1`、`C2`），`main.tex` 用 `\inputproblem` 逐題載入 |

〈作業與考卷專用〉作業部分：

```latex
\begin{problem}[標題]          % 作業：第 N 題
  \begin{parts} \item ... \item ... \end{parts}   % (a) (b)
  \begin{solution} ... \end{solution}
\end{problem}
```

分組題號與手動題號：

```latex
\problemset{B}                          % 之後是 B1、B2…；\problemset{C} 從 C1 重新開始
\begin{problem}[label=B2$'$]            % 直接指定題號，不佔用計數
\begin{problem}[label=C3, title=緊緻性]  % 題號加標題
```

方括號裡只有 `label=`、`title=` 這兩個鍵時當成選項，其他內容一律當標題，所以 `[$f(x)=x^2$]` 照舊是標題。`\label`、`\cref` 都會顯示 B1、B2′ 這種題號。

一題一個檔：

```latex
\inputproblem{problems/p1}              % 等於 \begin{problem}\input{problems/p1}\end{problem}
\inputproblem[柯西數列]{problems/B1}     % 方括號和 problem 的一樣：標題或 label=、title=
```

題目檔裡寫題目和 `solution`，`ax both` 一樣適用。`problembreak=true`（或 `\documentclass[problembreak]{akizumi-hw}`）讓每一題從新的一頁開始，第一題除外。

小題：

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

這三個是 `\documentclass` 選項，也可以寫在 `\akizumisetup{...}`。所有文件類型（考卷除外）的 `\akizumisetup` 另外接受 `headleft=...`、`headright=...`，直接指定內頁頁首左右兩邊的文字；第一頁的頁首不受影響。

## en

Goes in docs/reference.en.md, "Writing content" → "Homework and exams", replacing the homework code block there (the exam part stays); the `--problems` row goes in the option table of "ax new options and project contents", before `--force`.

New row in the option table:

| `--problems 5` or `--problems B4,C2` | Homework: create `problems/p1.tex` ... `p5.tex` (with groups, `B1` ... `B4`, `C1`, `C2`) and load each from `main.tex` with `\inputproblem` |

Homework part of "Homework and exams":

```latex
\begin{problem}[Title]         % homework: Problem N
  \begin{parts} \item ... \item ... \end{parts}   % (a) (b)
  \begin{solution} ... \end{solution}
\end{problem}
```

Grouped and hand-set numbers:

```latex
\problemset{B}                          % B1, B2, ... from here; \problemset{C} starts again at C1
\begin{problem}[label=B2$'$]            % this number as given; does not advance the count
\begin{problem}[label=C3, title=Compactness]
```

The brackets are read as options only when they hold nothing but the keys `label=` and `title=`; anything else is the title, so `[$f(x)=x^2$]` is still a title. `\label` and `\cref` show numbers such as B1 and B2′.

One file per problem:

```latex
\inputproblem{problems/p1}              % same as \begin{problem}\input{problems/p1}\end{problem}
\inputproblem[Cauchy sequences]{problems/B1}   % brackets as for problem: a title, or label=, title=
```

A problem file holds the statement and its `solution`; `ax both` works as usual. `problembreak=true` (or `\documentclass[problembreak]{akizumi-hw}`) starts every problem but the first on a new page.

Parts:

```latex
\begin{parts}[label=(\roman*)]          % enumitem keys in brackets; (a) (b) by default
  \item ...
  \begin{subparts} \item ... \end{subparts}   % (i) (ii), also takes keys
\end{parts}
```

Title and headers:

| Option | Meaning |
|---|---|
| `kind=homework\|assignment\|exercise\|report` | The title word: Homework / Assignment / Exercise / Report; in Chinese 作業 / 作業 / 習題 / 報告, Japanese 課題 / 課題 / 演習 / レポート, Korean 과제 / 과제 / 연습문제 / 보고서. Default `homework` |
| `header=author\|name-id` | Right side of the running header: the author (default), or "Author · ID" |
| `problembreak=true\|false` | Each problem on a new page; default `false` |

These three are `\documentclass` options and also work in `\akizumisetup{...}`. In every document kind except exams, `\akizumisetup` also takes `headleft=...` and `headright=...`, the text on the left and right of the running header; the first page's header is not affected.

## changelog

- Homework problems: grouped numbering with `\problemset{B}` (B1, B2, ...) and hand-set numbers with `\begin{problem}[label=B2$'$, title=...]`; `\inputproblem[title]{file}` for one file per problem and `problembreak=true` for one problem per page; `parts` takes enumitem keys and nests `subparts`; `kind=assignment|exercise|report` changes the title word (zh/ja/ko too); `header=name-id` and `\akizumisetup{headleft=..., headright=...}` set the running header; `ax new hw --problems 5` (or `B4,C2`) creates `problems/p1.tex` ... with `\inputproblem` lines.
