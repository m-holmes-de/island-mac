echo "herdr: bind goto / session viewer to prefix+space (was prefix+g)"

CFG="$HOME/.config/herdr/config.toml"
[[ -f "$CFG" ]] || exit 0
grep -q '^\[keys\]' "$CFG" || { echo "  No [keys] section — skipping" >&2; exit 0; }

# Idempotent: nothing to do if already bound.
if grep -q '^goto[[:space:]]*=[[:space:]]*"prefix+space"' "$CFG"; then
  echo "  Already bound (prefix+space) — skipping"
  exit 0
fi

tmp=$(mktemp)
if grep -qE '^goto[[:space:]]*=' "$CFG"; then
  # A goto binding already exists (default prefix+g or otherwise): retarget it.
  sed -E \
    -e 's|^(goto[[:space:]]*=[[:space:]]*)"[^"]*".*|\1"prefix+space"|' \
    "$CFG" > "$tmp"
else
  # Not present (relying on herdr's prefix+g default): insert after the prefix
  # line so the goto binding sits at the top of the [keys] block.
  awk '
    {print}
    /^prefix[[:space:]]*=/ {
      print ""
      print "# Goto / session viewer \xE2\x80\x94 jump to any workspace, tab, pane, or agent. On"
      print "# prefix+space (thumb stays on the prefix key) rather than the default prefix+g."
      print "goto = \"prefix+space\""
    }
  ' "$CFG" > "$tmp"
fi

# Guard: only replace if the binding landed.
if grep -q '^goto[[:space:]]*=[[:space:]]*"prefix+space"' "$tmp"; then
  mv "$tmp" "$CFG"
  echo "  Bound prefix+space = goto"
else
  rm -f "$tmp"
  echo "  ERROR: goto rebind failed; left config untouched" >&2
  exit 1
fi

# Hot-reload the running herdr server (no-op if none is running).
command -v herdr >/dev/null 2>&1 && herdr server reload-config >/dev/null 2>&1 || true
