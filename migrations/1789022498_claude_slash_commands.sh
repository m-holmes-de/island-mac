echo "claude: install the shared slash commands into ~/.claude/commands"

# The Web Agent's baked-in prompt library (its lightning menu) as Claude Code
# commands, so the same prompts are one '/' away in any terminal session.
# cp -n: a command you have since edited by hand is never overwritten.

ISLAND_PATH="${ISLAND_PATH:-$HOME/.local/share/island-mac}"
SRC="$ISLAND_PATH/claude/commands"
DEST="$HOME/.claude/commands"

[[ -d "$SRC" ]] || exit 0
mkdir -p "$DEST"

added=0
for file in "$SRC"/*.md; do
  [[ -f "$file" ]] || continue
  if [[ ! -f "$DEST/$(basename "$file")" ]]; then
    cp -n "$file" "$DEST/"
    added=$((added + 1))
  fi
done

if (( added > 0 )); then
  echo "  Installed $added command(s) — type / in Claude Code to see them"
else
  echo "  Commands already present"
fi
