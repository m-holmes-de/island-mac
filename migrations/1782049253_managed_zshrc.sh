echo "Deploy island-mac managed ~/.zshrc"

ISLAND_PATH="${ISLAND_PATH:-$HOME/.local/share/island-mac}"
SRC="$ISLAND_PATH/default/.zshrc"
DEST="$HOME/.zshrc"
[[ -f "$SRC" ]] || exit 0

# Back up a pre-existing, non-island-mac ~/.zshrc once.
if [[ -f "$DEST" ]] && ! grep -q "Island-mac ZSH" "$DEST" && [[ ! -f "$DEST.pre-island-mac" ]]; then
  cp "$DEST" "$DEST.pre-island-mac"
  echo "  Backed up existing ~/.zshrc -> ~/.zshrc.pre-island-mac"
fi

# .zshrc is repo-managed: copy the repo version over the deployed one.
cp "$SRC" "$DEST"
echo "  Deployed ~/.zshrc from repo"
