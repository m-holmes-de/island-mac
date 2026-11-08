echo "Deploy island-mac tuios config (macOS: ~/Library/Application Support/tuios)"

ISLAND_PATH="${ISLAND_PATH:-$HOME/.local/share/island-mac}"
SRC="$ISLAND_PATH/config/tuios/config.toml"
[[ -f "$SRC" ]] || exit 0

# On macOS tuios reads its OS-native config dir, not ~/.config — ask tuios where.
DEST=$(command -v tuios >/dev/null 2>&1 && tuios config path 2>/dev/null || true)
[[ -n "$DEST" ]] || DEST="$HOME/Library/Application Support/tuios/config.toml"
mkdir -p "$(dirname "$DEST")"

# Back up a pre-existing, non-island-mac config once (e.g. tuios's own default).
if [[ -f "$DEST" ]] && ! grep -q "island-mac managed" "$DEST" && [[ ! -f "$DEST.pre-island-mac" ]]; then
  cp "$DEST" "$DEST.pre-island-mac"
  echo "  Backed up existing config.toml -> config.toml.pre-island-mac"
fi

# config.toml is repo-managed: deploy the island-mac version.
cp "$SRC" "$DEST"
echo "  Deployed tuios config.toml from repo"

# Point appearance.theme at the tuios built-in matching the active island theme
# (island-theme-set does the same on every switch). Falls back to the config's
# default when no theme is recorded yet.
STATE="$HOME/.local/state/island-mac/current-theme"
if [[ -f "$STATE" ]]; then
  theme=$(cat "$STATE" 2>/dev/null || true)
  palette="$ISLAND_PATH/themes/$theme/colors.sh"
  if [[ -n "$theme" && -f "$palette" ]]; then
    # shellcheck disable=SC1090
    . "$palette"
    if [[ -n "${THEME_TUIOS:-}" ]]; then
      tmp=$(mktemp)
      awk -v newname="$THEME_TUIOS" '
        /^\[/ { in_appearance = ($0 == "[appearance]") }
        in_appearance && /^[ \t]*theme[ \t]*=/ { print "theme = \"" newname "\""; next }
        { print }
      ' "$DEST" > "$tmp" && mv "$tmp" "$DEST" || true
      rm -f "$tmp" 2>/dev/null || true
      echo "  tuios theme: $THEME_TUIOS"
    fi
  fi
fi

# Remove the stray ~/.config/tuios an earlier version of this migration deployed.
rm -rf "$HOME/.config/tuios" 2>/dev/null || true

# tuios watches the file and live-applies; `tuios config apply` also pushes it
# (a no-op when run from inside tuios).
command -v tuios >/dev/null 2>&1 && tuios config apply >/dev/null 2>&1 || true
