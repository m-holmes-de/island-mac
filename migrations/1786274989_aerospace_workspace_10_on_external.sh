echo "AeroSpace: pin workspace 10 to the external (secondary) display"

CFG="$HOME/.config/aerospace/aerospace.toml"
[[ -f "$CFG" ]] || exit 0

# Force workspace 10 onto the external display so a connected monitor shows
# workspace 10 instead of an arbitrary/extra workspace. `secondary` is the
# non-primary monitor in a two-monitor setup; with only the built-in display
# present, workspace 10 falls back to it (no-op single-monitor).
# Appending a top-level TOML table at EOF is safe (table order is irrelevant).
if ! grep -q '^\[workspace-to-monitor-force-assignment\]' "$CFG"; then
  cat >> "$CFG" <<'EOF'

# Pin workspace 10 (Hyper+0) to the external display. `secondary` is the
# non-primary monitor in a two-monitor setup, so when an external display is
# connected it shows workspace 10 rather than an arbitrary/extra workspace.
# With only the built-in display present, workspace 10 falls back to it.
[workspace-to-monitor-force-assignment]
10 = 'secondary'
EOF
  echo "  Added workspace-to-monitor-force-assignment (10 -> secondary)"
else
  echo "  Force-assignment already present"
fi

# Apply immediately if AeroSpace is running.
command -v aerospace >/dev/null 2>&1 && aerospace reload-config || true
