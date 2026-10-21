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
kpsewhich aaron-core.sty
