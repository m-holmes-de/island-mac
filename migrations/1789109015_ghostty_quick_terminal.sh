echo "ghostty: Cmd+. toggles the quick-terminal dropdown"

CFG="$HOME/.config/ghostty/config"
[[ -f "$CFG" ]] || exit 0

if grep -q 'toggle_quick_terminal' "$CFG"; then
  echo "  quick-terminal keybind already present"
  exit 0
fi

cat >> "$CFG" <<'EOF'

# Quick terminal (Quake-style dropdown) toggled with Cmd+. while Ghostty is
# focused — a scratch shell for island-tokens, island-herdr-ai, or anything.
# Not a global: keybind, so it needs no Accessibility permission — just a config
# reload (Cmd+Shift+,).
keybind = cmd+period=toggle_quick_terminal
quick-terminal-position = top
EOF

echo "  Added quick-terminal keybind (Cmd+.) — reload Ghostty config (Cmd+Shift+,) to activate"
