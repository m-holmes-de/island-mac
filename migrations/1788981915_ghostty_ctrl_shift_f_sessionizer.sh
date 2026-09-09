echo "ghostty: Ctrl+Shift+F types tmux-sessionizer (Ctrl+F runs island-ai)"

CFG="$HOME/.config/ghostty/config"
[[ -f "$CFG" ]] || exit 0

if grep -q 'ctrl+shift+f=' "$CFG"; then
  echo "  Ctrl+Shift+F already bound"
  exit 0
fi

cat >> "$CFG" <<'EOF'

# Ctrl+Shift+F -> tmux-sessionizer. The terminal cannot tell Ctrl+Shift+F from
# Ctrl+F on the wire, so the shell cannot bind it — Ghostty types the command
# instead. Ctrl+F itself runs island-ai (~/.zshrc).
keybind = ctrl+shift+f=text:tmux-sessionizer\n
EOF
echo "  Added (reload Ghostty's config: Cmd+Shift+, )"
