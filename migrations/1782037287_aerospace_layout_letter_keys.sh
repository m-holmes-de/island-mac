echo "AeroSpace: letter keys for layout — Hyper+T tiling, +A accordion, +M fullscreen, +V float"

CFG="$HOME/.config/aerospace/aerospace.toml"
[[ -f "$CFG" ]] || exit 0

# Rebind in place (full-line matches keep this idempotent and collision-free):
#   slash -> t (tiling), comma -> a (accordion), f -> m (fullscreen), t -> v (float toggle)
sed -i '' \
  -e "s|^cmd-ctrl-alt-slash = 'layout tiles horizontal vertical'|cmd-ctrl-alt-t = 'layout tiles horizontal vertical'|" \
  -e "s|^cmd-ctrl-alt-comma = 'layout accordion horizontal vertical'|cmd-ctrl-alt-a = 'layout accordion horizontal vertical'|" \
  -e "s|^cmd-ctrl-alt-f = 'fullscreen'|cmd-ctrl-alt-m = 'fullscreen'|" \
  -e "s|^cmd-ctrl-alt-t = 'layout floating tiling'|cmd-ctrl-alt-v = 'layout floating tiling'|" \
  "$CFG"

# Apply immediately if AeroSpace is running.
command -v aerospace >/dev/null 2>&1 && aerospace reload-config || true
