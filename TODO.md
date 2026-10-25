# TODO

想到的點子和還沒驗證的事記在這裡，累積幾項再一起做、發一個版本。

## 待決定

- [ ] 簡報頁標題下的細線要不要拿掉（文件裡的灰線已經全部拿掉了）
- [ ] 要不要公開 repo：公開前決定 README／範例裡的真名，以及 commit 裡的 email 要不要換成 GitHub noreply

## 待驗證

- [ ] 在 Cursor 裡實際用一次：`Cmd+Option+V` 預覽、存檔自動編譯、`Cmd+Option+J` 和雙擊跳轉
- [ ] `ax pack` 的 zip 實際上傳 Overleaf 編譯一次（目前只驗證過 zip 能在沒裝模板的環境獨立編譯）
- [ ] MiKTeX（Windows）：沒測過，目前只支援 TeX Live

## 等需要時再做

- [ ] 本機更新 biber（`tlmgr update biber`，2.22 起修好 lipo 問題），之後刪掉 `~/bin/biber`

- [ ] 參考文獻顯示在邊欄（kaobook 的做法，配合 `layout=margin`）
- [ ] 把已固定在 v0.6 以前的專案升級（更新 TeX Live 到 2026-06 核心之後，作業、講義、考卷、書需要 `ax upgrade`）
