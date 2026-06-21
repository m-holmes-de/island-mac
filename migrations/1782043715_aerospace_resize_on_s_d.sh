echo "AeroSpace: resize on letter keys — Hyper+S shrink, Hyper+D grow"

CFG="$HOME/.config/aerospace/aerospace.toml"
[[ -f "$CFG" ]] || exit 0

# Move resize off minus/equal onto S (shrink) and D (grow). Idempotent.
sed -i '' \
  -e "s|^cmd-ctrl-alt-minus = 'resize smart -50'|cmd-ctrl-alt-s = 'resize smart -50'|" \
  -e "s|^cmd-ctrl-alt-equal = 'resize smart +50'|cmd-ctrl-alt-d = 'resize smart +50'|" \
  "$CFG"

# Apply immediately if AeroSpace is running.
command -v aerospace >/dev/null 2>&1 && aerospace reload-config || true
