echo "ghostty: Cmd+U runs island-tokens, Cmd+Y runs yazi (quick-launch in the dropdown)"

CFG="$HOME/.config/ghostty/config"
[[ -f "$CFG" ]] || exit 0

if grep -q 'text:island-tokens' "$CFG"; then
  echo "  tool-launch keybinds already present"
  exit 0
fi

cat >> "$CFG" <<'EOF'

# Quick-launch a tool in the focused pane — handy in the Cmd+. dropdown: Cmd+U runs
# island-tokens (Claude usage), Cmd+Y runs yazi (files). For a side-by-side HUD, split
# the dropdown first with Cmd+D, then Cmd+U in one pane and Cmd+Y in the other.
keybind = cmd+u=text:island-tokens\n
keybind = cmd+y=text:yazi\n
EOF

echo "  Added Cmd+U / Cmd+Y — reload Ghostty config (Cmd+Shift+,) to activate"
