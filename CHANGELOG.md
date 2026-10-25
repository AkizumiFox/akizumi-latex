# Changelog

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
