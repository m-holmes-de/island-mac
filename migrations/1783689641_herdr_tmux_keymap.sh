echo "herdr: install tmux-like keymap (ctrl+h/j/k/l pane focus, prefix panes/tabs)"

ISLAND_PATH="${ISLAND_PATH:-$HOME/.local/share/island-mac}"
CFG="$HOME/.config/herdr/config.toml"
SRC="$ISLAND_PATH/config/herdr/config.toml"
[[ -f "$CFG" && -f "$SRC" ]] || exit 0

# Pull the canonical [keys] block from the repo default (stays in sync with it).
KEYS=$(awk '/^\[keys\]/{k=1} k && /^\[/ && !/^\[keys\]/{exit} k{print}' "$SRC")
[[ "$KEYS" == *focus_pane_left* ]] || { echo "  ERROR: no [keys] in repo config" >&2; exit 1; }

tmp=$(mktemp)
if grep -q '^\[keys\]' "$CFG"; then
  # Split the deployed config around its [keys] section and splice the new block
  # in. Everything else — including the island-theme-set-managed [theme].name and
  # herdr's own additions — is preserved. (BSD awk can't take a multiline -v, so
  # we assemble the pieces with printf rather than passing KEYS into awk.)
  before=$(awk '/^\[keys\]/{exit} {print}' "$CFG")
  after=$(awk '/^\[keys\]/{ink=1; next} ink&&/^\[/{ink=0; started=1} ink{next} started{print}' "$CFG")
  { printf '%s\n\n' "$before"; printf '%s\n\n' "$KEYS"; printf '%s\n' "$after"; } > "$tmp"
else
  { cat "$CFG"; printf '\n%s\n' "$KEYS"; } > "$tmp"
fi

# Guard: only replace if the rebuild actually contains the new bindings.
if grep -q 'focus_pane_left' "$tmp"; then
  mv "$tmp" "$CFG"
  echo "  Installed tmux-like [keys] section"
else
  rm -f "$tmp"
  echo "  ERROR: keymap rebuild failed; left config untouched" >&2
  exit 1
fi

# Hot-reload the running herdr server (no-op if none is running).
command -v herdr >/dev/null 2>&1 && herdr server reload-config >/dev/null 2>&1 || true
