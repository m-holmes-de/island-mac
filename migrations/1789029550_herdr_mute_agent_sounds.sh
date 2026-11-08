echo "herdr: mute the agent sound cues (finished / needs-attention dings)"

CFG="$HOME/.config/herdr/config.toml"
[[ -f "$CFG" ]] || exit 0

# Idempotent: nothing to do once sound is already disabled. `enabled` only appears
# under [ui.sound] in the island-mac config, so the match is unambiguous.
if grep -q '^enabled[[:space:]]*=[[:space:]]*false' "$CFG"; then
  echo "  agent sounds already off"
  exit 0
fi
if ! grep -q '^enabled[[:space:]]*=[[:space:]]*true' "$CFG"; then
  echo "  no [ui.sound] enabled = true to flip — left unchanged"
  exit 0
fi

tmp=$(mktemp)
sed -E 's|^enabled[[:space:]]*=[[:space:]]*true|enabled = false|' "$CFG" > "$tmp"

if grep -q '^enabled = false' "$tmp"; then
  mv "$tmp" "$CFG"
  echo "  [ui.sound] enabled = false"
else
  rm -f "$tmp"
  exit 1
fi

# Apply immediately if a herdr server is running.
command -v herdr >/dev/null 2>&1 && herdr server reload-config >/dev/null 2>&1 || true
