# akizumi-latex

作業、講義、考卷、簡報、論文共用的 LaTeX 模板，加上建立和編譯專案的指令 `ax`。

## 安裝

需要 MacTeX（TeX Live 2026）和 Command Line Tools（`xcode-select --install`）。

```sh
git clone <這個 repo> ~/w/latex-templates
cd ~/w/latex-templates
./install.sh
```

`install.sh` 把模板掛進 TeX、把 `ax` 連到 `~/bin`。`~/bin` 要在 `PATH` 裡，不在的話它會提示。

設定作者資料（之後每個新專案自動填入，三個欄位都可省略）：

```sh
mkdir -p ~/.config/ax
echo '{"author": "Aaron Lin", "id": "B12345678", "lang": "zh"}' > ~/.config/ax/config.json
```

最後跑 `ax doctor`，全部 `ok` 就完成了。

## 開始一份文件

```sh
ax new hw ode-hw3 --course 常微分方程 --number 3
cursor ode-hw3
```

在 Cursor 打開 `main.tex`，按 `Cmd+Option+V` 打開 PDF 預覽；之後每次存檔都會重新編譯並更新預覽。序言已經填好，直接寫內容即可：

```latex
\begin{problem}[一階線性方程]
解 $y' + 2y = e^{-x}$，$y(0) = 1$。
\begin{solution}
積分因子為 $e^{2x}$，得 $y = e^{-x}$。
\end{solution}
\end{problem}
```

只打 `ax new` 會用選單問你種類、資料夾和標題。六種文件：

| 種類 | 用途 |
|---|---|
| `hw` | 作業（題目、解答） |
| `note` | 講義、筆記 |
| `exam` | 考卷（配分、評分表） |
| `slides` | 簡報 |
| `book` | 論文、長篇講義 |
| `paper` | 投稿論文的內文（用會議模板，只借數學巨集） |

常用選項：`--title`、`--course`、`--lang zh`、`--bib`（參考文獻）。全部選項見[參考手冊](docs/reference.md#ax-new-的選項與專案內容)。

## 日常指令

在專案資料夾裡：

| 指令 | 作用 |
|---|---|
| `ax watch` | 存檔就重編（不用 Cursor 時） |
| `ax build` | 編譯一次；失敗時指出錯在哪一行，並保留上一份 PDF |
| `ax both` | 作業、考卷：同時產生題目卷和解答 |
| `ax pack` | 打包上傳 Overleaf（編譯器選 XeLaTeX） |
| `ax doctor` | 出問題時先跑這個 |

## 在 Cursor 裡寫

`ax new` 會在專案裡放 `.vscode/settings.json`，讓 LaTeX Workshop 用專案自己的編譯設定（XeLaTeX）。只影響這個專案，不會動到你的全域設定。

不是用 `ax new` 建的資料夾會沿用全域的 pdflatex 配方而編譯失敗；從任何一個 `ax` 專案把 `.vscode/` 和 `latexmkrc` 複製過去即可。

PDF 和原始碼互相跳轉：在原始碼按 `Cmd+Option+J` 跳到 PDF 對應的位置；在 PDF 上雙擊跳回原始碼。

## 舊文件不會壞

每個專案記住建立時的模板版本。模板之後改版，舊作業仍然照原樣編譯；想換新外觀時在專案裡跑 `ax upgrade`。

## 更多

- [參考手冊](docs/reference.md)：寫定理、程式碼、參考文獻、簡報、書的方法，所有文件選項，外觀規則，疑難排解，以及怎麼維護和發佈新版本
- [`examples/`](examples/)：每種文件的完整範例
- [`CHANGELOG.md`](CHANGELOG.md)：版本紀錄
