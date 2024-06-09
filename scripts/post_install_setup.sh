#!/usr/bin/env bash
#
# Post-Installation Setup Script
# to run, execute: sh post_install_setup.sh
#
# Author: Saptarshi Chakrabarti
#
# Description: This script automates the post-installation setup process for a fresh Linux installation.
# It updates and upgrades the system, installs necessary packages, downloads and installs fonts for the terminal,
# sets up the Zsh shell, installs the Starship prompt, and prompts for a system reboot.
#

# Log file
LOGFILE=~/post_install_setup.log
exec > >(tee -a $LOGFILE) 2>&1

# Function to check the success of each command
check_success() {
  if [ $? -ne 0 ]; then
    echo "Error: $1 failed to execute."
    exit 1
  fi
}

# Ensure the script is running on a Debian-based system
if ! [ -x "$(command -v apt)" ]; then
  echo "Error: This script is intended for Debian-based systems using apt package manager."
  exit 1
fi

# Update and upgrade the system (assuming 'y' for update)
echo "Updating and upgrading the system..."
sudo apt update -y && sudo apt upgrade -y
check_success "System update and upgrade"

# Install necessary packages, including zsh for OhMyZsh+PowerLevel10k
echo "Installing necessary packages..."
sudo apt install -y git curl wget cmake zsh unzip
check_success "Package installation"

# Download ProFont font
echo "Downloading Pro Font..."
wget -q 'https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/ProFont.zip' -O ProFont.zip
check_success "Pro Font download"

# Download JetBrains Mono font
echo "Downloading JetBrains Mono Font..."
wget -q 'https://download.jetbrains.com/fonts/JetBrainsMono-2.304.zip' -O JetBrainsMono.zip
check_success "JetBrains Mono Font download"

# Create directories for fonts
echo "Creating font directories..."
mkdir -p ~/.fonts
check_success "Font directory creation"

# Extract and install ProFont
echo "Installing Pro Font..."
unzip -q ProFont.zip -d ~/.fonts
check_success "Pro Font installation"

# Extract and install JetBrains Mono font
echo "Installing JetBrains Mono Font..."
unzip -q JetBrainsMono.zip -d ~/.fonts
check_success "JetBrains Mono Font installation"

# Clean up downloaded font archives
echo "Cleaning up downloaded font archives..."
rm ProFont.zip JetBrainsMono.zip
check_success "Font archive cleanup"

# Change the default shell to Zsh (using full path)
echo "Changing default shell to Zsh..."
sudo chsh -s /usr/bin/zsh $(whoami)
check_success "Default shell change to Zsh"

# Install Starship prompt
echo "Installing Starship prompt..."
curl -sS https://starship.rs/install.sh | sh
check_success "Starship installation"

# Add Starship initialization to ~/.zshrc
echo "Adding Starship initialization to ~/.zshrc..."
echo 'eval "$(starship init zsh)"' >> ~/.zshrc
check_success "Adding Starship to .zshrc"

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
