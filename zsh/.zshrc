autoload -U colors && colors
bindkey -e

export ACCENT_COLOR="magenta"
PS1="%F{$ACCENT_COLOR}%~%f \$ "

export HOMEBREW_PREFIX=/opt/homebrew
export DOTNET_ROOT=/usr/local/share/dotnet

# PATH
path=(
  "$HOME/.local/bin"
  $path
  "$HOMEBREW_PREFIX/opt/libpq/bin"
  "$DOTNET_ROOT"
  "$DOTNET_ROOT/tools")
typeset -U path PATH

# History
export HISTFILE="$HOME/.zsh_history"
# Maximum lines kept in memory
export HISTSIZE=100000
# Maximum lines saved to $HISTFILE
export SAVEHIST=100000
setopt HIST_IGNORE_ALL_DUPS     # Delete an old recorded event if a new event is a duplicate.
setopt SHARE_HISTORY            # Share history between all sessions (implies INC_APPEND_HISTORY + EXTENDED_HISTORY).
setopt HIST_FIND_NO_DUPS        # Dont show dupes on search.
setopt HIST_IGNORE_SPACE        # Don't record commands starting with a space.
setopt HIST_REDUCE_BLANKS       # Strip superfluous blanks.
HISTORY_IGNORE='(exit|cd|ls|bg|fg|history|f|fd|vim|nvim|vi)'

setopt INTERACTIVE_COMMENTS

export EDITOR="nvim"
export MANPAGER="nvim +Man!"

export FZF_CTRL_T_COMMAND='rg --files --hidden --glob "!.git" --sort=path'
source <(fzf --zsh)

# Docker CLI completions (must be on fpath before compinit)
fpath=("$HOME/.docker/completions" $fpath)

# Full compinit at most once a day, otherwise trust the cached dump
autoload -Uz compinit
_zcompdump="${ZDOTDIR:-$HOME}/.zcompdump"
# Globs don't expand inside [[ ]], so expand the staleness check into an array
_zcompdump_stale=( $_zcompdump(N.mh+24) )
if (( $#_zcompdump_stale )); then
  compinit -d "$_zcompdump"
else
  compinit -C -d "$_zcompdump"
fi
unset _zcompdump _zcompdump_stale

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'l:|=* r:|=*'
zstyle ':completion:*' use-cache yes
zmodload zsh/complist
bindkey '^[[Z' reverse-menu-complete
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

_comp_options+=(globdots)

# edit command line
autoload edit-command-line
zle -N edit-command-line
bindkey '^Xe' edit-command-line

# Lazy-load nvm on first use of any of its commands
_lazy_nvm() {
  unset -f nvm node npm npx
  export NVM_DIR="$HOME/.nvm"
  [ -s "$HOMEBREW_PREFIX/opt/nvm/nvm.sh" ] && \. "$HOMEBREW_PREFIX/opt/nvm/nvm.sh"
  [ -s "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm" ] && \. "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm"
}
for _cmd in nvm node npm npx; do
  eval "$_cmd() { _lazy_nvm; $_cmd \"\$@\" }"
done
unset _cmd

alias src="source ~/.zshrc"
alias vi="nvim"
alias vim="nvim"

alias bs="$HOME/.dotfiles/scripts/brew-search.sh"

# Load plugins; these should be last
source "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
source "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "$HOMEBREW_PREFIX/share/zsh-history-substring-search/zsh-history-substring-search.zsh"
