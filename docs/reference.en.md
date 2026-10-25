# akizumi-latex reference

中文版：[reference.md](reference.md)

The [README](../README.en.md) gets you started; this page lists every feature and option, for when you need them. Complete examples are in [`examples/`](../examples/).

## ax new options and project contents

Run `ax new` with no arguments and it asks for the kind, folder and title. Options:

| Option | Meaning |
|---|---|
| `--title` | Title (homework doesn't need one; it becomes "Homework N") |
| `--author` | Author; defaults to `config.json` |
| `--course` | Course name; in the header and above the title for homework, notes and exams, above the title for books and slides |
| `--number` `--due` `--id` | Homework number, due date, student ID |
| `--lang en\|zh\|ja\|ko` | Main language; defaults to `config.json` |
| `--thmnames english\|native` | Theorem names in English (Theorem, Proof) or the main language (定理, 證明); defaults to `config.json` |
| `--text serif\|sans\|times\|palatino` `--paper a4\|letter\|pad` `--layout normal\|margin` | See [Document options](#document-options) |
| `--bib` | Adds `refs.bib` and a bibliography |
| `--code minted` | Highlight with minted: adds `code=minted` and writes `"shell_escape": true` to `.ax.json`, so `ax build`, `ax watch` and latexmkrc pass `-shell-escape`. `ax build` also adds it when the main file has `code=minted` or loads minted |
| `--progress` | Progress bar along the bottom of slides |
| `--venue neurips\|icml\|iclr\|aaai\|plain` | The venue of a paper (default `plain`); see [Papers](#papers) |
| `--split` | Paper: each section in its own file in `sections/` |
| `--anonymous` `--no-anonymous` | Paper: anonymous submission or camera-ready with names; venues default to anonymous, `plain` to names |
| `--git` | Creates a git repo and makes the first commit |
| `--no-preamble` | Leaves out your `preamble.tex` and `preamble-KIND.tex` this time (see [Your own preamble](../README.en.md#your-own-preamble)) |
| `--pin v0.8` | Template version to use; defaults to the newest tag. `--pin latest` always uses the installed files (for testing template changes) |
| `--problems 5` or `--problems B4,C2` | Homework: create `problems/p1.tex` ... `p5.tex` (with groups, `B1` ... `B4`, `C1`, `C2`) and load each from `main.tex` with `\inputproblem` |
| `--force` | Creates the project even if the folder exists and isn't empty |

`defaults` in `config.json` sets default options per kind; options on the command line win. For example, `"hw": {"byline": true}` makes new homework print the author and date under the title; `"paper": {"venue": "neurips", "split": true}` makes new papers NeurIPS papers with one file per section.

What each new project contains:

```
ode-hw3/
├── main.tex      preamble already filled in
├── latexmkrc     build settings (XeLaTeX, output to build/, SyncTeX); no machine-specific paths
├── .ax.json      kind and template version
├── .vscode/      build settings for Cursor / VS Code
├── .gitignore
├── figures/
└── refs.bib      only with --bib
```

Intermediate files go in `build/`; the only extra file in the folder is `main.pdf`.

## Writing content

The commands below work in every document kind (slides too, unless noted).

### Theorems, definitions, proofs

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

Available environments: `theorem` `lemma` `proposition` `corollary` `claim` `definition` `assumption` `example` `remark` `proof`, each with an unnumbered form (`theorem*` and so on). A thin line on the left marks where each one starts and ends. Names are English (Theorem, Proof) whatever the main language, unless you set `thmnames=native` (see [Cross-references](#cross-references)).

A theorem can be restated and proved in the appendix:

```latex
\begin{restatable}{theorem}{cramerwold}\label{thm:cw} ... \end{restatable}

% appendix
\cramerwold*                              % same number, same text
\begin{proofof}{thm:cw} ... \end{proofof} % "Proof of Theorem 1.2." linking back
```

`\listoftheorems` lists every theorem-like environment (restated copies aren't listed twice).

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
\akizumiNewTheorem{tool}{Tool}{工具}{道具}{도구}[counter=own, prefix=T, within=none]  % T1, T2, ...
\akizumiNewTheorem{unit}{Unit}{}{}{}[style=definition]
```

Options: `style=theorem|definition|remark` (bar and label style, default `theorem`), `bar=1pt`, `barcolor=mute`, `counter=own|<another kind>` (default from `thmcounter`), `prefix=T`, `within=chapter|section|none`, `plural=Tools` (English plural for `\cref`, default adds an s). Names follow `thmnames`: English by default, the main language with `thmnames=native`.

Changing how an existing kind is numbered:

```latex
\akizumiSetTheorem{assumption}{counter=own, prefix=A, within=none}  % A1, A2, ...
```

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
| chapterguide | Chapter guide / 本章導覽 (notes, slides: Guide / 導覽) | label on its own line, faint accent background; `\guidehead{...}` makes headings inside |
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

### Math

| Input | Result |
|---|---|
| `\vb{x}`, `\vb{A}` | Vectors and matrices in upright bold; Greek letters switch to bold italic / bold upright automatically (`vb=upright` makes lowercase Greek upright too). `\bvec` is the same command |
| `\vb{x}\T` | Transpose |
| `\norm{x}`, `\abs{x}`, `\inner{x, y}`, `\set{x}`, `\floor{x}`, `\ceil{x}` | Paired delimiters; the starred form `\norm*{...}` sizes them automatically, `\norm[\big]{...}` picks a size |
| `\set{x \given x > 0}`, `\Prob{A \given B}` | `\given` is a spaced \|; inside `\set` and `\Prob` it grows with the delimiters |
| `\E`, `\Var`, `\Cov`, `\Corr`, `\KL`, `\sg` | Expectation, variance and similar operators |
| `\tr`, `\rank`, `\diag`, `\spn`, `\nullity`, `\im`, `\adj`, `\col`, `\row`, `\nul`, `\id` | Linear algebra (`\spn` prints span) |
| `\supp`, `\vol`, `\Bd`, `\Int`, `\diam`, `\lcm` | Analysis, topology, number theory |
| `\argmin`, `\argmax`, `\plim` | Subscript set directly below |
| `\Prob{A}`, `\Normal{\mu}{\sigma^2}`, `\Bern{p}`, `\Bin{n}{p}`, `\Pois{\lambda}`, `\Geom{p}`, `\Unif{a}{b}` | Probability and distributions; delimiters as above |
| `X \indep Y`, `X_i \iid F` | Independence, i.i.d. |
| `\R`, `\N`, `\Z`, `\Q`, `\C`, `\mathbb{1}` | Blackboard bold (bboldx, including digits and lowercase) |
| `\mathscr{F}` | Script letters (RSFS) |
| `\mathbbm{1}`, `\mathbbmss{R}` | bbm-style input still compiles and prints as `\mathbb` (without bbm's bitmap fonts) |
| `\cvec{1, 2, 3}`, `\cvec[p]{a, b}` | Column vector in brackets; `[p]` for parentheses (also `v`, `V`, `B`) |
| `\int f(x) \dd x` | Upright d |

You can write Chinese in math mode, e.g. `$x_{最大}$`.

**Living with your own macros.** Each name above is provided only if nothing defines it yet. A later `\newcommand`, `\DeclareMathOperator` or `\DeclarePairedDelimiter` of the same name in your preamble no longer stops with "already defined": your definition is used. `\def` and `\renewcommand` replace them as always. So old shortcuts files and the `math_commands.tex` of ICLR / NeurIPS can be `\input` as they are. `mathclash=error` brings back LaTeX's error; `mathskip={vb, E}` leaves those names undefined. `ax doctor` lists the akizumi-math macros a project redefines, and files whose single-letter `\def` overwrites accent commands like `\c` and `\v`. `\NewDocumentCommand` is not covered; use `\RenewDocumentCommand` there.

**Letter shortcuts (opt-in).** Pick them with `letters=`, one or several, e.g. `letters={bold, cal}`:

| Value | Provides |
|---|---|
| `bold` | `\va`…`\vz`, `\vA`…`\vZ`, `\vzero`, `\vone`, i.e. `\vb{a}` and so on. A bare `\vb` (no brace after it) is bold b |
| `cal` | `\sA`…`\sZ`, i.e. `\mathcal{A}` and so on |
| `bb` | `\nA`…`\nZ`, i.e. `\mathbb{A}` and so on |
| `greek` | `\valpha`…`\vomega`, `\vGamma`…`\vOmega`, i.e. `\vb{\alpha}` and so on |
| `all` | The four sets above |
| `single` | `\a`…`\z` are bold in math; in text `\c{c}`, `\v{s}`, `\d{h}`, `\i`, `\o` stay accents and special letters. No uppercase single letters, since `\R`, `\E`, `\T` are taken |

Names that already exist are never overwritten.

### Cross-references

Always use `\cref`; it adds the name for you:

```latex
見\cref{thm:cw}、\cref{def:collapse}、\cref{eq:loss}。
```

English documents get "Theorem 1.2", "Definition 1.1", "Equation (1.1)". When the main language is Chinese, Japanese or Korean, sections, figures, tables, equations and problems follow it:

| | Section | Figure | Equation | Problem |
|---|---|---|---|---|
| `lang=zh` | 第 1 節 | 圖 1 | 式 (1.1) | 第 1 題 |
| `lang=ja` | 第 1 節 | 図 1 | 式 (1.1) | 問 1 |
| `lang=ko` | 제1절 | 그림 1 | 식 (1.1) | 문제 1 |

Theorem names stay English by default; `thmnames=native` switches them to the main language:

| | theorem | lemma | corollary | remark | proof | solution |
|---|---|---|---|---|---|---|
| `zh` | 定理 | 引理 | 推論 | 註 | 證明 | 解 |
| `ja` | 定理 | 補題 | 系 | 注意 | 証明 | 解答 |
| `ko` | 정리 | 보조정리 | 따름정리 | 참고 | 증명 | 풀이 |

`proofof` follows: 定理 1.2 的證明, 定理 1.2 の証明, 정리 1.2의 증명.

### Bibliography

Add `--bib` when creating the project, or add the `bib=refs.bib` option to an existing document:

```latex
\documentclass[bib=refs.bib]{akizumi-note}
...
As MR.Q~\cite{fujimoto2025mrq} shows.
...
\printbibliography
```

By default: numeric, in citation order, ranges compressed to `[1–3]`, and each entry lists the pages that cite it. `ax build` runs biber for you.

Three more options go next to `bib=`:

| Option | Values | Default | Effect |
|---|---|---|---|
| `bibstyle` | `numeric` `authoryear` `apa` | `numeric` | `authoryear` gives (Lin, 2026) with entries sorted by author; `apa` is APA 7th edition |
| `backref` | `true` `false` | `true` | List the pages that cite each entry |
| `cite` | `normal` `super` | `normal` | `super` makes `\cite` a superscript number (`numeric` only); write `models\cite{key}` with no space before it |

```latex
\documentclass[bib=refs.bib, bibstyle=authoryear, backref=false]{akizumi-note}
\citet{lin2026} propose ...; later work \citep{lin2026, sutton2018}.
```

`\citep` (in parentheses), `\citet` (author as subject) and `\citeauthor` work in every `bibstyle`, as in natbib.

### Code

```latex
\begin{codeblock}[lang=Python, title=sigreg.py]
def sigreg(z, num_dirs=64):
    u = torch.randn(z.shape[1], num_dirs)   # random directions
    return epps_pulley(z @ u).mean()
\end{codeblock}

\inputcode[lang=Python]{train.py}     % read a file
\code{loss.backward()}                % inline
```

Light grey background with line numbers (`numbers=false` turns them off). Long lines wrap and are marked with ↪; a block that breaks across pages shows `cont.` at the top right of the continuation. On slides the frame needs `[fragile]`.

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
\inputcode[lang=cpp, lines=10-24]{main.cpp}  % only lines 10-24, numbered as in the file (10-24)
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

### Algorithms, notation tables

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

### Logic and programming-language notation

Load it yourself: `\usepackage{akizumi-logic}`. Documents that don't are unchanged. It also works in a plain pdfLaTeX document (it supplies its own colors and English words).

```latex
\usepackage[connectives=classic]{akizumi-logic}

\begin{fitch}                               % Fitch proof (fitch package); same as \[ \begin{nd} ... \end{nd} \]
  \hypo{1}{A \limp B}   \by{\RulePremise}{}
  \open
  \hypo{2}{A}           \by{\RuleA[\RuleImpI]}{}   % A / →I
  \have{3}{B}           \by{\RuleImpE}{1,2}        % 1, 2 →E
  \close
  \have{4}{A \limp B}   \by{\RuleImpI}{2-3}
\end{fitch}

\begin{prooftree}                           % inference rules (ebproof)
  \hypo{\Gamma \vdash t : \sigma \limp \tau} \hypo{\Gamma \vdash s : \sigma}
  \infer2[app]{\Gamma \vdash t\,s : \tau}
\end{prooftree}

\begin{truthtable}{cc|ccc}                  % truth table; every cell is math
  A & B & A & \main{\land} & B \\ \midrule
  \tvrow{TT|T!TT}                           % one character per cell; | and spaces skipped, - empty, ! main connective
\end{truthtable}

\begin{calc}                                % calculation; breaks across pages
  \fn{sum}\;[1,2]
  \step{=}{def.\ of $\fn{sum}$}             % hint in { } on its own line
  1 + \fn{sum}\;[2]
  \step{=}{}                                % no hint: the relation goes before the next line
  3
\end{calc}

\begin{funcdef}                             % function definition: two left-aligned columns
  \fn{zip} &: \fn{List}\;a \to \fn{List}\;b \to \fn{List}\;(a, b) \\
  \fn{zip}\;[]\;ys &= []
\end{funcdef}

$\sem{e}\rho$  $\sem*{\frac{a}{b}}$  $\sem[\big]{e}$  % semantic brackets ⟦ ⟧
```

- **Connectives**: `\limp` (conditional) and `\liff` (biconditional); `\land` `\lor` `\lnot` follow the option too. `connectives=modern` (default, ∧ ∨ ¬ → ↔), `classic` (& ∨ ~ ⊃ ≡, Bergmann-style textbooks), `arrows` (∧ ∨ ¬ ⇒ ⇔). `\implies` is left alone.
- **Rule names**: `\RuleAndI` `\RuleAndE` `\RuleOrI` `\RuleOrE` `\RuleImpI` `\RuleImpE` `\RuleIffI` `\RuleIffE` `\RuleNotI` `\RuleNotE` `\RuleBotI` `\RuleBotE` `\RuleDNI` `\RuleDNE` `\RuleAllI` `\RuleAllE` `\RuleExI` `\RuleExE` `\RuleEqI` `\RuleEqE`, with an optional subscript: `\RuleAndE[1]` (∧E₁). Also `\RuleR` `\RuleMT` `\RuleRAA` `\RuleLEM`, `\RuleA` (A; `\RuleA[\RuleNotI]` is "A / ¬I"), `\RuleAssumption` `\RulePremise` (worded per `lang`). All start with `\Rule`, so `\ni` (∋), `\ne` (≠) and `\r` keep their meaning. `rulecase=lower` gives →i, →e.
- **Fitch proofs** use TeX Live's `fitch` package (`\hypo` `\have` `\open` `\close` `\by`; `ndresume` continues a proof). Scope lines, line numbers and justifications are muted, justifications one size smaller. `\by{rule}{lines}` reads "1, 2 →E" by default; `just=rule-first` gives "→E, 1, 2". fitch's own short macros (`\ii` `\ne` `\r` ...) are off; `fitchrules` turns them on.
- **lmodern**: with akizumi-logic loaded, packages that load lmodern (proofpack, for one) no longer replace the body fonts.
- `\rulename{...}` is the rule-label style (one size smaller, muted); ebproof labels use it, and you can too.
- `\fn{map}` is a sans-serif function name.

### Figures

```latex
\begin{figure}[t]
  \centering
  \begin{subfigure}{0.45\linewidth} \includegraphics[width=\linewidth]{figures/a.pdf} \caption{...} \end{subfigure}
  \begin{subfigure}{0.45\linewidth} ... \end{subfigure}
  \caption{...}\label{fig:x}
\end{figure}
```

TikZ pictures can use the same styles as the slides:

```latex
\begin{tikzpicture}
  \node[akizumi/box] (a) {encoder};
  \node[akizumi/box, right=1cm of a] (b) {$\vb{z}$};
  \draw[akizumi/arrow] (a) -- node[above, akizumi/note] {sg} (b);
\end{tikzpicture}
```

TikZ loads only `arrows.meta`, `positioning`, `calc` and `shapes.geometric` by default. For 3D figures, angles, braces, hatching or automata, add `tikz=full` to `\documentclass` (slides: `\usetheme[tikz=full]{Akizumi}`); it also loads `3d`, `angles`, `quotes`, `decorations.pathreplacing`, `decorations.markings`, `patterns`, `fit`, `backgrounds`, `shapes`, `tikzmark`, `automata` and `intersections`. `plots` loads pgfplots (`compat=1.18`): lines take `accent`, `warn`, `plotgreen`, `plotpurple`, `mute` in turn, heat maps use a pale-grey-to-`accent` colormap, and axes and grids are light grey.

```latex
\documentclass[tikz=full, plots]{akizumi-note}
...
\begin{axis}[axis lines=middle, grid=major]
  \addplot+[domain=0:4] {x/(1+x)};   % the first line is accent
\end{axis}
```

Common figures have ready-made styles, so documents need not define their own:

| For | Styles | Notes |
|---|---|---|
| Arrays | `akizumi/cell`, `akizumi/hlcell`, `akizumi/hlcell2`, `akizumi/index` | 0.9 cm cells whose borders overlap when placed 0.9 cm apart; `hlcell` marks the current index (blue), `hlcell2` a second focus (orange); `index` is the small grey label under a cell |
| Flowcharts | `akizumi/start`, `akizumi/process`, `akizumi/decision`, `akizumi/io`, `akizumi/group` | Start/end, step, test (diamond), input/output (parallelogram), dashed group box (with `fit` and `on background layer`); arrows are `akizumi/arrow` |
| Automata | `[akizumi/automaton]`, `akizumi/state`, `akizumi/accepting` | On the `tikzpicture`, it styles `state`, `accepting`, `initial` and `edge`; `initial`, loops and `edge["$a$"]` need `tikz=full` |
| Game trees | `akizumi/game/decision`, `/chance`, `/terminal`, `/branch`, `/action`, `/payoff`, `/infoset` | Decision node (filled), chance node (hollow), terminal (small grey dot), branch arrow, action label, payoff, information set (grey dashes) |
| Physics | `\pic {akizumi/current in};`, `\pic {akizumi/current out};`, `akizumi/wire` | Current into / out of the page, drawn over the wire; `\pic[accent] at (A) {akizumi/current in};` recolors it |

```latex
\begin{tikzpicture}[akizumi/automaton]
  \node[state, initial] (q0) {$q_0$};
  \node[state, accepting, right=of q0] (q1) {$q_1$};
  \path[->] (q0) edge["$a$"] (q1) (q1) edge[loop above] node {$b$} ();
\end{tikzpicture}
```

### Mixing languages

No markup needed. Whether or not you type a space between Chinese and English, the spacing comes out right. `\emph{強調}` is bold in Chinese, Japanese and Korean (they have no italic); English stays italic.

Chinese, Japanese and Korean can share one document: characters the main language's font lacks (Traditional Chinese characters missing from a Japanese font, Hangul missing from a Chinese font) are taken from the other two languages' fonts automatically. Korean keeps the spaces between words as typed.

### Chinese reports

The layout of class reports, reflections and proposals:

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

- `subtitle` goes under the title; the `info` items follow on one centred line, labels muted and values in body colour; an item without `=` is printed as is. Works for homework, notes, exams and the book cover (not slides).
- The options are independent, so any subset works; without them the layout is exactly as before.

### Other small tools

| Command | Effect |
|---|---|
| `\todo{derive this}` | Orange `[TODO: derive this]` |
| `\blindfootnote{...}` | Footnote without a number, e.g. "Adapted from …" |
| `\sidenote{...}`, `\marginnote{...}` | Margin notes (in the margin only with `layout=margin`; otherwise ordinary footnotes) |
| `\muted{...}` | Grey text |

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

### Homework and exams

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

Exams use the [exam](https://ctan.org/pkg/exam) syntax: `\begin{questions} \question[10] ... \begin{parts} \part[5] ...`; `\gradetable` makes the grading table.

Solutions: homework shows them by default, `\documentclass[solutions=false]{akizumi-hw}` hides them; exams hide them by default, `solutions=true` shows them. `ax both` saves you switching by hand.

### Slides

```latex
\begin{frame}[plain,noframenumbering]\titlepage\end{frame}
\q{Is this a discussion question?}  % prompt starting with a blue Q:
\standoutframe{Questions?}          % one line on a full blue page
\appendix                           % later slides numbered separately, not in the total
\dividerframe{Appendix}
```

Each `\section` gets a "Part N" slide in front of it automatically.

### Books

```latex
\frontmatter \maketitle \tableofcontents
\mainmatter
\chapter{Introduction}
\chaptertoc            % contents of this chapter
...
\appendix \chapter{Proof details}
\backmatter \printbibliography
```

`\maketitle` is a full cover page; the header shows the chapter on the left and the section on the right.

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

## Document options

Put them in `\documentclass[...]` (for slides, `\usetheme[...]{Akizumi}`):

| Option | Values | Default | Effect |
|---|---|---|---|
| `lang` | `en` `zh` `ja` `ko` | `en` | Main language: date format, contents / figure / table names, problem labels, line spacing, CJK fonts |
| `text` | `serif` `sans` `times` `palatino` | `serif` | Body font. `serif` is New Computer Modern (same design as the math); `sans` uses Lato throughout; `times` and `palatino` use TeX Gyre Termes / Pagella (math stays Computer Modern). Headings and labels are Lato either way |
| `bb` | `light` `regular` `ams` | `light` | Weight of blackboard bold; `ams` is the classic AMS font (capitals only) |
| `paper` | `a4` `letter` `pad` | `a4` | Paper; `pad` is a 3:4 layout for reading on a tablet |
| `layout` | `normal` `margin` | `normal` | `margin` leaves a wide margin for `\sidenote` (notes, books) |
| `thmnames` | `english` `native` | `english` | Theorem, proof, solution and similar names in English or the main language (see [Cross-references](#cross-references)) |
| `thmcounter` | `shared` `grouped` `split` | `shared` | One counter for every theorem-like kind, three groups, or one per kind (see [Theorems, definitions, proofs](#theorems-definitions-proofs)) |
| `thmwithin` | `chapter` `section` `none` | notes `section`, books `chapter`, others `none` | Prefix theorem numbers with the chapter or section |
| `asides` | `numbered` `unnumbered` | `numbered` | `unnumbered`: example, remark and remarks get no number |
| `aliases` | `none` `short` | `none` | `short`: adds short names such as `thm` `lem` `prop` `cor` |
| `thmname` | `{kind=name, ...}` | | Renames a kind, e.g. `thmname={corollary=系理}` |
| `byline` | `false` `true` | `false` | Whether "author · ID · date" goes under the title. By default it goes on the right of the first page's header instead (course on the left). The book cover always shows it |
| `bib` | file name | | Loads the bibliography, e.g. `bib=refs.bib` |
| `solutions` | `true` `false`; books and notes also `inline` `chapter` `end` `hide` | homework `true`, exams `false`, books and notes `inline` | Whether and where solutions are printed (see [Exercises and solutions](#exercises-and-solutions-books-notes)) |
| `exercisewithin` | `chapter` `section` `none` | books `chapter`, notes `section`, others `none` | What exercises and sample problems are numbered within |
| `10pt` `11pt` `12pt` `13pt` `14pt`, `fontsize` | e.g. `fontsize=13pt` | `11pt` | Font size. `13pt`, `14pt` and any `fontsize=` go through scrextend |
| `cjk`, `cjk-bold` | font name | picked per language | Replaces the CJK sans font |
| `par` | `skip` `indent` | `skip` | Paragraphs. `indent` indents every paragraph's first line by 2em (the first after a heading too) with no space between paragraphs, as Chinese reports do |
| `secnum` | `arabic` `zh` | `arabic` | `zh` numbers sections 一、, subsections （一）, subsubsections 1.; book chapters read 第一章. Theorem and equation numbers stay Arabic (定理 1.2); `\cref` gives 第一節 and 一（一） |
| `kai` | | | Chinese body text in a Kai face: Kaiti TC (macOS) > BiauKai (macOS) > DFKai-SB (Windows) > AR PL UKai (Linux) > STKaiti > FandolKai (ships with TeX Live, Simplified only, with a warning). Works with `text=sans` too; headings keep the sans face |
| `cjk-serif`, `cjk-serif-bold` | font name | Songti | Replace the CJK face and its bold for serif body text (`text=serif\|times\|palatino`), e.g. `cjk-serif-bold=Noto Serif CJK TC SemiBold`. With only `cjk-serif`, or a Kai face without bold, bold is synthesised |
| `delims` | `manual` `auto` | `manual` | `auto` makes `\abs`, `\norm`, `\set`, `\Prob` and the other paired delimiters size themselves without the star; the starred form then keeps the natural size |
| `letters` | `bold` `cal` `bb` `greek` `all` `single` | none | Letter shortcuts, see [Math](#math) |
| `vb` | `auto` `upright` | `auto` | `upright` makes lowercase Greek in `\vb{\alpha}` upright bold too (upgreek) |
| `units` | `false` `true` | `false` | Loads siunitx: `\qty{9.8}{\metre\per\second\squared}`, `\unit{kg}`, `\num{12345}` |
| `mathclash` | `yield` `error` | `yield` | When you define a macro akizumi-math also has, `yield` uses yours, `error` stops as LaTeX normally does |
| `mathskip` | list of names | | These macros are not defined at all, e.g. `mathskip={vb, E}` |
| `code` | `listings` `minted` | `listings` | Highlighting engine. `minted` uses Pygments (better colours, more languages); it needs shell escape and Pygments (the `latexminted` that ships with TeX Live 2024+ is enough) and otherwise warns and stays with listings |
| `verbatim` | `plain` `styled` | `plain` | `styled` gives `verbatim` the code background and size |
| `tikz` | `basic` `full` | `basic` | `full` (or bare `tikz`) also loads the 3d, angles, patterns, tikzmark, automata and other TikZ libraries (see [Figures](#figures)) |
| `plots` | `true` `false` | `false` | Loads pgfplots, colored to match the templates |
| `index` | `false` `true` | `false` | Subject index and list of notation: `\index`, `\nota`, `\printindex`, `\printnotation` (see [Index and list of notation](#index-and-list-of-notation)) |
| `index-sort` | `stroke` `zhuyin` `pinyin` `radical` | `stroke` | Chinese sort order of the index with `lang=zh` (needs upmendex) |
| `legacy` | `true` `false` | `true` | Old document bodies compile unchanged (see [Moving old documents over](#moving-old-documents-over)); `false` turns this off |
| `sharedpreamble` | `true` `false` | `true` | Reads the `.akizumi/preamble.tex` found upwards (see [One preamble for a whole course](#one-preamble-for-a-whole-course)); `false` skips it |

Slides also take `progress` (progress bar along the bottom); `tikz` and `plots` work in slides too. For slides, give the math options before `\documentclass`: `\PassOptionsToPackage{delims=auto, letters=bold}{akizumi-math}`.

## ax commands in detail

Except `new`, `doctor`, `config`, `completion` and `migrate`, commands run inside a project folder; a subfolder such as `figures/` works too, since `ax` looks upward for `.ax.json` the way git does.

`ax` speaks Chinese or English. It follows the system language; `"ui": "en"` or `"ui": "zh"` in `config.json`, or the environment variable `AX_LANG`, overrides it.

| Command | Effect |
|---|---|
| `ax` | In a project: kind, template version (with a note when a newer one exists), when the PDF was last updated, common commands. Outside a project: help |
| `ax new` | Creates a project (see [ax new options](#ax-new-options-and-project-contents)) |
| `ax build` | Compiles once and shows how long it took. Replaces `main.pdf` only on success; on failure prints the file, line number and source line of the first error with a plain-language hint, and keeps the old PDF |
| `ax watch` | Recompiles on every save and reports each success or failure; opens Skim if you have it |
| `ax watch --bg` | Watches in the background and gives the terminal back at once; output goes to `build/watch.log`, and it keeps running after the terminal closes. One per project |
| `ax watch --status` / `--log` / `--stop` | Whether a background watcher runs and how its last build went (with the first error on failure) / follow its output / stop it. While one runs, `ax build` and `ax both` warn that they share `build/` |
| `ax open` | Opens the PDF in the system's default viewer; `--solutions` opens the answer key |
| `ax both` | Homework / exams: `main.pdf` (questions) and `main-solutions.pdf` (answers) |
| `ax build --chapter N` | Build chapter N alone into `main-chN.pdf`; `main.pdf` is left as it is. Chapter and page numbers and references to other chapters come from the last full build, so run `ax build` once first. `N` may be a chapter number, an appendix letter (`A`), or the `\include`d file's or folder's name; `--chapter 3,5` builds two, into `main-ch3+5.pdf`. `ax watch --chapter N` works the same way |
| `ax count` | Count English words plus CJK characters (CJK counted per character, Korean too), leaving out commands, math, code, `\label` / `\ref` / `\cite`, comments and the preamble. Follows `\input` / `\include` / `\subfile` (and `\chapterdir`) and lists each file when there are several. `--limit 3000` warns above the limit |
| `ax doctor` | Checks tools, fonts, template installation and versions, then lists what's wrong and how to fix it; it also reports whether upmendex (CJK index sorting) is there. Inside a project it also checks the programs `prebuild` calls, inkscape when the `svg` package or `\includesvg` is used (and whether `shell_escape` is on), that every package the project `\usepackage`s is found (ones outside TeX Live, such as `stata.sty`, belong in the project folder), which akizumi-math macros the project redefines, and files whose single-letter `\def`s replace accent commands |
| `ax upgrade` | Moves the project to the newest template version and refreshes `latexmkrc` and editor settings |
| `ax freeze` | Copies the template files into the project so it no longer depends on this repo |
| `ax pack` | Packs `<folder>-overleaf.zip` and tells you which compiler to pick after uploading |
| `ax config` | Where the config folder, `config.json`, preambles and template cache are |
| `ax completion zsh\|bash\|powershell` | Prints a tab-completion script; see `ax completion --help` for setup |
| `ax migrate FILE.tex` | Rewrite an old document for akizumi as a copy, `FILE-akizumi.tex`, leaving the original alone; list macros that clash with akizumi's (see [Moving old documents over](#moving-old-documents-over)) |
| `ax selftest` | Rebuilds every example and creates and builds every kind of project (after changing the templates; see [Maintaining the templates](#maintaining-the-templates)) |
| `ax --version` | Newest template version |

A failed `ax build` looks like this:

```
✗ Build failed: main.tex
  ./main.tex:10: Missing $ inserted.
    l.10 x_
           1 not in math mode
  Hint: Math symbols (_, ^, \alpha, ...) must be inside $...$
  The previous main.pdf is kept
  Full log: build/main.log
```

The two `l.10` lines are line 10 of the source, broken where the error happened.

`ax build` also handles a few common situations:

- When latexmk remembers a previous failure and refuses to rerun, it cleans up and retries once.
- It stops a build that runs over 10 minutes (usually one waiting for input).
- When you mistype a command, document kind or option value, it guesses what you meant, e.g. `ax biuld` → `ax build`.
- With output redirected to a file, or `NO_COLOR` set, it drops colour and the spinner.

### Steps before compiling, and shell escape: `.ax.json`

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

## Version pinning

The templates keep changing, but homework from three months ago should still compile as it was. So **each project remembers the template version it uses**:

- When the project is created, `.ax.json` records the newest version at the time (e.g. `"template": "v0.4"`).
- When the templates move on to v0.5, this project still compiles with v0.4. Each version's files live in the cache: `~/Library/Caches/ax/<version>/` on macOS, `~/.cache/ax/` on Linux, `%LOCALAPPDATA%\ax\Cache` on Windows.
- When you want the new look, run `ax upgrade` in the project, then `ax build` to check.

This holds in the editor too: the project's `latexmkrc` asks `ax` for the version, so latexmk called from the editor uses the same one.

To hand a project in or archive it:

```sh
ax freeze    # copies that version's .sty / .cls into the project; it then compiles on its own
ax pack      # zip with the template files included, ready to upload to Overleaf
```

After uploading to Overleaf, pick **XeLaTeX** under Menu → Compiler (pdfLaTeX for `paper`). Overleaf has no PingFang or Songti, so Chinese falls back to Noto CJK; it looks slightly different but compiles.

## Using the templates without ax

The templates are ordinary LaTeX classes and work in any folder:

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

Classes: `akizumi-hw`, `akizumi-note`, `akizumi-exam`, `akizumi-book`; for slides use `\documentclass[aspectratio=169]{beamer}` with `\usetheme{Akizumi}`.

For conference papers, see [Papers](#papers) below.

## Papers

A venue requires its own template, whose look you can't change, so a `paper` project uses pdfLaTeX, loads none of the akizumi styling, and borrows two engine-agnostic packages:

```latex
\usepackage{akizumi-math}                    % \vb, \norm, \E, \argmin, ...
\usepackage[refstyle=short]{akizumi-paper}   % comments, abbreviations, table marks
```

akizumi-math's options work there too, e.g. `\usepackage[delims=auto, letters=bold]{akizumi-math}`.

**Starting one**

```sh
ax new paper flora --venue neurips --split
```

| `--venue` | What main.tex gets |
|---|---|
| `neurips` | `\usepackage{neurips_2026}`, `[final]` for the camera-ready; the style loads natbib (uncomment the `\PassOptionsToPackage{numbers, compress}{natbib}` line for numeric citations); a place for the checklist at the end |
| `icml` | `\usepackage{icml2026}`, `[accepted]` for the camera-ready; the `\twocolumn[...]` author block, `\bibliographystyle{icml2026}` |
| `iclr` | `\usepackage{iclr2026_conference,times}`; `\iclrfinalcopy` for the camera-ready |
| `aaai` | `\usepackage[submission]{aaai2026}` and AAAI's do-not-change lines; **no hyperref** (AAAI forbids it) |
| `plain` | A plain `article` with hyperref (and `[numbers]natbib` with `--bib`) |

Venues publish new `.sty` and `.bst` files every year, so they are **not included**: a comment at the top of `main.tex` names the file and where to download it, and `ax new` reminds you. For another year, change the name. Venue projects always get `refs.bib`.

The anonymity switch is at the top of `main.tex`:

```latex
\newif\ifanonymous \anonymoustrue    % \anonymousfalse for the camera-ready version
```

It switches the venue's option (`[final]`, `[accepted]`, `\iclrfinalcopy`, `[submission]`) and `\anon` below. `--split` creates `sections/introduction.tex`, `related`, `method`, `experiments`, `conclusion` and `appendix`, joined with `\input` in `main.tex`.

ICLR's `math_commands.tex` also defines `\E`, `\R`, `\Var`, ...; load it after akizumi-math and its definitions win (see "Living with your own macros" under [Math](#math)).

**akizumi-paper**

Load it last in the preamble (after hyperref, and after xcolor or cleveref if you load them with options of your own). It works in the akizumi classes too.

```latex
\newcommenter{jun}{Jun}{teal}
\jun{is this bound tight?}   % comment: "[Jun: is this bound tight?]" in teal
\jun*{a rewritten clause}    % edit: the text itself in teal
```

| Command | Result |
|---|---|
| `\newcommenter{name}{Label}{color}` | Defines `\name{comment}` and `\name*{edit}`; one color per co-author |
| `\eg` `\ie` `\etal` `\cf` `\wrt` `\etc` | *e.g.*, *i.e.*, *et al.*, *cf.*, w.r.t., etc.; no doubled period at a sentence end, and no sentence-wide space after them |
| `\best{0.91}` `\second{0.88}` | Bold, underlined (bold math too) |
| `\cmark` `\xmark` | ✓, ✗ |
| `\anon[replacement]{text}` | The replacement (default Anonymous) while anonymous, e.g. for your own earlier paper |

It also loads booktabs, multirow, makecell, and cleveref unless it is loaded already.

| Option | Effect |
|---|---|
| `final` | Comments disappear (leaving no extra space) and edits stay as ordinary text; add it before submitting |
| `anonymous` | `\anon` prints its replacement |
| `refstyle=short` | `\cref` gives Fig. 1, Figs. 1 and 2, Eq. (2); sections and tables keep full names. English only: CJK names are already short. Default `long` |

The same keys can be set later in the preamble with `\akizumipapersetup{final}`.

## Design rules

**Fonts**

| Use | Font |
|---|---|
| Body text | New Computer Modern Book (serif); Chinese in Songti |
| Headings, sections, theorem labels, headers and footers, slides | Lato; Chinese in PingFang |
| Math | Computer Modern; blackboard bold from bboldx |
| Code | JetBrains Mono (if installed) |

**Left bars on theorem-like environments**: a single blue, varied by weight and tone only.

| Environment | Bar | Label |
|---|---|---|
| theorem, lemma, proposition, corollary, claim | thick, blue | blue bold |
| definition, assumption | thick, light blue | blue bold |
| example, remark | thin, grey | black bold |
| proof, solution | thinnest, light grey | grey bold, ends with □ |

Bodies are always upright; they can break across pages, and a label is never left alone at the bottom of a page.

**Colours** (usable in `\color{...}` and TikZ): `ink` body text, `mute` secondary text, `accent` blue highlight, `warn` orange alert, `rule` hairlines, `wash` faint grey background, plus three soft fills `softred` `softamber` `softgreen`.

**Other commands**: `\akizumisep` (the "A · B" separator; no space before it), `\akizumirule` (hairline), and the table column type `Y` (left-aligned, wrapping).

## Maintaining the templates

```
akizumi-math.sty        math macros (engine-agnostic)
akizumi-paper.sty       writing helpers for papers: comments, abbreviations, table marks (engine-agnostic)
akizumi-logic.sty       logic and programming-language notation (load it yourself)
akizumi-core.sty        shared core: fonts, colours, theorems, code, layout; loads the files below
akizumi-code.sty        more for code: numbering and list, kinds, inline highlighting, terminal, minted
akizumi-theorems.sty    theorem options, extra kinds, \akizumiNewTheorem
akizumi-callout.sty     callouts, \akizumiNewCallout, \optional
akizumi-exercise.sty    exercises, sample problems and where solutions go
akizumi-tikz.sty        TikZ libraries, pgfplots, figure styles
akizumi-bib.sty         bibliography (with bib=)
akizumi-index.sty       index and list of notation
akizumi-zhlayout.sty    Chinese report layout
akizumi-compat.sty      old documents, shared course preamble
akizumi-build.sty       \chapterdir
akizumi-hw.cls          homework
akizumi-problems.sty    homework numbering, groups, one file per problem, kind=, header=
akizumi-note.cls        notes
akizumi-exam.cls        exams (on top of exam)
akizumi-book.cls        theses, books
akizumi-booklayout.sty  book layout (two-sided, parts, chapter subtitles, cover fields)
beamerthemeAkizumi.sty  slides
skeletons/            body skeletons used by ax new
examples/             a complete example of each kind, doubling as tests
bin/                  ax (ax.cmd for Windows), akizumi-both, biber fix (macOS)
install.py            installer (all three systems)
.github/workflows/    automatic tests on Linux, Windows and macOS
```

After changing the templates:

```sh
ax selftest             # rebuild every example in examples/, then create and build every kind of project
ax selftest examples    # examples only (same as make check)
ax selftest projects    # ax projects only (same as make test-ax)
```

The Linux, Windows and macOS tests run on GitHub Actions: automatically when a version tag is pushed, or by hand with `gh workflow run test`. Results are on the repo's Actions page.

Releasing a new version (so new projects use it and old ones can `ax upgrade`):

1. Update `CHANGELOG.md`.
2. Change the version in each file's `\ProvidesPackage` / `\ProvidesClass`.
3. `ax selftest`.
4. `git commit`, then `git tag -a v0.8 -m v0.8 && git push && git push --tags` (pushing the tag starts the CI tests).

Changes without a tag only affect `examples/` and documents that use the templates directly, never projects pinned to a version.

## Troubleshooting

**`ax doctor` reports a biber problem, or every citation is a question mark (macOS)**
TeX Live 2026's biber calls `lipo -extract_family` at startup, an argument recent Command Line Tools have dropped; the error reads `extracting arm64 binary with lipo failed`. When `install.py` detects this it links `bin/biber` to `~/bin/biber`, which extracts the native-architecture binary with `lipo -thin` and re-extracts it when TeX Live updates biber. biber 2.22 fixes the problem (confirmed on GitHub Actions' macOS in 2026-10): run `sudo tlmgr update --self && sudo tlmgr update biber`, check that `/Library/TeX/texbin/biber --version` works, then delete `~/bin/biber`; rerunning `install.py` won't link it again. Linux and Windows aren't affected.

**I changed the templates but the project's PDF didn't change**
The project is pinned to an older version (see [Version pinning](#version-pinning)). Run `ax upgrade`; or the change hasn't been tagged yet.

**The CJK fonts look different on another computer**
Each system uses the first font it finds:

| Language | Sans (headings, labels, slides) | Serif (body text) |
|---|---|---|
| Chinese (also Chinese inside `lang=en`) | PingFang (macOS) → Noto Sans CJK TC → Microsoft JhengHei (Windows) → Fandol | Songti → Noto Serif CJK TC → MingLiU → Fandol |
| Japanese | Hiragino Sans (macOS) → Noto Sans CJK JP → Yu Gothic (Windows) → HaranoAji | Hiragino Mincho → Noto Serif CJK JP → Yu Mincho → HaranoAji |
| Korean | Apple SD Gothic Neo (macOS) → Noto Sans CJK KR → Malgun Gothic (Windows) → Baekmuk | AppleMyungjo → Noto Serif CJK KR → Batang → Baekmuk |

Fonts without a bold (MingLiU, AppleMyungjo, Batang) borrow the same language's sans bold. If no Japanese or Korean font is found at all, the Chinese fonts stand in, with a warning. `ax doctor` checks the fonts for the language set in `config.json`.

On recent macOS, PingFang is downloaded on first use and may be missing on a fresh machine; download "PingFang TC" in Font Book. Until then the next font in the chain is used.

Fandol is always there (it ships with TeX Live) but is aimed at Simplified Chinese; using it logs a warning, and some Traditional characters may be missing. HaranoAji and Baekmuk are only in TeX Live's Japanese and Korean collections. For the same look everywhere, install [Noto CJK](https://github.com/notofonts/noto-cjk) on each machine (Linux: `fonts-noto-cjk`).

**Compiling stops with `XeTeX is required to compile this document.`**
pdfLaTeX was used. In the terminal use `ax build` or `latexmk` (which reads `latexmkrc`); for editor settings see [Writing in Cursor](../README.en.md#writing-in-cursor) in the README.

**`ax` isn't found**
Open a new terminal first (the PATH change from `install.py` only applies to new windows). If it still isn't found: add `~/bin` (macOS) or `~/.local/bin` (Linux) to `PATH` (`export PATH="$HOME/bin:$PATH"` in `~/.zshrc` or `~/.bashrc`); on Windows, run `py install.py` again.

**Windows: `ax build` says the PDF is locked**
Some viewers (Acrobat, for one) lock an open PDF, so `ax` can't replace it; the new PDF stays in `build/main.pdf`. Use a viewer that doesn't lock files (SumatraPDF, Cursor's built-in preview).

**Other errors**
Run `ax doctor` first. The full build log is in `build/main.log`.

---

Version history: [`CHANGELOG.md`](../CHANGELOG.md).
