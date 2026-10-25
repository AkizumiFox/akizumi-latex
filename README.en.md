# akizumi-latex

中文版：[README.md](README.md)

One set of LaTeX templates for homework, notes, exams, slides and papers, plus `ax`, a command that creates and compiles projects. Documents can be in English, Chinese, Japanese or Korean, and mix them freely.

## Install

Works on macOS, Linux and Windows. All three need **TeX Live**, **git** and **Python 3**:

| System | Install first |
|---|---|
| macOS | [MacTeX](https://tug.org/mactex/), `xcode-select --install` (for git) |
| Linux | [TeX Live](https://tug.org/texlive/) (or your distribution's `texlive-full`), git, python3; for CJK text, `fonts-noto-cjk` |
| Windows | [TeX Live](https://tug.org/texlive/windows.html), [Git for Windows](https://git-scm.com/), [Python](https://www.python.org/) (tick "py launcher") |

MiKTeX is untested; use TeX Live.

```sh
git clone https://github.com/AkizumiFox/akizumi-latex.git akizumi-latex
cd akizumi-latex
python3 install.py        # Windows: py install.py
```

`install.py` makes the templates visible to TeX and puts `ax` on your command line: in `~/bin` on macOS, `~/.local/bin` on Linux; on Windows it adds the repo's `bin` folder to PATH. Then **open a new terminal** and run `ax doctor`. If nothing is marked ✗, you're done.

Your details: `ax config` shows where the config folder is (`~/.config/ax/` on macOS and Linux, `%APPDATA%\ax\` on Windows). Create `config.json` there:

```json
{"author": "Aaron Lin", "id": "B12345678", "lang": "en"}
```

Every field is optional; new projects fill them in automatically. `lang` is the main language of new documents: `en`, `zh`, `ja` or `ko`.

`ax` itself speaks English or Chinese and follows your system language. To choose, add `"ui": "en"` or `"ui": "zh"` to `config.json`, or set `AX_LANG`.

**Tab completion** (optional): add `eval "$(ax completion zsh)"` to `~/.zshrc`, and `ax ` + Tab lists commands and document kinds. For bash and PowerShell see `ax completion --help`.

## First project

```sh
ax new hw ode-hw3 --course ODE --number 3
cursor ode-hw3
```

Open `main.tex` in Cursor and press `Cmd+Option+V` (Windows, Linux: `Ctrl+Alt+V`) for the PDF preview; every save recompiles and refreshes it. The preamble is already filled in, so just write:

```latex
\begin{problem}[First-order linear ODE]
Solve $y' + 2y = e^{-x}$, $y(0) = 1$.
\begin{solution}
The integrating factor is $e^{2x}$, so $y = e^{-x}$.
\end{solution}
\end{problem}
```

`ax new` on its own asks for the kind, folder and title. Six kinds:

| Kind | For |
|---|---|
| `hw` | homework (problems, solutions) |
| `note` | lecture notes, handouts |
| `exam` | exams (points, grade table) |
| `slides` | slides |
| `book` | theses, long notes |
| `paper` | the body of a paper submitted with a venue's template (borrows only the math macros) |

Common options: `--title`, `--course`, `--lang zh|ja|ko`, `--thmnames native` (定理 / 証明 / 정리 instead of Theorem / Proof), `--bib` (references). All options: [reference manual](docs/reference.en.md).

## Daily commands

In a project folder (or any folder inside it):

| Command | Does |
|---|---|
| `ax` | this project's status: kind, template version, when the PDF was updated |
| `ax watch` | recompile on every save (when not using Cursor); `--bg` runs it in the background, `--status` and `--stop` check on it and stop it |
| `ax build` | compile once; on failure, shows the line, a plain-language hint, and keeps the previous PDF |
| `ax open` | open the PDF (`--solutions` for the answer key) |
| `ax both` | homework and exams: problems and answer key in one go |
| `ax pack` | zip for Overleaf (set the compiler to XeLaTeX) |
| `ax doctor` | run this first when something is wrong |

Mistyped commands get a suggestion: `ax biuld` asks whether you meant `ax build`.

## Writing in Cursor

`ax new` puts a `.vscode/settings.json` in the project so LaTeX Workshop uses the project's own build settings (XeLaTeX). It affects only that project, not your global settings.

A folder not made by `ax new` falls back to the global pdflatex recipe and fails; copy `.vscode/` and `latexmkrc` over from any `ax` project.

Jump between source and PDF: `Cmd+Option+J` (`Ctrl+Alt+J`) in the source jumps to the PDF; double-click the PDF to jump back.

A project can live in git and compile on macOS, Linux and Windows alike; nothing in it is tied to one machine.

## Your own preamble

Put these files in the config folder (shown by `ax config`), and `ax new` copies them into each new project's `main.tex`:

| File | Used for |
|---|---|
| `preamble.tex` | every new project (except `paper`, which follows the venue's template) |
| `preamble-hw.tex`, `preamble-slides.tex`, … | that kind only |

Default options per kind go under `defaults` in `config.json`; options on the command line win:

```json
{
  "author": "Aaron Lin",
  "defaults": {
    "slides": {"progress": true, "lang": "en"},
    "note": {"layout": "margin"}
  }
}
```

The contents are copied at creation, so editing your preamble later leaves old projects alone. To skip it once: `ax new ... --no-preamble`.

## Updating

Each project remembers the template version it was created with. When the templates change, old homework still compiles exactly as before; run `ax upgrade` in a project to take the new look.

## More

- [Reference manual](docs/reference.en.md): theorems, code, references, slides, books, every document option, the design rules, troubleshooting, and how to maintain and release the templates
- [`examples/`](examples/): a complete example of each kind
- [`CHANGELOG.md`](CHANGELOG.md): version history
