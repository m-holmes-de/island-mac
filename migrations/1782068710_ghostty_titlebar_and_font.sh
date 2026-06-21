echo "ghostty: larger font, blank title, hide folder proxy icon (re-apply theme)"

ISLAND_PATH="${ISLAND_PATH:-$HOME/.local/share/island-mac}"

# ghostty/config is theme-managed; re-apply the current theme to regenerate it
# from the updated template.
CURRENT=$(cat "$HOME/.local/state/island-mac/current-theme" 2>/dev/null || echo "rose-pine-moon")
if [[ "$CURRENT" == *:dark ]]; then
  "$ISLAND_PATH/bin/island-theme-set" "${CURRENT%:dark}" --dark
else
  "$ISLAND_PATH/bin/island-theme-set" "$CURRENT"
fi
