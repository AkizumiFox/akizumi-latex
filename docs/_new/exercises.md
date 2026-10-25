## zh

放在 docs/reference.md〈寫內容〉底下，〈作業與考卷專用〉之前，新增一節：

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

並在〈文件選項〉表格的 `solutions` 那一列改成：

| `solutions` | `true` `false`；書、講義另有 `inline` `chapter` `end` `hide` | 作業 `true`，考卷 `false`，書和講義 `inline` | 是否印出解答、印在哪裡（見〈習題與解答〉） |
| `exercisewithin` | `chapter` `section` `none` | 書 `chapter`，講義 `section`，其他 `none` | 習題、例題的編號單位 |

## en

In docs/reference.en.md, add a section under "Writing content", before "Homework and exams":

### Exercises and solutions (books, notes)

```latex
\begin{exercise}[Title]\label{ex:union}    % Exercise 3.2 (thmnames=native: 習題 3.2)
Compute $A\cup B$.
\end{exercise}
\begin{solution}                            % right after its exercise
$A\cup B=[-2,3]$.
\end{solution}

\section{Exercises}
\begin{exercises}[title]                    % end-of-section list; title prints "Exercises", title=Drills sets it
\label{drills:sets}                         % a \label before the first \item points at the section
\item A problem...
  \begin{enumerate} \item part \item part \end{enumerate}   % become (a) (b)
  \begin{solution} ... \end{solution}
\item The next one
\end{exercises}

\begin{example-problem}[title=Two Sum, source=LeetCode 1]   % sample problem, source on the right
...
\end{example-problem}
\printsolutions                             % print the solutions collected so far here
```

- `exercise` has its own counter: per chapter in books (3.2), per section in notes, plain in homework and exams (1, 2, ...); `exercisewithin=chapter|section|none` changes it. Items of an `exercises` list continue the same count, so `\cref` and solutions line up.
- `example-problem` has its own counter; with only a title write `[Shortest path]`, and `title={...}` when the title contains `=`. A `solution` after a sample problem is always printed in place.
- `parts`: (a) (b) subparts, as in homework.
- Names follow `thmnames`: Exercise / 習題 / 演習 / 연습문제, Sample Problem / 例題 / 例題 / 예제.

Where solutions go is set by `solutions`:

| Value | Effect |
|---|---|
| `inline` (default) | In place, with a thin left rule, like homework solutions |
| `chapter` | Collected and printed under "Solutions" at the end of each chapter (each section in notes) |
| `end` | Collected at the end of the document, or where `\printsolutions` is, grouped by chapter |
| `hide` | Not printed |

`chapter` and `end` write each solution's source to `build/<name>-sol.tex` and read it back, so solutions may contain `\verb` and `codeblock`. The exercise ends with "Solution on p. 12" linking to its solution, and the solution's "Exercise 3.2" links back (page numbers take two runs, which `ax build` does). `true` / `false` mean `inline` / `hide`, and `\def\akizumisolutions{false}` on the command line works too.

Homework and exams keep their own `solution` and `parts`, and `solutions=true|false` as before; `exercise`, `exercises` and `example-problem` work there too.

In the "Document options" table, replace the `solutions` row with:

| `solutions` | `true` `false`; books and notes also `inline` `chapter` `end` `hide` | homework `true`, exams `false`, books and notes `inline` | Whether and where solutions are printed (see "Exercises and solutions") |
| `exercisewithin` | `chapter` `section` `none` | books `chapter`, notes `section`, others `none` | What exercises and sample problems are numbered within |

## changelog

- Exercises for books and notes (`akizumi-exercise.sty`): `exercise` with its own per-chapter / per-section counter, `exercises` end-of-section lists with (a) (b) parts, `example-problem` with `source=`, `parts`, and `solution` with `solutions=inline|chapter|end|hide` (collected solutions print at chapter or document end, or at `\printsolutions`, linked both ways); names in the string table (Exercise / 習題 / 演習 / 연습문제). Homework and exams keep their own `solution`.
