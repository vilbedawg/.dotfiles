export ZSH="$HOME/.oh-my-zsh"

plugins=(
    git 
    zsh-autosuggestions 
    zsh-syntax-highlighting 
    zsh-completions
)

source $ZSH/oh-my-zsh.sh

autoload -U promptinit; promptinit
PURE_CMD_MAX_EXEC_TIME=10
zstyle :prompt:pure:path color white
zstyle :prompt:pure:git:stash show yes
prompt pure

# Basic auto/tab complete:
autoload -U compinit && compinit
zmodload zsh/complist

_comp_options+=(globdots)		# Include hidden files.


# Aliases
alias vi="nvim"
alias vim="nvim"
alias view="nvim -R"
alias vimdiff="nvim -d"
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export DOTNET_ROOT=$HOME/.dotnet
export PATH=$PATH:$DOTNET_ROOT:$DOTNET_ROOT/tools
export PATH="/home/linuxbrew/.linuxbrew/sbin:$PATH"
export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"

[ -f "/home/vilho/.ghcup/env" ] && source "/home/vilho/.ghcup/env" # ghcup-env
