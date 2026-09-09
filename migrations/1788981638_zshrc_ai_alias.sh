echo "zsh: add the 'ai' alias (island-ai — run a worktree's ./ai.sh, tinted by branch color)"

# island-ai finds ai.sh at or above $PWD, names the session after the branch, and
# tints the pane with the worktree's branch color. It ships in $ISLAND_PATH/bin.

RC="$HOME/.zshrc"
[[ -f "$RC" ]] || exit 0

if grep -q "alias ai=" "$RC"; then
  echo "  'ai' alias already present"
  exit 0
fi

if grep -q "alias theme='island-theme-select'" "$RC"; then
  awk '
    { print }
    /alias theme=.island-theme-select./ {
      print "# Claude Code in the worktree you are standing in, tinted with its branch color."
      print "alias ai=\047island-ai\047"
    }
  ' "$RC" > "$RC.tmp" && mv "$RC.tmp" "$RC"
else
  printf "\n# island-mac helpers\nalias ai='island-ai'\n" >> "$RC"
fi
echo "  Added 'ai' alias (open a new shell, or: source ~/.zshrc)"
