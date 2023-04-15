#!/bin/bash

DOTFILES_DIR="$HOME/.dotfiles"
ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"
OS=$(uname -s)

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}========================================="
echo "Starting Dotfiles Installation"
echo -e "=========================================${NC}"

if [ $OS == "Darwin" ]
then
    # Install Xcode command line tools
    echo -e "${GREEN}Installing Xcode Command Line Tools...${NC}"
    xcode-select --install

    # Check if Homebrew is installed
    if ! command -v brew &> /dev/null
    then

        echo -e "${RED}Homebrew is not installed.${NC}"
        echo -e "${GREEN}Would you like to install it? (y/n) ${NC}"
        read -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]
        then
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
            echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
            eval "$(/opt/homebrew/bin/brew shellenv)"
        else
            echo -e "${RED}Please install Homebrew and try again.${NC}"
            exit
        fi
    fi 

    # Install dependencies with Homebrew
    echo -e "${GREEN}Installing dependencies with Homebrew...${NC}"
    brew update && brew install zsh tmux ripgrep fd gnu-sed neovim fzf node

else
    cd $HOME

    # Install dependencies with apt-get
    echo -e "${GREEN}Installing dependencies with apt-get...${NC}"
    sudo apt-get update && sudo apt-get install -y zsh tmux alacritty ripgrep fd-find build-essential neovim tmux curl fzf

    # Download the latest stable release of Neovim as an AppImage
    curl -LO https://github.com/neovim/neovim/releases/download/stable/nvim.appimage
    chmod u+x $HOME/nvim.appimage
    ln -s $HOME/nvim.appimage $HOME/.local/bin/nvim

    echo -e "${GREEN}Installing npm...${NC}"
    curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
    sudo apt-get install -y nodejs

    cd $HOME/.dotfiles
fi


# Install treesitter-cli with npm
if npm list -g | grep 'tree-sitter-cli'; then
    echo -e "${YELLOW}treesitter-cli is already installed.${NC}"
else
    echo -e "${GREEN}treesitter-cli is not installed. Installing now...${NC}"
    npm install -g tree-sitter-cli
fi

# Create symbolic links for config files
echo -e "${GREEN}Creating symlinks for config files...${NC}"
ln -sf $DOTFILES_DIR/.zshrc $HOME/.zshrc
ln -sf $DOTFILES_DIR/.tmux.conf $HOME/.tmux.conf
ln -sf $DOTFILES_DIR/.config/nvim $HOME/.config/nvim
ln -sf $DOTFILES_DIR/.config/alacritty/alacritty.yml $HOME/.config/alacritty/alacritty.yml


# Check if zsh is default shell
if [ "$(ps -p $$ -o comm=)" != "zsh" ]; then
    exec zsh
    echo -e "${GREEN}Changed default shell to zsh.${NC}"
fi

# Check if Oh My Zsh is already installed
if [ -d "$HOME/.oh-my-zsh" ]; then
    echo -e "${YELLOW}Oh My Zsh is already installed.${NC}"
else
    # Install Oh My Zsh
    echo -e "${GREEN}Installing ohmyzsh...${NC}"
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# Install powerlevel10k
if [ -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then
    echo -e "${YELLOW}powerlevel10k is already installed.${NC}"
else
    echo -e "${GREEN}Installing powerlevel10k...${NC}"
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
fi

# Install ZSH plugins
if [ -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
    echo -e "${YELLOW}zsh-autosuggestions is already installed.${NC}"
else
    echo -e "${GREEN}Installing zsh-autosuggestions...${NC}"
    git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions
fi

if [ -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
    echo -e "${YELLOW}zsh-syntax-highlighting is already installed.${NC}"
else
    echo -e "${GREEN}Installing zsh-syntax-highlighting...${NC}"
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
fi

if [ -d "$ZSH_CUSTOM/plugins/zsh-completions" ]; then
    echo -e "${YELLOW}zsh-completions is already installed.${NC}"
else
    echo -e "${GREEN}Installing zsh-completions...${NC}"
    git clone https://github.com/zsh-users/zsh-completions.git $ZSH_CUSTOM/plugins/zsh-completions
fi


echo -e "${GREEN}========================================="
echo "Dotfiles installed and configured."
echo -e "=========================================${NC}"

