# Changelog

## Unreleased

- Japanese and Korean: `lang=ja` and `lang=ko` set the date, captions, contents, section / problem / chapter labels, exam words and fonts (Hiragino, Yu, Noto CJK JP, HaranoAji; Apple SD Gothic Neo, Malgun, Noto CJK KR, Baekmuk). Korean keeps word spaces.
- `thmnames=native` names theorem-like environments in the main language: 定理 / 證明 in Chinese, 定理 / 証明 in Japanese, 정리 / 증명 in Korean, also in cleveref, `proofof`, the list of theorems and slides. English stays the default.
- Characters missing from the main CJK font are taken from the other two languages' fonts, so Chinese, Japanese and Korean mix in one document.
- `ax new --lang ja|ko --thmnames native` (also in `config.json`); `ax doctor` checks the fonts for the configured language; `ax selftest` builds a document in each language.
- `ax` speaks English or Chinese: it follows the system language; `"ui": "en"|"zh"` in `config.json` or `AX_LANG` override it, and `ax config` shows which is used.
- English README (`README.en.md`) and reference manual (`docs/reference.en.md`).
- The language words live in one table in `akizumi-core.sty` (`\akizumi@str`, `\akizumi@num`).

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
