echo "AeroSpace: make key-mapping QWERTZ-aware (swap Z/Y to match DE keyboard labels)"

CFG="$HOME/.config/aerospace/aerospace.toml"
[[ -f "$CFG" ]] || exit 0

# Append the QWERTZ swap as its own TOML table if not already present.
# (TOML table order is irrelevant, so appending at EOF is safe.)
if ! grep -q '^\[key-mapping.key-notation-to-key-code\]' "$CFG"; then
  cat >> "$CFG" <<'EOF'

# German QWERTZ: swap Z/Y so those notations match the printed DE labels.
# AeroSpace binds to physical key positions; on a DE board the only letter keys
# that differ from US-QWERTY are Z and Y.
[key-mapping.key-notation-to-key-code]
z = 'y'
y = 'z'
EOF
fi

# Apply immediately if AeroSpace is running.
command -v aerospace >/dev/null 2>&1 && aerospace reload-config || true
