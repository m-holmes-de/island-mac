echo "nvim: apply theme via LazyVim colorscheme opt (was losing the race with LazyVim default)"

ISLAND_PATH="${ISLAND_PATH:-$HOME/.local/share/island-mac}"

# Re-apply the current theme so island-theme.lua is regenerated in the new format.
CURRENT=$(cat "$HOME/.local/state/island-mac/current-theme" 2>/dev/null || echo "rose-pine-moon")
if [[ "$CURRENT" == *:dark ]]; then
  "$ISLAND_PATH/bin/island-theme-set" "${CURRENT%:dark}" --dark
else
  "$ISLAND_PATH/bin/island-theme-set" "$CURRENT"
fi
