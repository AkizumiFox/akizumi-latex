# akizumi-latex

English: [README.en.md](README.en.md)

作業、講義、考卷、簡報、論文共用的 LaTeX 模板，加上建立和編譯專案的指令 `ax`。文件可以用中文、英文、日文、韓文寫，也可以混著寫。

## 安裝

macOS、Linux、Windows 都可以用。三者都需要 **TeX Live**、**git**、**Python 3**：

| 系統 | 先裝 |
|---|---|
| macOS | [MacTeX](https://tug.org/mactex/)、`xcode-select --install`（git） |
| Linux | [TeX Live](https://tug.org/texlive/)（或發行版的 `texlive-full`）、git、python3；中文字型建議 `fonts-noto-cjk` |
| Windows | [TeX Live](https://tug.org/texlive/windows.html)、[Git for Windows](https://git-scm.com/)、[Python](https://www.python.org/)（安裝時勾 py launcher） |

MiKTeX 沒有測試過，請用 TeX Live。

```sh
git clone https://github.com/AkizumiFox/akizumi-latex.git akizumi-latex
cd akizumi-latex
python3 install.py        # Windows：py install.py
```

`install.py` 把模板掛進 TeX，並讓終端機找得到 `ax`：macOS 放在 `~/bin`，Linux 放在 `~/.local/bin`，Windows 會把 repo 的 `bin` 資料夾加進 PATH。裝完**開一個新的終端機**，跑 `ax doctor`，沒有 ✗ 就完成了。

設定作者資料：`ax config` 會顯示設定資料夾在哪裡（macOS、Linux 是 `~/.config/ax/`，Windows 在 `%APPDATA%\ax\`），在裡面建 `config.json`：

```json
{"author": "Aaron Lin", "id": "B12345678", "lang": "zh"}
```

三個欄位都可省略，之後每個新專案會自動填入。`lang` 是新文件的主語言：`en`、`zh`、`ja`、`ko`。

`ax` 本身的訊息有中文和英文，跟著系統語言走；想指定就在 `config.json` 加 `"ui": "zh"` 或 `"ui": "en"`（或設環境變數 `AX_LANG`）。

**Tab 補全**（選用）：在 `~/.zshrc` 加 `eval "$(ax completion zsh)"`，之後打 `ax ` 再按 Tab 就會列出指令和文件種類。bash、PowerShell 的寫法見 `ax completion --help`。

## 開始一份文件

```sh
ax new hw ode-hw3 --course 常微分方程 --number 3
cursor ode-hw3
```

在 Cursor 打開 `main.tex`，按 `Cmd+Option+V`（Windows、Linux：`Ctrl+Alt+V`）打開 PDF 預覽；之後每次存檔都會重新編譯並更新預覽。序言已經填好，直接寫內容即可：

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

常用選項：`--title`、`--course`、`--lang zh|ja|ko`、`--thmnames native`（定理、證明取代 Theorem、Proof）、`--bib`（參考文獻）。全部選項見[參考手冊](docs/reference.md#ax-new-的選項與專案內容)。

## 日常指令

在專案資料夾（或它的任何子資料夾）裡：

| 指令 | 作用 |
|---|---|
| `ax` | 這個專案的狀態：種類、模板版本、PDF 什麼時候更新的 |
| `ax watch` | 存檔就重編（不用 Cursor 時） |
| `ax build` | 編譯一次；失敗時指出錯在哪一行、附上白話提示，並保留上一份 PDF |
| `ax open` | 打開 PDF（`--solutions` 打開解答） |
| `ax both` | 作業、考卷：同時產生題目卷和解答 |
| `ax pack` | 打包上傳 Overleaf（編譯器選 XeLaTeX） |
| `ax doctor` | 出問題時先跑這個 |

打錯指令時 `ax` 會猜你想打什麼，例如 `ax biuld` 會問你是不是要 `ax build`。

## 在 Cursor 裡寫

`ax new` 會在專案裡放 `.vscode/settings.json`，讓 LaTeX Workshop 用專案自己的編譯設定（XeLaTeX）。只影響這個專案，不會動到你的全域設定。

不是用 `ax new` 建的資料夾會沿用全域的 pdflatex 配方而編譯失敗；從任何一個 `ax` 專案把 `.vscode/` 和 `latexmkrc` 複製過去即可。

PDF 和原始碼互相跳轉：在原始碼按 `Cmd+Option+J`（`Ctrl+Alt+J`）跳到 PDF 對應的位置；在 PDF 上雙擊跳回原始碼。

同一個專案可以放進 git，在 macOS、Linux、Windows 之間來回編譯；專案裡沒有任何只屬於某台電腦的路徑。

## 自訂 preamble

在設定資料夾（`ax config` 顯示的位置）放這些檔案，`ax new` 會把內容複製進新專案的 `main.tex`：

| 檔案 | 套用到 |
|---|---|
| `preamble.tex` | 每一種新專案（`paper` 除外，它跟著會議模板） |
| `preamble-hw.tex`、`preamble-slides.tex`⋯ | 只有那一種 |

每種文件的預設選項寫在 `config.json` 的 `defaults`，命令列給的選項優先：

```json
{
  "author": "Aaron Lin",
  "defaults": {
    "slides": {"progress": true, "lang": "en"},
    "note": {"layout": "margin"}
  }
}
```

內容是建立時複製進去的，所以之後改 preamble 不會影響舊專案。單次不要套用：`ax new ... --no-preamble`。

## 舊文件不會壞

每個專案記住建立時的模板版本。模板之後改版，舊作業仍然照原樣編譯；想換新外觀時在專案裡跑 `ax upgrade`。

## 更多

- [參考手冊](docs/reference.md)：寫定理、程式碼、參考文獻、簡報、書的方法，所有文件選項，外觀規則，疑難排解，以及怎麼維護和發佈新版本
- [`examples/`](examples/)：每種文件的完整範例
- [`CHANGELOG.md`](CHANGELOG.md)：版本紀錄
