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
| `--text serif\|sans` `--paper a4\|letter\|pad` `--layout normal\|margin` | See [Document options](#document-options) |
| `--bib` | Adds `refs.bib` and a bibliography |
| `--progress` | Progress bar along the bottom of slides |
| `--git` | Creates a git repo and makes the first commit |
| `--no-preamble` | Leaves out your `preamble.tex` and `preamble-KIND.tex` this time (see [Your own preamble](../README.en.md#your-own-preamble)) |
| `--pin v0.8` | Template version to use; defaults to the newest tag. `--pin latest` always uses the installed files (for testing template changes) |
| `--force` | Creates the project even if the folder exists and isn't empty |

`defaults` in `config.json` sets default options per kind; options on the command line win. For example, `"hw": {"byline": true}` makes new homework print the author and date under the title.

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

### Math

| Input | Result |
|---|---|
| `\vb{x}`, `\vb{A}` | Vectors and matrices in upright bold; Greek letters switch to bold italic / bold upright automatically |
| `\vb{x}\T` | Transpose |
| `\norm{x}`, `\abs{x}`, `\inner{x, y}`, `\set{x}` | Paired delimiters; the starred form `\norm*{...}` sizes them automatically |
| `\E`, `\Var`, `\Cov`, `\KL`, `\tr`, `\rank`, `\diag`, `\sg` | Operators |
| `\argmin`, `\argmax` | Subscript set directly below |
| `\R`, `\N`, `\Z`, `\mathbb{1}` | Blackboard bold (bboldx, including digits and lowercase) |
| `\int f(x) \dd x` | Upright d |

You can write Chinese in math mode, e.g. `$x_{最大}$`.

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

Numeric, in citation order, ranges compressed to `[1–3]`, and each entry lists the pages that cite it. `ax build` runs biber for you.

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

### Mixing languages

No markup needed. Whether or not you type a space between Chinese and English, the spacing comes out right. `\emph{強調}` is bold in Chinese, Japanese and Korean (they have no italic); English stays italic.

Chinese, Japanese and Korean can share one document: characters the main language's font lacks (Traditional Chinese characters missing from a Japanese font, Hangul missing from a Chinese font) are taken from the other two languages' fonts automatically. Korean keeps the spaces between words as typed.

### Other small tools

| Command | Effect |
|---|---|
| `\todo{derive this}` | Orange `[TODO: derive this]` |
| `\blindfootnote{...}` | Footnote without a number, e.g. "Adapted from …" |
| `\sidenote{...}`, `\marginnote{...}` | Margin notes (in the margin only with `layout=margin`; otherwise ordinary footnotes) |
| `\muted{...}` | Grey text |

### Homework and exams

```latex
\begin{problem}[Title]          % homework: Problem N
  \begin{parts} \item ... \item ... \end{parts}   % (a) (b)
  \begin{solution} ... \end{solution}
\end{problem}
```

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

## Document options

Put them in `\documentclass[...]` (for slides, `\usetheme[...]{Akizumi}`):

| Option | Values | Default | Effect |
|---|---|---|---|
| `lang` | `en` `zh` `ja` `ko` | `en` | Main language: date format, contents / figure / table names, problem labels, line spacing, CJK fonts |
| `text` | `serif` `sans` | `serif` | Body font. `serif` is New Computer Modern (same design as the math); `sans` uses Lato throughout |
| `bb` | `light` `regular` `ams` | `light` | Weight of blackboard bold; `ams` is the classic AMS font (capitals only) |
| `paper` | `a4` `letter` `pad` | `a4` | Paper; `pad` is a 3:4 layout for reading on a tablet |
| `layout` | `normal` `margin` | `normal` | `margin` leaves a wide margin for `\sidenote` (notes, books) |
| `thmnames` | `english` `native` | `english` | Theorem, proof, solution and similar names in English or the main language (see [Cross-references](#cross-references)) |
| `byline` | `false` `true` | `false` | Whether "author · ID · date" goes under the title. By default it goes on the right of the first page's header instead (course on the left). The book cover always shows it |
| `bib` | file name | | Loads the bibliography, e.g. `bib=refs.bib` |
| `solutions` | `true` `false` | homework `true`, exams `false` | Whether solutions are printed |
| `10pt` `11pt` `12pt` | | `11pt` | Font size |
| `cjk`, `cjk-bold` | font name | picked per language | Replaces the CJK sans font |

Slides also take `progress` (progress bar along the bottom).

## ax commands in detail

Except `new`, `doctor`, `config` and `completion`, commands run inside a project folder; a subfolder such as `figures/` works too, since `ax` looks upward for `.ax.json` the way git does.

`ax` speaks Chinese or English. It follows the system language; `"ui": "en"` or `"ui": "zh"` in `config.json`, or the environment variable `AX_LANG`, overrides it.

| Command | Effect |
|---|---|
| `ax` | In a project: kind, template version (with a note when a newer one exists), when the PDF was last updated, common commands. Outside a project: help |
| `ax new` | Creates a project (see [ax new options](#ax-new-options-and-project-contents)) |
| `ax build` | Compiles once and shows how long it took. Replaces `main.pdf` only on success; on failure prints the file, line number and source line of the first error with a plain-language hint, and keeps the old PDF |
| `ax watch` | Recompiles on every save and reports each success or failure; opens Skim if you have it |
| `ax open` | Opens the PDF in the system's default viewer; `--solutions` opens the answer key |
| `ax both` | Homework / exams: `main.pdf` (questions) and `main-solutions.pdf` (answers) |
| `ax doctor` | Checks tools, fonts, template installation and versions, then lists what's wrong and how to fix it |
| `ax upgrade` | Moves the project to the newest template version and refreshes `latexmkrc` and editor settings |
| `ax freeze` | Copies the template files into the project so it no longer depends on this repo |
| `ax pack` | Packs `<folder>-overleaf.zip` and tells you which compiler to pick after uploading |
| `ax config` | Where the config folder, `config.json`, preambles and template cache are |
| `ax completion zsh\|bash\|powershell` | Prints a tab-completion script; see `ax completion --help` for setup |
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

A conference paper must use the venue's own template, whose look you can't change. Load just the math macros:

```latex
\usepackage{akizumi-math}    % \vb, \norm, \E, \argmin, ...; works with pdfLaTeX too
```

That's what `ax new paper` sets up.

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
akizumi-core.sty        shared core: fonts, colours, theorems, code, layout, bibliography
akizumi-hw.cls          homework
akizumi-note.cls        notes
akizumi-exam.cls        exams (on top of exam)
akizumi-book.cls        theses, books
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
