# Style

- Two spaces for indentation, no tabs
- Use bash conditionals: `[[ ]]` for string/file tests, `(( ))` for numeric
- Shebangs must use `#!/bin/bash`
- Scripts under `install/` and `migrations/` may omit shebangs (they are sourced / run via bash)
- Quote variables in double quotes except inside `[[ ]]`
- Use `set -eEo pipefail` in entry-point scripts

# Command Naming

All commands start with `island-`. Prefixes indicate purpose:

- `pkg-` - package management helpers (Homebrew)
- `config-` - deploy / refresh config files

# Packaging — Homebrew

- The `Brewfile` is the single source of truth for installed packages.
- `brew "<name>"` for a CLI tool (formula); `cask "<name>"` for a GUI app.
- NEVER run Homebrew with `sudo` — it refuses and can corrupt the prefix.
- `brew bundle` is idempotent; safe to re-run.
- Casks moving apps into `/Applications` may prompt for a password and so cannot be
  installed non-interactively.

# Config Files

- `config/` - default configs, copied to `~/.config/` with `cp -n` (no overwrite)
- `default/` - home-directory dotfiles, copied to `$HOME` with `cp -n` (e.g. `.zshrc`)
- `default/.zshrc` is **repo-managed**: it is the source of truth and puts
  `$ISLAND_PATH/bin` on PATH. To change it, edit `default/.zshrc` and ship a
  migration that copies it over `~/.zshrc` (the migration backs up a pre-existing
  non-island-mac `~/.zshrc` to `~/.zshrc.pre-island-mac` once).
- Use each app's native config format (e.g. Ghostty's `config` key=value format)
- One concern per file where a tool's config is modular

# Migrations — MANDATORY for config changes

**Every change to deployed user configs MUST be done via a migration.**

`config/` is only for new installs (copied once with `cp -n`). Once configs are
deployed to `~/.config/`, the ONLY way to update them is a migration. This protects
user customizations.

When changing a config:
1. Update the default in `config/` (for new installs)
2. Create a migration in `migrations/` (for existing installs)
3. The migration must be idempotent (check before modifying)

Migration rules:
- Filename: `<unix-timestamp>_description.sh`
- No shebang (run via `bash "$file"`)
- Start with `echo` describing what the migration does
- State tracked in `~/.local/state/island-mac/migrations/`
- Must be idempotent: use `grep -q` before `sed`, check contents before replacing

Example — patching a line in a config:
```bash
echo "Ghostty: keep Option as a compose key so Option+L types @"
ISLAND_PATH="${ISLAND_PATH:-$HOME/.local/share/island-mac}"
CFG="$HOME/.config/ghostty/config"
if [[ -f "$CFG" ]] && ! grep -q '^macos-option-as-alt' "$CFG"; then
  echo 'macos-option-as-alt = false' >> "$CFG"
fi
```

Example — replacing a whole config file intentionally:
```bash
echo "Reset ghostty config to island-mac default"
ISLAND_PATH="${ISLAND_PATH:-$HOME/.local/share/island-mac}"
cp "$ISLAND_PATH/config/ghostty/config" ~/.config/ghostty/config
```

# Commit checklist

Before every commit, verify:

1. **Migration required?** If any file under `config/` changed, there MUST be a
   corresponding migration in `migrations/`. No exceptions.
2. **Defaults updated?** If a migration patches a deployed config, the matching file
   in `config/` must also be updated (for fresh installs).
3. **Idempotent?** Run `island-migrate` twice — the second run should no-op.
4. **Syntax check?** `bash -n` on all new/modified shell scripts.
5. **Brewfile updated?** If you added a package, it must be in the `Brewfile`.

# Theming

Targets: ghostty, tmux, neovim, wallpaper (no desktop theming on macOS).

- `themes/<name>/colors.sh` defines `THEME_*` vars (palette + app hooks). Add a new
  theme by adding a `colors.sh` (and optional `wallpapers/`).
- `templates/*.tpl` use `{{THEME_VAR}}` placeholders. `island-theme-set` substitutes
  every `THEME_*` var in scope and renders each template into `~/.config/`.
- Adding a templated app: add `templates/<app>.tpl`, then a `process_template` line in
  `bin/island-theme-set`. Use the existing `THEME_*` vars; don't hard-code hex.
- The ghostty template must always include `macos-option-as-alt = false`.
- Changing a template/palette follows the migration rule: update the template/`colors.sh`
  AND ship a migration (the migration can just re-run `island-theme-set "$current"`).
- yazi is themed statically (not switched), matching island.

# Install Scripts

- `install/*/all.sh` orchestrate each phase
- Leaf scripts are run via `run_logged "$ISLAND_INSTALL/path/to/script.sh"`
- Use `$ISLAND_PATH` and `$ISLAND_INSTALL` instead of hard-coded paths
- Avoid `exit` in sourced install scripts unless intentionally aborting
- No `sudo` anywhere — Homebrew and `~/.config` deployment are user-level
