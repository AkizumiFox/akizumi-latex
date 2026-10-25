## zh

**取代 docs/reference.md〈寫內容〉底下的「### 數學」整節**（從表格到「數學模式裡可以直接寫中文」那句）：

### 數學

| 寫法 | 結果 |
|---|---|
| `\vb{x}`、`\vb{A}` | 向量、矩陣用正體粗體；希臘字母自動改用粗斜體／粗正體（`vb=upright` 讓小寫希臘字母也是正體）。`\bvec` 是同一個指令 |
| `\vb{x}\T` | 轉置 |
| `\norm{x}`、`\abs{x}`、`\inner{x, y}`、`\set{x}`、`\floor{x}`、`\ceil{x}` | 配對括號；加星號 `\norm*{...}` 自動調整大小，`\norm[\big]{...}` 指定大小 |
| `\set{x \given x > 0}`、`\Prob{A \given B}` | `\given` 是有間距的 \|，在 `\set`、`\Prob` 裡會跟著括號變大 |
| `\E`、`\Var`、`\Cov`、`\Corr`、`\KL`、`\sg` | 期望值、變異數等運算子 |
| `\tr`、`\rank`、`\diag`、`\spn`、`\nullity`、`\im`、`\adj`、`\col`、`\row`、`\nul`、`\id` | 線性代數（`\spn` 印出 span） |
| `\supp`、`\vol`、`\Bd`、`\Int`、`\diam`、`\lcm` | 分析、拓撲、數論 |
| `\argmin`、`\argmax`、`\plim` | 下標放在正下方 |
| `\Prob{A}`、`\Normal{\mu}{\sigma^2}`、`\Bern{p}`、`\Bin{n}{p}`、`\Pois{\lambda}`、`\Geom{p}`、`\Unif{a}{b}` | 機率與分布，括號規則同上 |
| `X \indep Y`、`X_i \iid F` | 獨立、獨立同分布 |
| `\R`、`\N`、`\Z`、`\Q`、`\C`、`\mathbb{1}` | 黑板粗體（bboldx，含數字和小寫） |
| `\mathscr{F}` | 花體（RSFS） |
| `\mathbbm{1}`、`\mathbbmss{R}` | bbm 的寫法照樣能編譯，印成 `\mathbb`（不用 bbm 的點陣字型） |
| `\cvec{1, 2, 3}`、`\cvec[p]{a, b}` | 行向量；方括號，`[p]` 改圓括號（也可 `v`、`V`、`B`） |
| `\int f(x) \dd x` | 正體的 d |

數學模式裡可以直接寫中文，例如 `$x_{最大}$`。

**和自己的巨集共存。** 上面每個名稱都只在還沒有人定義時才提供。之後在 preamble 用 `\newcommand`、`\DeclareMathOperator` 或 `\DeclarePairedDelimiter` 定義同名巨集，不會報「already defined」，而是改用你的定義；`\def`、`\renewcommand` 本來就會蓋掉。所以舊的 shortcuts 檔、ICLR／NeurIPS 的 `math_commands.tex` 可以直接 `\input`。想保留 LaTeX 原本的報錯，加 `mathclash=error`。想讓某些名稱完全不定義，用 `mathskip={vb, E}`。`ax doctor` 會列出專案裡重新定義了哪些 akizumi-math 巨集，以及哪些檔案用單字母 `\def` 蓋掉了 `\c`、`\v` 這類重音指令。`\NewDocumentCommand` 不在此列，請改用 `\RenewDocumentCommand`。

**字母捷徑（要開才有）。** 用 `letters=` 選擇，可以多選，例如 `letters={bold, cal}`：

| 值 | 提供 |
|---|---|
| `bold` | `\va`…`\vz`、`\vA`…`\vZ`、`\vzero`、`\vone`，即 `\vb{a}` 等。單獨寫 `\vb`（後面沒有大括號）是粗體 b |
| `cal` | `\sA`…`\sZ`，即 `\mathcal{A}` 等 |
| `bb` | `\nA`…`\nZ`，即 `\mathbb{A}` 等 |
| `greek` | `\valpha`…`\vomega`、`\vGamma`…`\vOmega`，即 `\vb{\alpha}` 等 |
| `all` | 以上四組 |
| `single` | `\a`…`\z` 在數學裡是粗體；在內文裡 `\c{c}`、`\v{s}`、`\d{h}`、`\i`、`\o` 照舊是重音和特殊字母。大寫單字母不提供，因為 `\R`、`\E`、`\T` 已經有用途 |

