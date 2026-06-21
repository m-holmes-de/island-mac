# Refuse to run on anything but macOS
if [[ "$(uname -s)" != "Darwin" ]]; then
  echo -e "\e[31mIsland-mac only runs on macOS. Detected: $(uname -s)\e[0m"
  echo "  For Linux, use the 'island' repo instead."
  exit 1
fi
