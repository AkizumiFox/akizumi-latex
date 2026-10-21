# Changelog

## Unreleased

- `ax` command: `new` (hw, note, exam, slides, book, paper), `build` (PDF replaced only on success, first error with file:line, stale-state retry, timeout), `watch`, `both`, `doctor`, `freeze`, `upgrade`, `pack`. Projects pin a template version in `.ax.json`; `ax texinputs` serves it to latexmk.
- `make test-ax`.

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
