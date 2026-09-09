echo "zsh: Ctrl+F runs island-ai (was tmux-sessionizer)"

RC="$HOME/.zshrc"
[[ -f "$RC" ]] || exit 0

if grep -q 'bindkey -s \^f "ai' "$RC"; then
  echo "  Ctrl+F already runs ai"
  exit 0
fi

if grep -q 'bindkey -s \^f "tmux-sessionizer' "$RC"; then
  # A user who rebound Ctrl+F to something else keeps it: only the shipped
  # tmux-sessionizer binding is replaced.
  sed -i '' \
    -e 's|# Ctrl+F -> tmux-sessionizer (provide your own script on PATH)|# Ctrl+F -> Claude Code in the worktree you are standing in (island-ai)|' \
    -e 's|bindkey -s \^f "tmux-sessionizer\\n"|bindkey -s ^f "ai\\n"|' \
    "$RC"
  echo "  Ctrl+F now runs ai (open a new shell, or: source ~/.zshrc)"
else
  echo "  Ctrl+F is bound to something else — left alone"
fi
