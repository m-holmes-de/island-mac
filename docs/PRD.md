# island-mac — PRD / Roadmap

Product-level direction and open decisions for island-mac, beyond what the code and
`CLAUDE.md` already document. Keep it short: current direction + things under
consideration.

## Current direction

- **tuios is the primary terminal window manager for AI coding agents.** Integrated
  alongside herdr, themed by `island-theme-set`, launched via `island-ai-tuios` and
  **Ctrl+F** (`island-tuios-sessionizer`). Pane focus/splits are prefix-driven
  (Ctrl+Space); bare `h/j/k/l` are intentionally *not* bound (they'd steal typing on
  tuios 0.12.1).
- **herdr and tmux are demoted, not removed.** Their standalone tools remain on disk
  but are unbound from any key/flow. The active hooks (`island-ai` agent-rename,
  `island-theme-set` tmux/herdr theming) are commented out behind `[tuios-primary]`
  markers for an easy revert. `config/tmux/tmux.conf` is left dormant (its hooks fire
  only if tmux is started).

## Under consideration

### Move config management to chezmoi

Today configs ship via `install.sh` (rsync to `~/.local/share/island-mac`) plus a
migration system that evolves `~/.config` in place. It works, but **most island configs
are fully repo-owned**, so their migrations just force-`cp` the whole file — paying the
migration tax (timestamps, applied-state markers, deployed-copy indirection,
`config/`-and-migration double-bookkeeping) without the benefit it's meant to buy
(non-clobbering surgical edits). Friction observed in practice: manual `rsync` +
`island-migrate` to apply, state markers that silently skip a *rewritten* migration,
and config path/drift bugs introduced by the deployed-copy layer (e.g. tuios reads
`~/Library/Application Support/tuios`, not `~/.config`).

**Proposal:** adopt [chezmoi](https://chezmoi.io), or — lighter — symlink the
repo-owned configs straight to their targets and keep migrations only for genuinely
hand-edited files (`.zshrc`, hand-tweaked ghostty).

- **Why chezmoi:** the repo becomes the single source of truth; `chezmoi diff` /
  `chezmoi apply --dry-run` show exactly what will change before it does; deterministic
  file permissions; first-class secret handling (age/GPG, password-manager
  integration). Could retire `install.sh`, the migration runner, and the rsync step.
- **Security:** sound. Runs as the user (no sudo — fits the no-root rule), single static
  Go binary from Homebrew, no daemon or ambient network. `chezmoi apply` *does* execute
  `run_` scripts / template functions — but that's the same trust model as today's
  `install.sh` running bash, now with reviewable diffs on top. For this public,
  secret-free repo the risk profile is unchanged ("never commit secrets"), and
  chezmoi's encryption makes that easier to uphold.
- **Keep:** the migration path's no-clobber safety is still worth it for a fresh public
  install; the win here is mainly the local iteration loop.
- **Next step:** proof-of-concept branch migrating just the tuios + ghostty configs to
  chezmoi, to compare the diff before committing to a full move.
