# tests

One small document per feature, compiled by `ax selftest tests` (and `ax selftest`)
against the templates in the repo root. Engine: XeLaTeX unless line 1 says
`% !TEX program = pdflatex` or `lualatex`. Keep each file fast and self-contained.
A `% expect-text: word …` / `% expect-no-text: …` line near the top makes the test also check
the PDF's text layer with pdftotext (skipped when pdftotext is missing).
