echo "herdr: retire the prefix+a popup binding (island-herdr-ai now runs from the Ghostty dropdown)"

CFG="$HOME/.config/herdr/config.toml"
[[ -f "$CFG" ]] || exit 0

# Idempotent: nothing to remove once the binding is gone.
if ! grep -q 'island-herdr-ai' "$CFG"; then
  echo "  prefix+a binding already absent"
  exit 0
fi

# Drop the comment block + the [[keys.command]] table (comment start through the
# command line, plus one trailing blank), leaving the rest untouched.
tmp=$(mktemp)
awk '
  /^[[:space:]]*# Custom command: prefix\+a/ { skip=1; next }
  skip {
    if ($0 ~ /^command = "island-herdr-ai"/) { skip=0; droptrailing=1 }
    next
  }
  droptrailing && /^[[:space:]]*$/ { droptrailing=0; next }
  { droptrailing=0; print }
' "$CFG" > "$tmp"

# Commit only if the binding is gone and the file still has its sections.
if ! grep -q 'island-herdr-ai' "$tmp" && grep -q '^\[session\]' "$tmp"; then
  mv "$tmp" "$CFG"
  echo "  Removed prefix+a -> island-herdr-ai"
else
  rm -f "$tmp"
  echo "  Unexpected config shape — left unchanged" >&2
  exit 1
fi

command -v herdr >/dev/null 2>&1 && herdr server reload-config >/dev/null 2>&1 || true
