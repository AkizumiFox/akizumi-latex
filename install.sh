#!/bin/sh
# Link this repo into TEXMFHOME so every document on this machine can use it.
set -e
here="$(cd "$(dirname "$0")" && pwd)"
dest="$(kpsewhich -var-value TEXMFHOME)/tex/latex/aaron-latex"
mkdir -p "$(dirname "$dest")"
if [ -e "$dest" ] && [ ! -L "$dest" ]; then
  echo "$dest exists and is not a symlink; refusing to overwrite." >&2; exit 1
fi
ln -sfn "$here" "$dest"
echo "linked $dest -> $here"
mkdir -p "$HOME/bin"
for tool in ax aaron-both; do
  ln -sfn "$here/bin/$tool" "$HOME/bin/$tool"
  echo "linked ~/bin/$tool"
done

# TeX Live's biber fails to start with current Command Line Tools on macOS;
# link the stand-in only when that is the case (README, Troubleshooting).
texbiber=/Library/TeX/texbin/biber
if [ -x "$texbiber" ] && ! "$texbiber" --version >/dev/null 2>&1; then
  ln -sfn "$here/bin/biber" "$HOME/bin/biber"
  echo "linked ~/bin/biber (TeX Live's biber does not start here)"
fi

case ":$PATH:" in
  *":$HOME/bin:"*) ;;
  *) echo "note: add ~/bin to PATH, e.g. echo 'export PATH=\"\$HOME/bin:\$PATH\"' >> ~/.zshrc" ;;
esac
kpsewhich aaron-core.sty
