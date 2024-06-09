#!/usr/bin/env bash
#
# Automated System Setup Script
# to run, execute: sh powerlevel10k_anacondainstall.sh
#
# Author: Saptarshi Chakrabarti
#
# Description: This script sets up PowerLevel10k and installs Anaconda.
# Need to run post_install_setup.sh first to have Zsh and PowerFonts installed.

# Install OhMyZsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install PowerLevel10k
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

# Comment out existing ZSH_THEME line in .zshrc
sed -i 's/^ZSH_THEME=/##&/' ~/.zshrc

# Insert new ZSH_THEME line below the existing (now commented out) ZSH_THEME line
sed -i '/^##ZSH_THEME=/a ZSH_THEME="powerlevel10k/powerlevel10k"' ~/.zshrc

# Configure Zsh theme in .zshrc
# echo 'ZSH_THEME="powerlevel10k/powerlevel10k"' >> ~/.zshrc

# Source the updated .zshrc to apply changes
source ~/.zshrc

# Inform the user to restart the terminal
echo "Please close and reopen your terminal to apply the changes."

# Download and run Anaconda installer
wget https://repo.anaconda.com/archive/Anaconda3-2024.02-1-Linux-x86_64.sh -O ~/Anaconda3-2024.02-1-Linux-x86_64.sh
sh ~/Anaconda3-2024.02-1-Linux-x86_64.sh

echo "System setup complete. To set up the MiniHack environment, run: sh setup_minihack.sh"
