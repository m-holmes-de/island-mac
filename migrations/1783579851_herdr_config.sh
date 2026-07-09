echo "Deploy island-mac herdr config (~/.config/herdr/config.toml)"

ISLAND_PATH="${ISLAND_PATH:-$HOME/.local/share/island-mac}"
SRC="$ISLAND_PATH/config/herdr/config.toml"
DEST_DIR="$HOME/.config/herdr"
DEST="$DEST_DIR/config.toml"
[[ -f "$SRC" ]] || exit 0

mkdir -p "$DEST_DIR"

# Back up a pre-existing, non-island-mac config once (e.g. herdr's own onboarding default).
if [[ -f "$DEST" ]] && ! grep -q "island-mac managed" "$DEST" && [[ ! -f "$DEST.pre-island-mac" ]]; then
  cp "$DEST" "$DEST.pre-island-mac"
  echo "  Backed up existing config.toml -> config.toml.pre-island-mac"
fi

# config.toml is repo-managed: deploy the island-mac version.
cp "$SRC" "$DEST"
echo "  Deployed ~/.config/herdr/config.toml from repo"

# Reload config in a running herdr server (no-op if none is running).
herdr server reload-config 2>/dev/null || true
