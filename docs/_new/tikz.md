# tikz

## zh

放在〈寫內容 › 圖〉，接在 `akizumi/box` 的 TikZ 範例後面：

TikZ 預設只載入 `arrows.meta`、`positioning`、`calc`、`shapes.geometric`。要畫立體圖、角度、大括號、網底、自動機時，在 `\documentclass` 加 `tikz=full`（簡報寫在 `\usetheme[tikz=full]{Akizumi}`），會再載入 `3d`、`angles`、`quotes`、`decorations.pathreplacing`、`decorations.markings`、`patterns`、`fit`、`backgrounds`、`shapes`、`tikzmark`、`automata`、`intersections`。加 `plots` 會載入 pgfplots（`compat=1.18`），線條依序用 `accent`、`warn`、`plotgreen`、`plotpurple`、`mute` 上色，熱圖預設用淡灰到 `accent` 的 colormap，座標軸和格線用淺灰。

```latex
\documentclass[tikz=full, plots]{akizumi-note}
...
\begin{axis}[axis lines=middle, grid=major]
  \addplot+[domain=0:4] {x/(1+x)};   % 第一條自動是 accent 色
\end{axis}
```

常見的圖都有現成的樣式，不需要每份文件自己定義：

| 用途 | 樣式 | 說明 |
|---|---|---|
| 陣列 | `akizumi/cell`、`akizumi/hlcell`、`akizumi/hlcell2`、`akizumi/index` | 0.9 cm 的格子，相隔 0.9 cm 擺放時邊線會重疊；`hlcell` 是目前的索引（藍），`hlcell2` 是第二個焦點（橘）；`index` 是格子下方的小灰字 |
| 流程圖 | `akizumi/start`、`akizumi/process`、`akizumi/decision`、`akizumi/io`、`akizumi/group` | 起訖、處理、判斷（菱形）、輸入輸出（平行四邊形）、虛線分組框（配合 `fit` 和 `on background layer`）；箭頭用 `akizumi/arrow` |
| 自動機 | `[akizumi/automaton]`、`akizumi/state`、`akizumi/accepting` | 寫在 `tikzpicture` 的選項上之後，`state`、`accepting`、`initial`、`edge` 都套用這套外觀；`initial`、迴圈邊和 `edge["$a$"]` 需要 `tikz=full` |
| 賽局樹 | `akizumi/game/decision`、`/chance`、`/terminal`、`/branch`、`/action`、`/payoff`、`/infoset` | 決策點（實心）、自然（空心）、終點（小灰點）、分支箭頭、行動標籤、報酬、資訊集（灰色虛線） |
| 物理 | `\pic {akizumi/current in};`、`\pic {akizumi/current out};`、`akizumi/wire` | 流入、流出紙面的電流符號，蓋在導線上；`\pic[accent] at (A) {akizumi/current in};` 可以換顏色 |

```latex
\begin{tikzpicture}[akizumi/automaton]
  \node[state, initial] (q0) {$q_0$};
  \node[state, accepting, right=of q0] (q1) {$q_1$};
  \path[->] (q0) edge["$a$"] (q1) (q1) edge[loop above] node {$b$} ();
\end{tikzpicture}
```

另外在〈文件選項〉的表格加兩列：

| `tikz` | `basic` `full` | `basic` | `full`（只寫 `tikz` 也一樣）多載入 3d、angles、patterns、tikzmark、automata 等 TikZ 函式庫（見〈圖〉） |
| `plots` | `true` `false` | `false` | 載入 pgfplots，配色跟模板一致 |

並把「簡報另有 `progress`」改成「簡報另有 `progress`；`tikz`、`plots` 在簡報也能用」。

〈維護這套模板〉的檔案清單在 `akizumi-core.sty` 下面加一行：`akizumi-tikz.sty        TikZ 函式庫、pgfplots、圖的樣式（core 載入）`。

## en

Goes in "Writing content › Figures", after the `akizumi/box` TikZ example:

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

Also add two rows to the "Document options" table:

| `tikz` | `basic` `full` | `basic` | `full` (or bare `tikz`) also loads the 3d, angles, patterns, tikzmark, automata and other TikZ libraries (see Figures) |
| `plots` | `true` `false` | `false` | Loads pgfplots, colored to match the templates |

and change "Slides also take `progress` (progress bar along the bottom)." to "Slides also take `progress` (progress bar along the bottom); `tikz` and `plots` work in slides too."

In "Maintaining the templates", add under `akizumi-core.sty`: `akizumi-tikz.sty        TikZ libraries, pgfplots, figure styles (loaded by core)`.

## changelog

- `tikz=full` loads more TikZ libraries (3d, angles, quotes, decorations, patterns, fit, backgrounds, shapes, tikzmark, automata, intersections) and `plots` loads pgfplots with a matching cycle list and colormap, in documents and slides (`akizumi-tikz.sty`); ready-made styles for arrays (`akizumi/cell`, `hlcell`), flowcharts, automata (`akizumi/automaton`), game trees (`akizumi/game/...`) and currents into / out of the page (`\pic {akizumi/current in}`).
