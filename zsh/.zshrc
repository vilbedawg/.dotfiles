autoload -U colors && colors
bindkey -e

export ACCENT_COLOR="#ffdd33"
PS1="%{%F{$ACCENT_COLOR}%}%~%{$fg[red]%} %{$reset_color%}$%b "

# Maximum lines kept in memory
export HISTSIZE=100000
# Maximum lines saved to $HISTFILE
export SAVEHIST=100000
setopt HIST_IGNORE_ALL_DUPS     # Delete an old recorded event if a new event is a duplicate.
setopt SHARE_HISTORY            # Share history between all sessions.
setopt HIST_FIND_NO_DUPS        # Dont show dupes on search.
export HISTIGNORE='exit:cd:ls:bg:fg:history:f:fd:vim'

export EDITOR="nvim"
export MANPAGER="nvim +Man!"

source <(fzf --zsh)

# Basic auto/tab complete:
autoload -U compinit
compinit -C
zstyle ':completion:*' menu select
zmodload zsh/complist
bindkey '^[[Z' reverse-menu-complete
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

_comp_options+=(globdots)		# Include hidden files.

# edit command line
autoload edit-command-line
zle -N edit-command-line
bindkey '^Xe' edit-command-line

lazy_nvm() 
{
    unset -f nvm node npm npx
    export NVM_DIR="$HOME/.nvm"
    [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
    [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion
}

nvm()
{
  lazy_nvm
  nvm $@
}

node()
{
  lazy_nvm
  node $@
}

npm()
{
  lazy_nvm
  npm $@
}

npx()
{
  lazy_nvm
  npx $@
}

alias src="source ~/.zshrc"
alias vi="nvim"
alias vim="nvim"

export DOTNET_ROOT=/usr/local/share/dotnet
export HOMEBREW_PREFIX=/opt/homebrew

# PATH
path=(
  "$HOME/.local/bin"
  $path
  "$DOTNET_ROOT"
  "$DOTNET_ROOT/tools"
)
typeset -U path PATH

# Load plugins; these should be last
source "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
source "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "$HOMEBREW_PREFIX/share/zsh-history-substring-search/zsh-history-substring-search.zsh"
