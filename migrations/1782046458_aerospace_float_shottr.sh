echo "AeroSpace: always float Shottr so its screenshot window stays visible"

CFG="$HOME/.config/aerospace/aerospace.toml"
[[ -f "$CFG" ]] || exit 0

# Add an on-window-detected rule that floats Shottr, if not already present.
# (TOML table order is irrelevant, so appending at EOF is safe.)
if ! grep -q "cc.ffitch.shottr" "$CFG"; then
  cat >> "$CFG" <<'EOF'

# Float Shottr so its screenshot/annotation window is never pushed behind
# tiled windows. AeroSpace can't auto-center floating windows; Shottr positions
# its own window.
[[on-window-detected]]
if.app-id = 'cc.ffitch.shottr'
run = ['layout floating']
EOF
fi

# Apply immediately if AeroSpace is running.
command -v aerospace >/dev/null 2>&1 && aerospace reload-config || true
