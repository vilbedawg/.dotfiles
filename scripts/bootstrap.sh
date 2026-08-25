#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

link() {
  local src="$1" dest="$2"
  mkdir -p "$(dirname "$dest")"
  if [ -e "$dest" ] && [ ! -L "$dest" ]; then
    echo "skip: $dest exists and is not a symlink"
    return
  fi
  ln -sfn "$src" "$dest"
  echo "linked: $dest -> $src"
}

link "$DOTFILES/zsh/.zshrc" "$HOME/.zshrc"
link "$DOTFILES/nvim" "$HOME/.config/nvim"
link "$DOTFILES/alacritty/alacritty.toml" "$HOME/.config/alacritty/alacritty.toml"
link "$DOTFILES/tmux/tmux.conf" "$HOME/.config/tmux/tmux.conf"
link "$DOTFILES/aerospace/aerospace.toml" "$HOME/.config/aerospace/aerospace.toml"
link "$DOTFILES/ripgrep/.ripgreprc" "$HOME/.ripgreprc"

if [ -x "$(command -v brew)" ]; then
  brew bundle install --file="$DOTFILES/homebrew/Brewfile"
else
  echo "Homebrew not found — install it first: https://brew.sh"
fi
