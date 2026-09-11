echo "ghostty: Hyper+\` toggles the quick-terminal dropdown"

CFG="$HOME/.config/ghostty/config"
[[ -f "$CFG" ]] || exit 0

if grep -q 'toggle_quick_terminal' "$CFG"; then
  echo "  quick-terminal keybind already present"
  exit 0
fi

cat >> "$CFG" <<'EOF'

# Quick terminal (Quake-style dropdown) summoned from anywhere with Hyper+`
# (Caps Lock + backtick) — a scratch shell for island-tokens, island-herdr-ai,
# or anything. Global keybind: grant Ghostty access under System Settings >
# Privacy & Security > Accessibility, once.
keybind = global:cmd+ctrl+alt+grave_accent=toggle_quick_terminal
quick-terminal-position = top
EOF

echo "  Added quick-terminal keybind — restart Ghostty and grant it Accessibility to activate"
