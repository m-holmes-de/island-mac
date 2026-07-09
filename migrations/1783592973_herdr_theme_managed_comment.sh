echo "herdr: normalize [theme] comment (theme now managed by island-theme-set)"

CFG="$HOME/.config/herdr/config.toml"
[[ -f "$CFG" ]] || exit 0

OLD="# Matches island-mac's default rose-pine-moon palette."
NEW="# Theme managed by island-theme-set (tracks the active island-mac theme)."

if grep -qF "$OLD" "$CFG"; then
  tmp=$(mktemp)
  # Exact-line match, single-line replacement — safe and idempotent.
  awk -v new="$NEW" '$0 == "# Matches island-mac'\''s default rose-pine-moon palette." { print new; next } { print }' "$CFG" > "$tmp" \
    && mv "$tmp" "$CFG"
  rm -f "$tmp" 2>/dev/null || true
  echo "  Updated [theme] comment"
else
  echo "  Already normalized"
fi
