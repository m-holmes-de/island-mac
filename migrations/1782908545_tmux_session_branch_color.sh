echo "tmux: color the session name with the project's per-worktree branch color"

# Adds a second session-created hook that runs island-tmux-session-color, which
# reads .metamind-instance.json ".branchColor" from the session's directory and
# tints the status-left. The script ships in $ISLAND_PATH/bin (synced on update).

CFG="$HOME/.config/tmux/tmux.conf"
[[ -f "$CFG" ]] || exit 0

HOOK='set-hook -ga session-created '\''run-shell "~/.local/share/island-mac/bin/island-tmux-session-color #{session_name}"'\'''

# Idempotent: only add the hook if it is not already present.
if ! grep -q 'island-tmux-session-color' "$CFG"; then
  # Insert right after the existing island-tmux-windows session-created hook so
  # the two stay together.
  awk -v hook="$HOOK" '
    { print }
    /island-tmux-windows #\{session_name\}/ {
      print "# Tint the session name with the project'\''s per-worktree branch color, if any."
      print hook
    }
  ' "$CFG" > "$CFG.tmp" && mv "$CFG.tmp" "$CFG"
  echo "  Added session-color hook"
else
  echo "  Session-color hook already present"
fi

# Reload the running server (best effort) so the hook takes effect immediately.
if tmux has-session 2>/dev/null; then
  tmux source-file "$CFG" 2>/dev/null || true
fi
