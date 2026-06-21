# Island-mac ZSH Configuration
# Maintained in the island-mac repo (default/.zshrc). Edit it there and ship a
# migration to update deployed copies — don't edit ~/.zshrc directly.

###########################
# PATH / ENV              #
###########################

# Homebrew (guarded — usually also set via /etc/paths.d/homebrew)
[[ -x /opt/homebrew/bin/brew ]] && eval "$(/opt/homebrew/bin/brew shellenv)"

export PATH="$HOME/.local/bin:$PATH"

# island-mac commands
export ISLAND_PATH="$HOME/.local/share/island-mac"
export PATH="$ISLAND_PATH/bin:$PATH"

export EDITOR=nvim
export DISABLE_AUTOUPDATER=1

###########################
# YAZI FILE MANAGER       #
###########################

# `y` opens yazi and cd's to the directory you quit in
function y() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
  yazi "$@" --cwd-file="$tmp"
  IFS= read -r -d '' cwd < "$tmp"
  [ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
  rm -f -- "$tmp"
}

###########################
# ZINIT (plugin manager)  #
###########################

ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [ ! -d "$ZINIT_HOME" ]; then
  mkdir -p "$(dirname "$ZINIT_HOME")"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi
source "${ZINIT_HOME}/zinit.zsh"

zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

zinit snippet OMZP::git
zinit snippet OMZP::sudo

autoload -Uz compinit && compinit
zinit cdreplay -q

###########################
# VIM MODE                #
###########################

bindkey -v
export KEYTIMEOUT=1
autoload edit-command-line
zle -N edit-command-line
bindkey -M vicmd v edit-command-line

bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey '^y' autosuggest-accept
bindkey '^[w' kill-region
# Ctrl+F -> tmux-sessionizer (provide your own script on PATH)
bindkey -s ^f "tmux-sessionizer\n"

# History
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory sharehistory hist_ignore_space hist_ignore_all_dups
setopt hist_save_no_dups hist_ignore_dups hist_find_no_dups

###########################
# FZF                     #
###########################

export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border"
bindkey '^R' fzf-history-widget

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza --color=always --icons $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'eza --color=always --icons $realpath'

command -v fzf >/dev/null && eval "$(fzf --zsh)"

###########################
# CURSOR SHAPE            #
###########################

function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] || [[ $1 = 'block' ]]; then
    echo -ne '\e[2 q'
  elif [[ ${KEYMAP} == main ]] || [[ ${KEYMAP} == viins ]] || [[ ${KEYMAP} = '' ]] || [[ $1 = 'beam' ]]; then
    echo -ne '\e[5 q'
  fi
}
zle-line-init() { echo -ne '\e[5 q'; }
zle -N zle-keymap-select
zle -N zle-line-init

###########################
# PROMPT                  #
###########################

command -v starship >/dev/null && eval "$(starship init zsh)"

# Mise (dev tool manager), if installed
command -v mise >/dev/null && eval "$(mise activate zsh)"

###########################
# ALIASES                 #
###########################

alias vim='nvim'
alias c='clear'
alias ls='eza --color=always --icons --long'
alias ll='eza --color=always --icons --long --all'
alias tree='eza --color=always --icons --long --all --tree --level=3'
alias lg='lazygit'
alias cat='bat'
alias ff='find ./ | fzf'

# island-mac helpers
alias theme='island-theme-select'

###########################
# ZOXIDE (must be last)   #
###########################

command -v zoxide >/dev/null && eval "$(zoxide init zsh)"
