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
ln -sfn "$here/bin/aaron-both" "$HOME/bin/aaron-both"
echo "linked ~/bin/aaron-both"
kpsewhich aaron-core.sty
