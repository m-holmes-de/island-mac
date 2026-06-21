echo "tmux: add session-created hook for standard 4 windows (claude/server/yazi/term)"

CFG="$HOME/.config/tmux/tmux.conf"
[[ -f "$CFG" ]] || exit 0

# Append the hook to the deployed tmux.conf if not already present.
if ! grep -q "island-tmux-windows" "$CFG"; then
  cat >> "$CFG" <<'EOF'

# Standard window layout: every new session gets claude/server/yazi/term
set-hook -g session-created 'run-shell "~/.local/share/island-mac/bin/island-tmux-windows #{session_name}"'
EOF
fi

# Load the hook into a running tmux server (applies to sessions created from now on).
tmux set-hook -g session-created \
  'run-shell "~/.local/share/island-mac/bin/island-tmux-windows #{session_name}"' 2>/dev/null || true
