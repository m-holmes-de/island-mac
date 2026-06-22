echo "AeroSpace: add workspace 10 bindings — Hyper+0 switch, Hyper+Shift+0 move"

CFG="$HOME/.config/aerospace/aerospace.toml"
[[ -f "$CFG" ]] || exit 0

# Insert the workspace-10 bindings right after their workspace-9 siblings
# (keeps them inside [mode.main.binding]). Idempotent.
if ! grep -q "cmd-ctrl-alt-0 = 'workspace 10'" "$CFG"; then
  awk -v a="cmd-ctrl-alt-0 = 'workspace 10'" \
      -v b="cmd-ctrl-alt-shift-0 = 'move-node-to-workspace 10'" '
    { print }
    /^cmd-ctrl-alt-9 = / { print a }
    /^cmd-ctrl-alt-shift-9 = / { print b }
  ' "$CFG" > "$CFG.tmp" && mv "$CFG.tmp" "$CFG"
fi

command -v aerospace >/dev/null 2>&1 && aerospace reload-config || true
