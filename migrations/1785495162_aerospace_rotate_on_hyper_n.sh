echo "AeroSpace: rotate tiling orientation on Hyper+N (was Hyper+T)"

CFG="$HOME/.config/aerospace/aerospace.toml"
[[ -f "$CFG" ]] || exit 0

# Move the tiling-orientation toggle off T (top QWERT row) onto N. Idempotent:
# once rewritten the line starts with cmd-ctrl-alt-n and no longer matches.
sed -i '' \
  -e "s|^cmd-ctrl-alt-t = 'layout tiles horizontal vertical'.*|cmd-ctrl-alt-n = 'layout tiles horizontal vertical'       # N = rotate tiling orientation (horizontal <-> vertical)|" \
  "$CFG"

# Apply immediately if AeroSpace is running.
command -v aerospace >/dev/null 2>&1 && aerospace reload-config || true
