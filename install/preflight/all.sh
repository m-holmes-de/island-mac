island_step "Preflight checks"
source "$ISLAND_INSTALL/preflight/guard.sh"
run_logged "$ISLAND_INSTALL/preflight/homebrew.sh"
