## zh

放在〈寫內容〉底下，〈演算法、符號表〉之後、〈圖〉之前，新增一節：

### 邏輯與程式語言符號

要另外載入：`\usepackage{akizumi-logic}`。不載入的文件完全不受影響。也可以在 pdfLaTeX 的一般文件裡用（顏色和英文字樣會自己補上）。

```latex
\usepackage[connectives=classic]{akizumi-logic}

\begin{fitch}                               % Fitch 證明（fitch 套件），等於 \[ \begin{nd} ... \end{nd} \]
  \hypo{1}{A \limp B}   \by{\RulePremise}{}
  \open
  \hypo{2}{A}           \by{\RuleA[\RuleImpI]}{}   % A / →I
  \have{3}{B}           \by{\RuleImpE}{1,2}        % 1, 2 →E
  \close
  \have{4}{A \limp B}   \by{\RuleImpI}{2-3}
\end{fitch}

\begin{prooftree}                           % 推論規則（ebproof）
  \hypo{\Gamma \vdash t : \sigma \limp \tau} \hypo{\Gamma \vdash s : \sigma}
  \infer2[app]{\Gamma \vdash t\,s : \tau}
\end{prooftree}

\begin{truthtable}{cc|ccc}                  % 真值表，格子都是數學模式
  A & B & A & \main{\land} & B \\ \midrule
  \tvrow{TT|T!TT}                           % 一個字一格；| 和空白略過，- 是空格，! 標主連接詞
\end{truthtable}

\begin{calc}                                % 演算式推導，可以跨頁
  \fn{sum}\;[1,2]
  \step{=}{def.\ of $\fn{sum}$}             % 提示放在 { } 裡、獨立一行
  1 + \fn{sum}\;[2]
  \step{=}{}                                % 提示留空：關係符號接在下一個式子前
  3
\end{calc}

\begin{funcdef}                             % 函數定義：兩欄，靠左
  \fn{zip} &: \fn{List}\;a \to \fn{List}\;b \to \fn{List}\;(a, b) \\
  \fn{zip}\;[]\;ys &= []
\end{funcdef}

$\sem{e}\rho$  $\sem*{\frac{a}{b}}$  $\sem[\big]{e}$  % 語意括號 ⟦ ⟧
```

- **連接詞**：`\limp`（蘊含）、`\liff`（雙條件），`\land` `\lor` `\lnot` 也跟著選項走。`connectives=modern`（預設，∧ ∨ ¬ → ↔）、`classic`（& ∨ ~ ⊃ ≡，Bergmann 那類教科書）、`arrows`（∧ ∨ ¬ ⇒ ⇔）。`\implies` 不會被改。
- **規則名稱**：`\RuleAndI` `\RuleAndE` `\RuleOrI` `\RuleOrE` `\RuleImpI` `\RuleImpE` `\RuleIffI` `\RuleIffE` `\RuleNotI` `\RuleNotE` `\RuleBotI` `\RuleBotE` `\RuleDNI` `\RuleDNE` `\RuleAllI` `\RuleAllE` `\RuleExI` `\RuleExE` `\RuleEqI` `\RuleEqE`，可加下標 `\RuleAndE[1]`（∧E₁）。另有 `\RuleR` `\RuleMT` `\RuleRAA` `\RuleLEM`、`\RuleA`（A，`\RuleA[\RuleNotI]` 是「A / ¬I」）、`\RuleAssumption` `\RulePremise`（字跟著 `lang`）。名稱都以 `\Rule` 開頭，不會蓋掉 `\ni`（∋）、`\ne`（≠）、`\r` 這些既有指令。`rulecase=lower` 改成小寫 →i、→e。
- **Fitch 證明**：用 TeX Live 的 `fitch` 套件（`\hypo` `\have` `\open` `\close` `\by`，`ndresume` 接續上一段）。範圍線、行號和理由是灰色，理由字小一號。`\by{規則}{行號}` 預設排成「1, 2 →E」；`just=rule-first` 排成「→E, 1, 2」。fitch 自己的短指令（`\ii` `\ne` `\r` ⋯）預設不裝，要的話加 `fitchrules`。
- **lmodern**：載入 akizumi-logic 後，proofpack 之類會載 lmodern 的套件不會再把內文字型換掉。
- `\rulename{...}` 是規則標籤的樣式（小一號、灰色），ebproof 的標籤自動套用，也可以手動用。
- `\fn{map}` 是無襯線的函數名稱。

## en

Under "Writing content", after "Algorithms, notation tables" and before "Figures", add a section:

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

## changelog

- `akizumi-logic` (opt-in `\usepackage{akizumi-logic}`): themed Fitch proofs (`fitch` env, muted lines, "1, 2 →E" justifications), non-clashing rule names (`\RuleImpE`, `\RuleAndE[1]`, `\RuleA[\RuleNotI]`, ...), `connectives=modern|classic|arrows` with `\limp` / `\liff`, ebproof inference rules with `\rulename` labels, `truthtable` with `\tvrow`, a `calc` environment with `\step{=}{hint}`, `funcdef`, `\fn` and `\sem`; keeps lmodern (e.g. from proofpack) from replacing the fonts.
