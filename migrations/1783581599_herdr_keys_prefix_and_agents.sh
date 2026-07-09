echo "herdr: set ctrl+space prefix and agent-switching keybindings"

ISLAND_PATH="${ISLAND_PATH:-$HOME/.local/share/island-mac}"
SRC="$ISLAND_PATH/config/herdr/config.toml"
DEST_DIR="$HOME/.config/herdr"
DEST="$DEST_DIR/config.toml"
[[ -f "$SRC" ]] || exit 0

mkdir -p "$DEST_DIR"

# config.toml is repo-managed: redeploy the island-mac version (now with [keys]).
cp "$SRC" "$DEST"
echo "  Deployed ~/.config/herdr/config.toml from repo"

# Reload config in a running herdr server (no-op if none is running).
herdr server reload-config 2>/dev/null || true
