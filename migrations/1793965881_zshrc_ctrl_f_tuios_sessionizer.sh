echo "zsh: Ctrl+F opens the tuios sessionizer (was: herdr sessionizer)"

RC="$HOME/.zshrc"
[[ -f "$RC" ]] || exit 0

if grep -q 'bindkey -s \^f "island-tuios-sessionizer' "$RC"; then
  echo "  Ctrl+F already opens the tuios sessionizer"
  exit 0
fi

# Only rebind the island-mac-shipped herdr-sessionizer binding; a user who rebound
# Ctrl+F to something else keeps it.
if grep -q 'bindkey -s \^f "island-sessionizer' "$RC"; then
  sed -i '' \
    -e 's|# Ctrl+F -> herdr sessionizer:.*|# Ctrl+F -> tuios sessionizer: fuzzy-pick a project and open/create its tuios|' \
    -e 's|# optionally launching the ai wrapper.*|# session (inside tuios, a new window instead). (`ai` still runs Claude in place.)|' \
    -e 's|bindkey -s \^f "island-sessionizer\\n"|bindkey -s ^f "island-tuios-sessionizer\\n"|' \
    "$RC"
  echo "  Ctrl+F now opens island-tuios-sessionizer (open a new shell, or: source ~/.zshrc)"
else
  echo "  Ctrl+F is bound to something else — left alone"
fi
