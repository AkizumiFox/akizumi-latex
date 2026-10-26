# Changelog

## Unreleased

- `"pdf": "期末報告.pdf"` in `.ax.json` names the output PDF instead of `main.pdf`: `ax build`, `ax watch` (also `--bg`), `ax open` and Cursor builds (through the latexmkrc) use it, and `ax both` writes the solutions to `期末報告-solutions.pdf`. `ax migrate --project` sets it when the PDF git tracks in the folder has another name than the main file.
- Fixes from converting a whole folder of old documents:
  - Chapter, section and subsection titles are ragged right and not hyphenated: a long title wraps instead of running into the margin.
  - `\mathbf{\Sigma}`, `\mathrm{\Gamma}` and the other text alphabets print Greek capitals (they printed nothing).
  - A theorem, proof or other barred environment right after `\item` builds (it stopped with "perhaps a missing \item"); a theorem whose body opens with a list starts the list on the next line, so a long note wraps.
  - `\begin{theorem}[]` is a theorem without a note (it stopped with "Undefined control sequence").
  - Homework `solution` may contain `verbatim` and `codeblock`, shown or hidden.
  - `\usepackage{mdframed}` (anything that loads zref) builds; `\crefname{equation}{}{}` builds.
  - `\title{A\\ B}` works in the running header; with `twocolumn` the title spans both columns; long `info=` values wrap in the details row; `titleinfo=` works in `\akizumisetup` and, like `header=` and `footer=`, is no longer reported as an unused option.
  - Code font without ligatures (`!=` stays `!=`); the ellipsis ⋯ is set in the CJK font instead of vanishing.
  - New options `eqwithin=chapter|section|none` and `codewithin=chapter|section|none`; `\iosample[input=…, output=…]` and `\akizumisetup{iosample/input=…, iosample/output=…}` set its box titles; ctex's `\chinese` works in enumitem labels (`label=\chinese*、`).
  - `ax migrate`: keeps `13pt` / `14pt`; handles `\setcounter{chapter}{N}` in the preamble and `\chapter*` (no +1); turns a note's single `\chapter{X}` into `\title{X}`; `Problem 1.1` becomes `[label=1.1]`; a note with only `\section*` gets `thmwithin=none, eqwithin=none, codewithin=none`; several statements on one preamble line are handled one by one; slides keep `\usetikzlibrary` after `\usetheme{Akizumi}`; the aaron → akizumi rename no longer touches URLs and words; `\maketitle` is added unless the opening block really is a title.
