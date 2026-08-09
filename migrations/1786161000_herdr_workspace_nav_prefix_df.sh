echo "herdr: bind prefix+d / prefix+f to previous/next workspace"

CFG="$HOME/.config/herdr/config.toml"
[[ -f "$CFG" ]] || exit 0
grep -q '^\[keys\]' "$CFG" || { echo "  No [keys] section — skipping" >&2; exit 0; }

# Idempotent: nothing to do if the new bindings are already in place.
if grep -q '^previous_workspace[[:space:]]*=[[:space:]]*"prefix+d"' "$CFG"; then
  echo "  Already bound (prefix+d / prefix+f) — skipping"
  exit 0
fi

tmp=$(mktemp)
if grep -qE '^previous_workspace[[:space:]]*=' "$CFG"; then
  # A binding already exists (e.g. a prior prefix+shift+u/i keymap, or unset ""):
  # retarget the two lines in place, whatever their current value.
  sed -E \
    -e 's|^(previous_workspace[[:space:]]*=[[:space:]]*)"[^"]*".*|\1"prefix+d"  # focus the previous workspace|' \
    -e 's|^(next_workspace[[:space:]]*=[[:space:]]*)"[^"]*".*|\1"prefix+f"  # focus the next workspace|' \
    "$CFG" > "$tmp"
else
  # Not present at all (relying on herdr defaults): insert after the agent block,
  # anchored on focus_agent so the workspace lines sit beside their agent peers.
  awk '
    {print}
    /^focus_agent[[:space:]]*=/ {
      print ""
      print "# Workspaces (prefix): walk previous/next on d/f — adjacent home-row keys, both"
      print "# free of herdr defaults (close_workspace is prefix+shift+d, not prefix+d)."
      print "previous_workspace = \"prefix+d\"  # focus the previous workspace"
      print "next_workspace     = \"prefix+f\"  # focus the next workspace"
    }
  ' "$CFG" > "$tmp"
fi

# Guard: only replace if both bindings landed.
if grep -q '^previous_workspace[[:space:]]*=[[:space:]]*"prefix+d"' "$tmp" \
   && grep -q '^next_workspace[[:space:]]*=[[:space:]]*"prefix+f"' "$tmp"; then
  mv "$tmp" "$CFG"
  echo "  Bound prefix+d = previous_workspace, prefix+f = next_workspace"
else
  rm -f "$tmp"
  echo "  ERROR: workspace-nav bind failed; left config untouched" >&2
  exit 1
fi

# Hot-reload the running herdr server (no-op if none is running).
command -v herdr >/dev/null 2>&1 && herdr server reload-config >/dev/null 2>&1 || true
