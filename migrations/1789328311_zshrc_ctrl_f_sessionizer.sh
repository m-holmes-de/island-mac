echo "zsh: Ctrl+F opens the herdr sessionizer (was: run ai in place)"

RC="$HOME/.zshrc"
[[ -f "$RC" ]] || exit 0

if grep -q 'bindkey -s \^f "island-sessionizer' "$RC"; then
  echo "  Ctrl+F already runs the sessionizer"
  exit 0
fi

# Only rebind the island-mac-shipped `ai` binding; a user who rebound Ctrl+F to
# something else keeps it.
if grep -q 'bindkey -s \^f "ai' "$RC"; then
  sed -i '' \
    -e 's|# Ctrl+F -> Claude Code in the worktree you are standing in (island-ai)|# Ctrl+F -> herdr sessionizer (pick a project, jump/create its workspace, optionally launch ai)|' \
    -e 's|bindkey -s \^f "ai\\n"|bindkey -s ^f "island-sessionizer\\n"|' \
    "$RC"
  echo "  Ctrl+F now opens island-sessionizer (open a new shell, or: source ~/.zshrc)"
else
  echo "  Ctrl+F is bound to something else — left alone"
fi