已經存在的名稱不會被覆蓋。

**放在「## 文件選項」表格，`cjk`、`cjk-bold` 那一列之後**：

| `delims` | `manual` `auto` | `manual` | `auto` 讓 `\abs`、`\norm`、`\set`、`\Prob` 這些配對括號不加星號就自動調整大小，加星號反而維持原本大小 |
| `letters` | `bold` `cal` `bb` `greek` `all` `single` | 無 | 字母捷徑，見〈數學〉 |
| `vb` | `auto` `upright` | `auto` | `upright` 讓 `\vb{\alpha}` 的小寫希臘字母也是正體粗體（upgreek） |
| `units` | `false` `true` | `false` | 載入 siunitx：`\qty{9.8}{\metre\per\second\squared}`、`\unit{kg}`、`\num{12345}` |
| `mathclash` | `yield` `error` | `yield` | 自己定義和 akizumi-math 同名的巨集時，`yield` 改用你的，`error` 照 LaTeX 原本的方式報錯 |
| `mathskip` | 名稱清單 | | 這些巨集完全不定義，例如 `mathskip={vb, E}` |

**表格下面「簡報另有 `progress`」那句之後加一句**：

簡報的數學選項寫在 `\documentclass` 之前：`\PassOptionsToPackage{delims=auto, letters=bold}{akizumi-math}`。

**〈不用 ax 直接用模板〉的會議論文段落，`\usepackage{akizumi-math}` 那個程式碼區塊之後加一句**：

選項照樣能用，例如 `\usepackage[delims=auto, letters=bold]{akizumi-math}`。會議模板自帶的 `math_commands.tex` 放在它後面載入即可，同名的巨集以模板的為準。

## en

**Replace the whole "### Math" subsection under "Writing content" in docs/reference.en.md** (from the table through "You can write Chinese in math mode"):

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

**In the "## Document options" table, after the `cjk`, `cjk-bold` row:**

| `delims` | `manual` `auto` | `manual` | `auto` makes `\abs`, `\norm`, `\set`, `\Prob` and the other paired delimiters size themselves without the star; the starred form then keeps the natural size |
| `letters` | `bold` `cal` `bb` `greek` `all` `single` | none | Letter shortcuts, see [Math](#math) |
| `vb` | `auto` `upright` | `auto` | `upright` makes lowercase Greek in `\vb{\alpha}` upright bold too (upgreek) |
| `units` | `false` `true` | `false` | Loads siunitx: `\qty{9.8}{\metre\per\second\squared}`, `\unit{kg}`, `\num{12345}` |
| `mathclash` | `yield` `error` | `yield` | When you define a macro akizumi-math also has, `yield` uses yours, `error` stops as LaTeX normally does |
| `mathskip` | list of names | | These macros are not defined at all, e.g. `mathskip={vb, E}` |

**After the sentence "Slides also take `progress`" below the table, add:**

For slides, give the math options before `\documentclass`: `\PassOptionsToPackage{delims=auto, letters=bold}{akizumi-math}`.

**In "Using the templates without ax", after the `\usepackage{akizumi-math}` code block for conference papers, add:**

Options work there too, e.g. `\usepackage[delims=auto, letters=bold]{akizumi-math}`. Load the venue's own `math_commands.tex` after it; where names overlap, the venue's definitions win.

## changelog

- akizumi-math no longer clashes with your macros: every name is provided only if free, and a later `\newcommand` / `\DeclareMathOperator` / `\DeclarePairedDelimiter` of the same name replaces it instead of failing (`mathclash=error` restores the error, `mathskip={...}` leaves names out; `ax doctor` lists redefinitions and single-letter `\def`s that break accents). New options `delims=auto`, `letters=bold|cal|bb|greek|all|single`, `vb=upright`, `units` (siunitx); new macros `\Q \C \floor \ceil \lcm \spn \nullity \im \adj \col \row \nul \id \supp \vol \Bd \Int \diam \Prob \given \Corr \indep \iid \plim \Normal \Bern \Bin \Pois \Geom \Unif \cvec \bvec`, `\mathscr` (RSFS) and `\mathbbm` / `\mathbbmss` as `\mathbb`. Fix: akizumi-math loads after unicode-math without the amssymb `\eth` error.
