#!/usr/bin/env bash
#
# Automated System Setup Script
# to run, execute: sh secondexecute.sh
#
# Author: Saptarshi Chakrabarti
#
# Description: This script automates the setup process for after a fresh Linux installation is done.
# It updates and upgrades the system, installs necessary packages, downloads fonts for the terminal,
# sets up the Zsh shell, and reboots the system.

# Install OhMyZsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install PowerLevel10k
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

# Comment out existing ZSH_THEME line in .zshrc
sed -i 's/^ZSH_THEME=/##&/' ~/.zshrc

# Configure Zsh theme in .zshrc
echo 'ZSH_THEME="powerlevel10k/powerlevel10k"' >> ~/.zshrc

# Download and run Anaconda installer
wget https://repo.anaconda.com/archive/Anaconda3-2024.02-1-Linux-x86_64.sh -O ~/Anaconda3-2024.02-1-Linux-x86_64.sh
sh ~/Anaconda3-2024.02-1-Linux-x86_64.sh

echo "System setup complete. To set up the MiniHack environment, run: sh setup_minihack.sh"
