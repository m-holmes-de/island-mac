echo "ghostty: drop the Ctrl+Shift+F tmux-sessionizer keybind (tuios is on Ctrl+F now)"

CFG="$HOME/.config/ghostty/config"
[[ -f "$CFG" ]] || exit 0

if ! grep -q 'text:tmux-sessionizer' "$CFG"; then
  echo "  tmux-sessionizer keybind already gone"
  exit 0
fi

# Remove the Ctrl+Shift+F keybind and its two/three comment lines (the block added by
# 1788981915_ghostty_ctrl_shift_f_sessionizer.sh), leaving the rest untouched.
tmp=$(mktemp)
awk '
  /^# Ctrl\+Shift\+F -> tmux-sessionizer/ { skip = 1 }
  skip && /^keybind = ctrl\+shift\+f=text:tmux-sessionizer/ { skip = 0; next }
  skip { next }
  { print }
' "$CFG" > "$tmp" && mv "$tmp" "$CFG" || true
rm -f "$tmp" 2>/dev/null || true

# Collapse any doubled blank line left behind.
tmp=$(mktemp)
cat -s "$CFG" > "$tmp" && mv "$tmp" "$CFG" || true
rm -f "$tmp" 2>/dev/null || true

echo "  Removed — reload Ghostty config (Cmd+Shift+,) to activate"
