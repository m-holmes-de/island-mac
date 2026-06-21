echo "AeroSpace: move float toggle from Hyper+V to Hyper+F"

CFG="$HOME/.config/aerospace/aerospace.toml"
[[ -f "$CFG" ]] || exit 0

# Rebind float toggle V -> F (full-line match keeps this idempotent).
sed -i '' \
  -e "s|^cmd-ctrl-alt-v = 'layout floating tiling'|cmd-ctrl-alt-f = 'layout floating tiling'|" \
  "$CFG"

# Apply immediately if AeroSpace is running.
command -v aerospace >/dev/null 2>&1 && aerospace reload-config || true