- `thmnames=english` (the default) now covers every label, not only theorem names: Chinese, Japanese and Korean documents say Figure 1, Table 1, Equation (1.1), Section 2, Chapter 1, Appendix A, Algorithm 1, Listing 1.1, Key idea / Tip / Warning, List of Theorems. `thmnames=native` localises all of them as before. Dates, contents, bibliography, problem numbers and exam tables still follow `lang`.
- Fixes found by building a sample of every document kind in both languages:
  - `ax both` could leave a stale `main.pdf` (with or without solutions): the build stamp now includes the solutions switch, and the problems build clears latexmk's state for the next `ax build` / Cursor build.
  - `restatable` theorems and their `\name*` copies get the left bar.
  - `\Cref` works on theorem-like, exercise and callout labels.
  - `\cref` to an appendix section or chapter says "Appendix A" / 附錄 A.
  - `x'\T` compiles (a prime followed by `\T`).
  - Slides: math in Computer Modern throughout (beamer's sans math only switched letters), and capitals are bold upright there too.
  - Chinese, Japanese, Korean: bibliography words (參考文獻, 收錄於, 與, 引用頁碼, …), no all-caps bibliography header, full-width brackets in theorem notes and exam points, `圖 1：` captions, 輸入／輸出 in algorithms.
  - Exams: a question heading is never left alone at the foot of a page; hidden solutions no longer report overfull lines.
  - Plain papers link without coloured boxes (`hidelinks`).
- Title page: no header; under the title a row of labelled details (course, author, ID, date, or due date for homework; `info={…}` adds columns, four to a row), localized labels; the kicker in spaced accent capitals. `titleinfo=row|line|none` (`byline=true` = `line`); `firstpage=title` brings the old header back. Notes and exams no longer copy the course into the kicker; homework no longer builds a kicker from course and due date.
- English documents treat the middle dot as Latin punctuation, so `Course · Lecture 9` keeps its spaces.
- Capital letters in math are upright bold by default (`A` reads as the matrix $\vb{A}$): `matrices=latin`; `matrices=all` includes Greek capitals, `matrices=normal` restores italic capitals. `\mathcal`, `\mathbb`, `\mathrm` still work. Plain `\usepackage{akizumi-math}` keeps `normal`.
- Footers show just the page number (`3`); `footer=page-total` brings back `3 / 5`, `footer=none` drops it (also for exams).
- Headers and footers are configurable: `header=default|minimal|title|none`, and `\akizumisetup{header/left=…, header/center=…, header/right=…, footer/…, firstpage/…}` with keywords (`course`, `title`, `section`, `page-total`, …) or any text, plus `\akizumiCourse`, `\akizumiSection`, … to mix with text; `headerstyle`, `footerstyle`, `header/number=accent|plain`. Long parts are cut with an ellipsis before they reach their neighbours. Section numbers in headers are in the accent colour.
- Fix: the running header was narrower than the text (fancyhdr kept the width from before the page layout was set), so right-hand parts stopped short of the margin and even pages of `twoside` books were shifted.
- `codeblock` / `\inputcode` titles may contain `_` (`title=low_rank.py`); before, a file name with an underscore stopped the build with "Missing $ inserted". Titles with `$...$` keep their math subscripts.

## v0.9 — 2026-10-26

- Friendlier menus: bare `ax` shows a home menu outside a project (start a document, recent projects, check the setup, look something up) and an action menu inside one (build, watch, background watch, open the PDF, Cursor). Bare `ax new` walks through kind, title, language, bibliography and folder (suggested from the title) with defaults, then asks for confirmation. Arrow keys / j k / digits; plain prompts when not on a terminal.
- `ax docs TOPIC` prints the matching section of the reference manual in the terminal: Chinese or English words, option names (`thmcounter`) and macros (`\cref`), matched across both languages, with typo correction and a list of similar headings when nothing matches; `--web` opens it on GitHub at that section, `--en` the English manual, `--cheatsheet` the cheat sheet PDF (built into the cache when missing). Plain `ax docs` opens the manual.
- `ax --help` and each command's `--help` are in Chinese in the Chinese interface (用法、參數、選項), and every command's help has a short description and examples. Unknown options get a suggestion from that command's own options.
- `examples/cheatsheet.tex`: a quick reference (Chinese, landscape) built with the templates, each feature's source next to its output; `ax selftest examples` builds it and copies `examples/cheatsheet.pdf`, linked from the README.
- `ax selftest docs` (also part of `ax selftest`) builds every ```` ```latex ```` block of `docs/reference.md` and `docs/reference.en.md` and reports failures as `file:line`; fragments are wrapped in a default document, and `<!-- snippet: skip | class=... options=... | beamer | preamble | packages=... | ci-skip=... -->` before a block adjusts that. Fixed the snippets it found broken: an unclosed `theorem`, `axis` outside a `tikzpicture`, unfinished `problem`s, `\q` outside a frame, and Chinese sample text in the English manual.
- `ax watch --bg` watches in the background (output in `build/watch.log`); `--status` shows whether it runs and how the last build went, with the first error; `--log` follows its output; `--stop` ends it. `ax build` / `ax both` warn while one runs, and bare `ax` shows it. Works on macOS, Linux and Windows.
- Japanese and Korean: `lang=ja` and `lang=ko` set the date, captions, contents, section / problem / chapter labels, exam words and fonts (Hiragino, Yu, Noto CJK JP, HaranoAji; Apple SD Gothic Neo, Malgun, Noto CJK KR, Baekmuk). Korean keeps word spaces.
- `thmnames=native` names theorem-like environments in the main language: 定理 / 證明 in Chinese, 定理 / 証明 in Japanese, 정리 / 증명 in Korean, also in cleveref, `proofof`, the list of theorems and slides. English stays the default.
- Characters missing from the main CJK font are taken from the other two languages' fonts, so Chinese, Japanese and Korean mix in one document.
- `ax new --lang ja|ko --thmnames native` (also in `config.json`); `ax doctor` checks the fonts for the configured language; `ax selftest` builds a document in each language.
- `ax` speaks English or Chinese: it follows the system language; `"ui": "en"|"zh"` in `config.json` or `AX_LANG` override it, and `ax config` shows which is used.
- English README (`README.en.md`) and reference manual (`docs/reference.en.md`).
- The language words live in one table in `akizumi-core.sty` (`\akizumi@str`, `\akizumi@num`).
- Books: `twoside` / `openright` with mirrored headers, styled `\part` pages and `partreset`, `\chapter[sub=..., short=...]` for a second-language subtitle, `chaptername=Lecture` or `{第 * 講}`, cover `subtitle` / `institution` / `term`, `\preface`, run-in Lato `\paragraph` / `\subparagraph`, and contents number columns that widen for numbers like 13.10 (new `akizumi-booklayout.sty`).
- Theorem options: `thmcounter=shared|grouped|split`, `thmwithin=chapter|section|none`, `asides=unnumbered`, `aliases=short` (`thm`, `lem`, `prop`, `cor`, ...), `thmname={corollary=系理}`; new kinds `axiom`, `conjecture`, `property`, `conclusion`, `remarks`, `notationthm`, `problem` (not in homework); `\begin{theorem}[number=3.2]` for manual numbers; `\akizumiNewTheorem{tool}{Tool}{工具}{道具}{도구}[prefix=T]` and `\akizumiSetTheorem` (new file `akizumi-theorems.sty`).
- Callouts: `keyidea`, `proofidea`, `tip`, `warning` / `pitfall`, `note`, `chapterguide` with `\guidehead`, and the unlabelled `setup` box, in the left-bar look, breakable, in documents and slides, named in every language; `\akizumiNewCallout{name}{en}{zh}{ja}{ko}[numbered=chapter, tint, ...]` and `\akizumiCalloutSetup` for your own; `\optional` marks optional sections and remarks with a star that also shows in PDF bookmarks.
- Exercises for books and notes (`akizumi-exercise.sty`): `exercise` with its own per-chapter / per-section counter, `exercises` end-of-section lists with (a) (b) parts, `example-problem` with `source=`, `parts`, and `solution` with `solutions=inline|chapter|end|hide` (collected solutions print at chapter or document end, or at `\printsolutions`, linked both ways); names in the string table (Exercise / 習題 / 演習 / 연습문제). Homework and exams keep their own `solution`.
- Homework problems: grouped numbering with `\problemset{B}` (B1, B2, ...) and hand-set numbers with `\begin{problem}[label=B2$'$, title=...]`; `\inputproblem[title]{file}` for one file per problem and `problembreak=true` for one problem per page; `parts` takes enumitem keys and nests `subparts`; `kind=assignment|exercise|report` changes the title word (zh/ja/ko too); `header=name-id` and `\akizumisetup{headleft=..., headright=...}` set the running header; `ax new hw --problems 5` (or `B4,C2`) creates `problems/p1.tex` ... with `\inputproblem` lines.
- akizumi-math no longer clashes with your macros: every name is provided only if free, and a later `\newcommand` / `\DeclareMathOperator` / `\DeclarePairedDelimiter` of the same name replaces it instead of failing (`mathclash=error` restores the error, `mathskip={...}` leaves names out; `ax doctor` lists redefinitions and single-letter `\def`s that break accents). New options `delims=auto`, `letters=bold|cal|bb|greek|all|single`, `vb=upright`, `units` (siunitx); new macros `\Q \C \floor \ceil \lcm \spn \nullity \im \adj \col \row \nul \id \supp \vol \Bd \Int \diam \Prob \given \Corr \indep \iid \plim \Normal \Bern \Bin \Pois \Geom \Unif \cvec \bvec`, `\mathscr` (RSFS) and `\mathbbm` / `\mathbbmss` as `\mathbb`. Fix: akizumi-math loads after unicode-math without the amssymb `\eth` error.
- Code: `codeblock[numbered, label=…, kind=…]` with `\listofcodes` and `\cref`; `\akizumiNewCodeKind` for kinds such as Example that can share numbers and get their own `\begin{…}{lang}{title}`; `\begin{code}{lang}{title}`; `lines=a-b`, `\codedir`, `\inputcode[output]`; `terminal` and `\iosample{in}{out}`; `\code[lang]{…}` highlights and works inside other commands' arguments; Agda, Datalog and Stata for listings; `verbatim=styled`; opt-in `code=minted` (falls back to listings with a warning), `ax new --code minted` and automatic `-shell-escape`.
- `tikz=full` loads more TikZ libraries (3d, angles, quotes, decorations, patterns, fit, backgrounds, shapes, tikzmark, automata, intersections) and `plots` loads pgfplots with a matching cycle list and colormap, in documents and slides (`akizumi-tikz.sty`); ready-made styles for arrays (`akizumi/cell`, `hlcell`), flowcharts, automata (`akizumi/automaton`), game trees (`akizumi/game/...`) and currents into / out of the page (`\pic {akizumi/current in}`).
- `index=true`: subject index (imakeidx, two columns, in the contents, localized heading) and a list of notation (`\nota{sym}{meaning}`, `\printnotation`, with pages, styled like the notation table); `\akizumiNewIndex` for more indexes; latexmk runs upmendex (CJK sorting, `index-sort=stroke|zhuyin|pinyin|radical`) or makeindex, so `ax build`, `ax watch` and Cursor build the index; `ax doctor` reports upmendex, `ax selftest` builds an indexed project.
- `akizumi-logic` (opt-in `\usepackage{akizumi-logic}`): themed Fitch proofs (`fitch` env, muted lines, "1, 2 →E" justifications), non-clashing rule names (`\RuleImpE`, `\RuleAndE[1]`, `\RuleA[\RuleNotI]`, ...), `connectives=modern|classic|arrows` with `\limp` / `\liff`, ebproof inference rules with `\rulename` labels, `truthtable` with `\tvrow`, a `calc` environment with `\step{=}{hint}`, `funcdef`, `\fn` and `\sem`; keeps lmodern (e.g. from proofpack) from replacing the fonts.
- Papers: `ax new paper --venue neurips|icml|iclr|aaai|plain [--split] [--no-anonymous]` writes the venue's own preamble (no forced natbib options or hyperref; the venue `.sty` is downloaded, not shipped) with one `\ifanonymous` switch; new engine-agnostic `akizumi-paper.sty` with `\newcommenter` (and `final`), `\anon`, `\eg` `\ie` `\etal` `\cf` `\wrt` `\etc`, `\best` `\second` `\cmark` `\xmark`, `refstyle=short`; bibliography options `bibstyle=numeric|authoryear|apa`, `backref=true|false`, `cite=super`, with `\citep` / `\citet` in every style (`akizumi-bib.sty`).
- Chinese report layout: `par=indent` (2em first-line indent, no paragraph gaps), `secnum=zh` (一、 / （一） / 1.; 第一章), `13pt` / `14pt` / `fontsize=` (scrextend), `kai` (Kaiti TC, BiauKai, DFKai-SB, AR PL UKai, FandolKai), `cjk-serif` / `cjk-serif-bold`, `text=times|palatino` (TeX Gyre), and `\akizumisetup{subtitle=..., info={學號=..., 系級=...}}` in the title block. `ax new --text` accepts `times` and `palatino`. Defaults unchanged.
- Build pipeline: `.ax.json` `"prebuild"` steps run before `ax build` / `both` / `watch` and stop the build with the failing command and its output; `"shell_escape": true` reaches latexmk from ax and from the project `latexmkrc`; `ax build --chapter N` (and `ax watch --chapter N`) builds one `\include`d chapter into `main-chN.pdf` with its real number; `\chapterdir{dir}` points figures, `\input` and code files at a chapter's folder; `ax count` counts English words and CJK characters (`--limit N`); `ax doctor` checks prebuild programs, inkscape for svg, and packages missing from TeX Live.
- Old documents: `CJK` / `CJK*` environments and `\usepackage{CJKutf8|CJKspace|algpseudocode}` are ignored with a warning, algorithm2e loads beside `algorithm`, and `li` lists work (`legacy=false` turns this off); `ax migrate FILE.tex` rewrites a copy of a memoir / math-notes document for akizumi (course macros, `\setcounter{chapter}`, `\section*{Problem k}`, CJK wrappers) and reports macros that clash with akizumi's; a course folder's `.akizumi/preamble.tex` is read by every document below it (`sharedpreamble=false` to skip).
- Fixes from verification: `index=true` builds when only one of the index and the notation list has entries; the notation list's contents line and the collected solutions' contents lines and bookmarks point at the right page; `secnum=zh` keeps exercise, code and callout numbers Arabic; `\cref` works in slides, joins several references with 與 / と / 및 in CJK, and names exam questions (第 1 題) and unnumbered asides; slide dates and exam grade tables are localized; Korean keeps its word spaces inside zh / ja / en documents; `|see` index entries are localized; `\inputcode[lines=a-b]` numbers lines as in the file; Kaiti TC is scaled to match the text; ja `warning` reads 警告 and a note's `chapterguide` reads 導覽. ax: `ax upgrade` and bare `ax` no longer offer a pinned tag to a `latest` project; changing `"shell_escape"` or the template pin forces a full rebuild; `ax build FILE` outside a project uses ax's settings; an invalid `.ax.json` is reported as such; `ax migrate` keeps beamer decks as slides (`--kind slides`), counts `\include`d chapters, looks for homework words only in titles and headings, passes the options of packages loaded by local style files before `\documentclass`, keeps what math-notes provided (`\providecommand`, its colors, a list of its packages), turns memoir spacing into setspace, renames aaron to akizumi, makes a `.bak` when `-o` names the source, and checks the `-o` folder; Tab completion is generated from the commands' options; bad `--limit`, `--problems` and `"shell_escape"` values are reported; `ax new paper` says which options it skips; `--chapter 1,3` writes `main-ch1+3.pdf`.
- Fixes from review: `ax new`, `ax docs` and `ax build` say when the manual describes features newer than the project's pinned version (and how to use `"template": "latest"`), and `ax build` warns about document options the template does not know (`Unused global option(s)`); `ax docs` lays its answer out for the terminal (wrapped paragraphs, tables as columns or one entry per row, links as text), never shows the other language's text in a section whose paragraphs differ, understands plain phrases (按節編號, 解答放最後, "number by section") and no longer offers the file tree under "Maintaining" for every word; `--help` wraps at the terminal width counting CJK characters as two columns and translates value names; argparse errors (bad numbers, missing values, conflicting options) are in the interface language; `ax migrate` handles a body written on one line; minted runs under TeX Live 2024+'s restricted shell escape, so ax adds `-shell-escape` only where it is needed; `\printindex` without `index=true` stops with a message instead of an undefined control sequence; the `notation` table's headers follow `lang` and lose the extra gap under the top rule; the cheat sheet covers citations, figures, more theorem, callout, exercise, homework, code and logic features, the paper package, `.ax.json` and the rest of the ax commands, marks each option's default, aligns comments next to CJK text and highlights `$\abs` like `\abs`.

## v0.8 — 2026-10-25

- Titles are centred. Author, ID and date no longer sit under the title; they go in the first page's header (course left, byline right). `byline=true` puts them back under the title; `config.json` `defaults` accepts `"byline": true`. The book cover always shows them.
- CI also runs on macOS; `ax selftest` builds a project with a citation, so biber is tested on every system.
- `ax new` lists `cursor .` before `ax watch`, which it shows as the alternative when not using Cursor.
- `install.py` finds TeX Live's biber through kpsewhich (MacTeX or plain TeX Live).

## v0.7 — 2026-10-25

- Runs on macOS, Linux and Windows. `install.py` replaces `install.sh` (junction plus user PATH on Windows; `~/.local/bin` on Linux). `bin/ax.cmd` starts ax on Windows.
- Project `latexmkrc` has no machine-specific paths: it reads the pinned version from `.ax.json` and finds the cache per system, so one project builds on all three. `ax upgrade` refreshes `latexmkrc` and `.vscode/settings.json` written by ax.
- Traditional Chinese fonts: PingFang / Songti, then Noto CJK TC, then Microsoft JhengHei / MingLiU, then Fandol (with a warning).
- Your own preamble: `preamble.tex` and `preamble-KIND.tex` in the config folder are copied into new projects; `config.json` `defaults` sets options per kind; `--no-preamble`.
- `ax config` shows where config, preambles and the cache live; `ax selftest` replaces the Makefile checks; `ax watch` no longer needs `cp`; `ax build` explains a PDF locked by a viewer.
- GitHub Actions builds everything on Linux and Windows on demand and on version tags.
- Friendlier `ax`: messages in Chinese with ✓ ✗ and colour (off when piped or with `NO_COLOR`); a spinner with elapsed time while compiling; plain-language hints for common LaTeX errors; typo suggestions for commands, kinds and option values; works from any subfolder of a project; bare `ax` shows the project's status; `ax open`; `ax completion zsh|bash|powershell`; `ax new` lists next steps; `ax doctor` ends with a summary and fixes.
- Fix: projects pinned to versions before v0.6 no longer re-extract the version on every build.
- Works with the 2026-06 LaTeX kernel, which made `\newtheorem{x}[theorem]` a counter alias that clashes with thmtools: lemma, claim, … now share theorem's count register under their own counter names (cleveref names them without the old alias hook). Projects pinned to v0.6 or older fail on that kernel with `Command \c@lemma already defined`; `ax build` now says to run `ax upgrade`.
- Windows: ax reads and writes UTF-8 text and prints UTF-8 to pipes; `ax new` no longer mistakes NUL for a terminal.
- `ax new --pin latest`; `ax selftest` tests the working tree.

## v0.6 — 2026-10-25

- Renamed the package from aaron to akizumi: `akizumi-core.sty`, `akizumi-hw.cls`, … , `beamerthemeAkizumi.sty` (`\usetheme{Akizumi}`), `\akizumisetup`, `\akizumisep`, `\akizumirule`, TikZ styles `akizumi/box` etc., `bin/akizumi-both`. The TeX tree link is now `akizumi-latex`.
- `ax upgrade` from an earlier version rewrites the old names in the project's `.tex` files; projects that stay pinned to v0.5 or older keep building with the old names.

## v0.5 — 2026-10-23

- No grey rules left in documents: the running header and book chapter titles lose theirs (the title block already had).
- Slide title page matches the document title: kicker above, bold title, muted "author · date" line. `ax new slides --course` fills the kicker.
- `ax new` writes `.vscode/settings.json` (Cursor / VS Code: latexmk recipe, double-click reverse sync); latexmkrc calls `ax` and biber by absolute path.
- `ax --help` in Chinese with the command list and examples; plain `ax` prints it.

## v0.4 — 2026-10-21

- Title block: larger title (`\huge`), no rule underneath.
- Page numbers centred at the foot of the page (notes, homework, book, exam).
- `ax` command: `new` (hw, note, exam, slides, book, paper), `build` (PDF replaced only on success, first error with file:line, stale-state retry, timeout), `watch`, `both`, `doctor`, `freeze`, `upgrade`, `pack`. Projects pin a template version in `.ax.json`; `ax texinputs` serves it to latexmk.
- `ax new` with no arguments asks for the kind (numbered menu), directory and title; `--git` starts a repository.
- Generated projects turn on SyncTeX; `ax watch` prints the first error (via `ax explain`) when a run fails.
- `make test-ax`.
- Fix: `examples/latexmkrc` searched the parent folder recursively, so `skeletons/hw.tex` shadowed `examples/hw.tex`.

## v0.3 — 2026-10-21

- `restatable` theorems (thmtools) and `proofof`; restated copies are not listed twice. `\listoftheorems`.
- `algorithm` + algpseudocodex, `notation` table.
- `paper=a4|letter|pad`, `layout=margin` with `\sidenote`, `\marginnote`, margin floats and `fullwidth` (fallbacks when the layout is normal).
- New `aaron-book` class: cover page, chapter headings, `\chaptertoc`, chapter/section running headers, Chinese chapter and appendix labels.
- `bin/aaron-both`: problem sheet and answer key in one run (`\aaronsolutions` override).
- Slides: `progress` option, `\standoutframe`, appendix frames numbered separately (appendixnumberbeamer).
- Fixes: theorem kinds sharing the counter now follow per-section numbering in lists and anchors; running headers keep their case; TOC links in body color.

## v0.2 — 2026-10-21

- Body text is serif (New Computer Modern Book, Songti TC for Chinese) by default; Lato stays for headings, labels, titles, headers and slides. `text=sans` restores all-Lato body text.
- Lato's common ligatures are off (it joined "ti").
- Blackboard bold is bboldx light; `bb=light|regular|ams`.
- `\vb` gives upright bold for Latin letters and digits, `\bm` for Greek.
- Theorem-like environments get left bars (weight and tone, one hue); added `claim`, `assumption`, and starred unnumbered forms of every kind. Slides use the same bars.
- `\cref` via cleveref, with Chinese names for sections, figures, tables, equations and problems under `lang=zh`.
- `bib=refs.bib` loads biblatex (biber, numeric-comp, citation order, back-references).
- Notes: equations numbered within sections; header shows the current section.
- Code blocks: `codeblock`, `\inputcode`, `\code`; breakable, wrapped lines marked.
- CJK fonts fall back to Noto CJK TC, then Fandol, when PingFang / Songti are missing.
- TikZ styles `aaron/box`, `aaron/arrow`, `aaron/label`, `aaron/note`, `aaron/alert`.
- `\todo`, `\blindfootnote`, footnotes pinned to the page bottom, `subcaption`, PDF title/author metadata.
- Theorem names are English in every language; `lang` sets dates, captions, problem labels and line spacing.

## v0.1 — 2026-10-21

- First version: aaron-math, aaron-core, aaron-hw, aaron-note, aaron-exam, beamerthemeAaron.
