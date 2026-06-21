start_install_log() {
  : > "$ISLAND_LOG_FILE"
  echo "=== Island (macOS) Installation Started: $(date) ===" >> "$ISLAND_LOG_FILE"
}

run_logged() {
  local script="$1"
  local name
  name=$(basename "$script")
  echo -e "  \e[90m$name\e[0m"
  echo "[$(date '+%H:%M:%S')] Running: $script" >> "$ISLAND_LOG_FILE"
  if ! bash "$script" >> "$ISLAND_LOG_FILE" 2>&1; then
    echo -e "  \e[31m✗ $name failed\e[0m"
    echo "[$(date '+%H:%M:%S')] FAILED: $script" >> "$ISLAND_LOG_FILE"
    return 1
  fi
  echo "[$(date '+%H:%M:%S')] Done: $script" >> "$ISLAND_LOG_FILE"
}
