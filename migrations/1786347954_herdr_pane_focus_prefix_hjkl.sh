echo "herdr: bind prefix+h/j/k/l to pane focus (was prefix-less ctrl+h/j/k/l)"

CFG="$HOME/.config/herdr/config.toml"
[[ -f "$CFG" ]] || exit 0
grep -q '^\[keys\]' "$CFG" || { echo "  No [keys] section — skipping" >&2; exit 0; }

# Idempotent: nothing to do if already on prefix chords.
if grep -q '^focus_pane_left[[:space:]]*=[[:space:]]*"prefix+h"' "$CFG"; then
  echo "  Already bound (prefix+h/j/k/l) — skipping"
  exit 0
fi

# Retarget the four focus_pane_* lines to prefix chords, whatever they hold now
# (ctrl+hjkl or otherwise). Preserves each line's own alignment via the capture.
tmp=$(mktemp)
sed -E \
  -e 's|^(focus_pane_left[[:space:]]*=[[:space:]]*)"[^"]*".*|\1"prefix+h"|' \
  -e 's|^(focus_pane_down[[:space:]]*=[[:space:]]*)"[^"]*".*|\1"prefix+j"|' \
  -e 's|^(focus_pane_up[[:space:]]*=[[:space:]]*)"[^"]*".*|\1"prefix+k"|' \
  -e 's|^(focus_pane_right[[:space:]]*=[[:space:]]*)"[^"]*".*|\1"prefix+l"|' \
  "$CFG" > "$tmp"

# Guard: only replace if all four landed.
if grep -q '^focus_pane_left[[:space:]]*=[[:space:]]*"prefix+h"' "$tmp" \
   && grep -q '^focus_pane_down[[:space:]]*=[[:space:]]*"prefix+j"' "$tmp" \
   && grep -q '^focus_pane_up[[:space:]]*=[[:space:]]*"prefix+k"' "$tmp" \
   && grep -q '^focus_pane_right[[:space:]]*=[[:space:]]*"prefix+l"' "$tmp"; then
  mv "$tmp" "$CFG"
  echo "  Bound prefix+h/j/k/l = pane focus left/down/up/right"
else
  rm -f "$tmp"
  echo "  ERROR: pane-focus rebind failed; left config untouched" >&2
  exit 1
fi

# Hot-reload the running herdr server (no-op if none is running).
command -v herdr >/dev/null 2>&1 && herdr server reload-config >/dev/null 2>&1 || true
