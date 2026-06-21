echo "Theming: add starship to the theme system; re-apply current theme"

ISLAND_PATH="${ISLAND_PATH:-$HOME/.local/share/island-mac}"

# Deploy the default starship config if the user doesn't have one (no-clobber).
[[ -f "$HOME/.config/starship.toml" ]] || \
  cp "$ISLAND_PATH/config/starship.toml" "$HOME/.config/starship.toml" 2>/dev/null || true

# Re-apply the current theme so the new starship template is rendered alongside
# ghostty/tmux/nvim.
CURRENT=$(cat "$HOME/.local/state/island-mac/current-theme" 2>/dev/null || echo "rose-pine-moon")
if [[ "$CURRENT" == *:dark ]]; then
  "$ISLAND_PATH/bin/island-theme-set" "${CURRENT%:dark}" --dark
else
  "$ISLAND_PATH/bin/island-theme-set" "$CURRENT"
fi
