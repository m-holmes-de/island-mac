island_catch_errors() {
  local exit_code=$?
  echo -e "\n\e[31m✗ Island installation failed!\e[0m"
  echo -e "  Check the log: $ISLAND_LOG_FILE"
  exit $exit_code
}
trap island_catch_errors ERR
