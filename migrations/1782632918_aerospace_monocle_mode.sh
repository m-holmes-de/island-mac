echo "AeroSpace: add monocle mode — Hyper+M maximizes, Hyper+h/j/k/l flips between maximized windows"

CFG="$HOME/.config/aerospace/aerospace.toml"
[[ -f "$CFG" ]] || exit 0

# Idempotent: only patch if the monocle mode is not present yet.
if ! grep -q '\[mode.monocle.binding\]' "$CFG"; then
  # 1. Turn Hyper+M into "maximize then enter monocle mode".
  sed -i '' "s|^cmd-ctrl-alt-m = 'fullscreen'.*|cmd-ctrl-alt-m = ['fullscreen on', 'mode monocle']        # M = Maximize -> monocle mode|" "$CFG"

  # 2. Append the monocle mode block. In this mode, focusing a neighbour
  #    auto-exits the old window's fullscreen and we re-fullscreen the new one,
  #    so Hyper+h/j/k/l flips between maximized windows. Hyper+M exits.
  cat >> "$CFG" <<'EOF'

# --- Monocle: maximized window + flip between other maximized windows ---
[mode.monocle.binding]
cmd-ctrl-alt-m = ['fullscreen off', 'mode main']
cmd-ctrl-alt-h = ['focus left', 'fullscreen on']
cmd-ctrl-alt-j = ['focus down', 'fullscreen on']
cmd-ctrl-alt-k = ['focus up', 'fullscreen on']
cmd-ctrl-alt-l = ['focus right', 'fullscreen on']
EOF

  echo "  Added monocle mode"
else
  echo "  Monocle mode already present"
fi

command -v aerospace >/dev/null 2>&1 && aerospace reload-config || true
