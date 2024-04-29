#!/usr/bin/env bash
#
# Automated System Setup Script
# to run, execute:
# 1. sh firstsetup.sh
#
# Author: Saptarshi Chakrabarti
#
# Description: This script automates the setup process for after a fresh Linux installation is done.
# It updates and upgrades the system, installs necessary packages, downloads fonts for the terminal,
# sets up the Zsh shell, and reboots the system.
#
# Update and upgrade the system (assuming 'y' for update)
sudo apt update -y
sudo apt upgrade -y
#
# Install necessary packages, including zsh for OhMyZsh+PowerLevel10k
sudo apt install -y git curl wget nala zsh
#
# Download JetBrains Mono font
echo "Downloading Pro Font..."
wget -q 'https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/ProFont.zip' -O ProFont.zip
#
# Create directories for fonts
mkdir -p ~/.fonts
#
# Extract and install fonts
echo "Installing fonts..."
unzip -q ProFont.zip -d ~/.fonts
#
# Clean up downloaded font archive
rm ProFont.zip
#
# Change the default shell to Zsh (using full path)
echo "Changing default shell to Zsh..."
sudo chsh -s /usr/bin/zsh $(whoami)
#
# Prompt to reboot the system - required for switching shell to Zsh
read -p "Setup complete. Do you want to reboot now? (y/n): " choice
case "$choice" in
  y|Y )
    sudo reboot now
    ;;
  n|N )
    echo "You chose not to reboot. Please reboot your system manually."
    ;;
  * )
    echo "Invalid choice. Please reboot your system manually."
    ;;
esac
