echo "herdr: prefix+a opens the AI layout assistant (island-herdr-ai) in a popup pane"

CFG="$HOME/.config/herdr/config.toml"
[[ -f "$CFG" ]] || exit 0

# Idempotent: the binding is identified by the command it runs.
if grep -q 'island-herdr-ai' "$CFG"; then
  echo "  prefix+a already bound"
  exit 0
fi

# Insert the [[keys.command]] array-of-tables after the last [keys] scalar
# (next_workspace) so it stays inside [keys] and ahead of the next table.
tmp=$(mktemp)
awk '
  { print }
  /^next_workspace[[:space:]]*=/ {
    print ""
    print "# Custom command: prefix+a (\"ask\") opens the AI layout assistant in a temporary"
    print "# pane. Describe a layout change in plain language; Claude proposes the herdr"
    print "# commands and you approve before they run. type = \"pane\" closes it on exit."
    print "[[keys.command]]"
    print "key = \"prefix+a\""
    print "type = \"pane\""
    print "command = \"island-herdr-ai\""
  }
' "$CFG" > "$tmp"

# Only commit if the anchor was found and the block landed.
if grep -q 'command = "island-herdr-ai"' "$tmp"; then
  mv "$tmp" "$CFG"
  echo "  Added prefix+a -> island-herdr-ai"
else
  rm -f "$tmp"
  echo "  Could not find the next_workspace anchor — left config unchanged" >&2
  exit 1
fi

# Apply immediately if a herdr server is running.
command -v herdr >/dev/null 2>&1 && herdr server reload-config >/dev/null 2>&1 || true
