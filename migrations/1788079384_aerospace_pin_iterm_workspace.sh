echo "AeroSpace: pin iTerm2 to workspace 6 so its windows stop wandering"

CFG="$HOME/.config/aerospace/aerospace.toml"
[[ -f "$CFG" ]] || exit 0

# iTerm's windows drift onto whatever workspace is focused (AeroSpace re-detects
# them on certain macOS window events and assigns them to the active workspace),
# and dismissing a transient app like Shottr hands focus back to iTerm, dragging
# you to its workspace. A fixed on-window-detected assignment makes iTerm's home
# deterministic. Idempotent: skip if a rule for the iTerm app-id already exists.
# (TOML table order is irrelevant, so appending at EOF is safe.)
if ! grep -q "com.googlecode.iterm2" "$CFG"; then
  cat >> "$CFG" <<'EOF'

# Pin iTerm2 to workspace 6 so its windows stop drifting onto the focused
# workspace. Change '6' to move iTerm's home, or delete this block to undo.
[[on-window-detected]]
if.app-id = 'com.googlecode.iterm2'
run = ['move-node-to-workspace 6']
EOF
  echo "  Added on-window-detected rule (iTerm2 -> workspace 6)"
else
  echo "  iTerm2 assignment already present"
fi

# Apply immediately if AeroSpace is running.
command -v aerospace >/dev/null 2>&1 && aerospace reload-config || true
