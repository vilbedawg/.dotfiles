autoload -U colors && colors
bindkey -e

PS1="%{$fg[magenta]%}%~%{$fg[red]%} %{$reset_color%}$%b "

# Maximum lines kept in memory
export HISTSIZE=100000
# Maximum lines saved to $HISTFILE
export SAVEHIST=100000
setopt HIST_IGNORE_ALL_DUPS     # Delete an old recorded event if a new event is a duplicate.
setopt SHARE_HISTORY            # Share history between all sessions.
setopt HIST_FIND_NO_DUPS        # Dont show dupes on search.
export HISTIGNORE='exit:cd:ls:bg:fg:history:f:fd:vim'

source <(fzf --zsh)

# Basic auto/tab complete:
autoload -U compinit && compinit
autoload -U colors && colors
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
    [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
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

export DOTNET_ROOT=$HOME/.dotnet
export PATH=$PATH:$DOTNET_ROOT:$DOTNET_ROOT/tools

# Load plugins; these should be last
export HOMEBREW_PREFIX=/opt/homebrew
source $HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $HOMEBREW_PREFIX/share/zsh-history-substring-search/zsh-history-substring-search.zsh
