echo "herdr: bind prefix+u / prefix+i to previous/next agent"

CFG="$HOME/.config/herdr/config.toml"
[[ -f "$CFG" ]] || exit 0

# Idempotent: nothing to do if the new bindings are already in place.
if grep -q '^previous_agent[[:space:]]*=[[:space:]]*"prefix+u"' "$CFG"; then
  echo "  Already bound (prefix+u / prefix+i) — skipping"
  exit 0
fi

# Retarget only the two agent-nav lines; leave the rest of the user's config
# (theme, any personal key tweaks) untouched. Match whatever value is currently
# bound so this works regardless of the prior keymap (shift+j/k or otherwise).
tmp=$(mktemp)
sed -E \
  -e 's|^(previous_agent[[:space:]]*=[[:space:]]*)"[^"]*".*|\1"prefix+u"         # focus the previous agent|' \
  -e 's|^(next_agent[[:space:]]*=[[:space:]]*)"[^"]*".*|\1"prefix+i"         # focus the next agent|' \
  "$CFG" > "$tmp"

# Guard: only replace if both bindings landed.
if grep -q '^previous_agent[[:space:]]*=[[:space:]]*"prefix+u"' "$tmp" \
   && grep -q '^next_agent[[:space:]]*=[[:space:]]*"prefix+i"' "$tmp"; then
  mv "$tmp" "$CFG"
  echo "  Bound prefix+u = previous_agent, prefix+i = next_agent"
else
  rm -f "$tmp"
  echo "  ERROR: agent-nav rebind failed; left config untouched" >&2
  exit 1
fi

# Hot-reload the running herdr server (no-op if none is running).
command -v herdr >/dev/null 2>&1 && herdr server reload-config >/dev/null 2>&1 || true
