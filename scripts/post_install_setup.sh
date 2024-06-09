#!/usr/bin/env bash
#
# Post-Installation Setup Script
# to run, execute: sh post_install_setup.sh
#
# Author: Saptarshi Chakrabarti
#
# Description: This script automates the post-installation setup process for a fresh Linux installation.
# It updates and upgrades the system, installs necessary packages, downloads and installs fonts for the terminal,
# sets up the Zsh shell, installs the Starship prompt, applies a Starship theme, and prompts for additional software installations and a system reboot.
#

# Log file
LOGFILE=~/post_install_setup.log
touch $LOGFILE

# Function to check the success of each command
check_success() {
  if [ $? -ne 0 ]; then
    echo "Error: $1 failed to execute." | tee -a $LOGFILE
    exit 1
  fi
}

# Ensure the script is running on a Debian-based system
if ! [ -x "$(command -v apt)" ]; then
  echo "Error: This script is intended for Debian-based systems using apt package manager." | tee -a $LOGFILE
  exit 1
fi

# Update and upgrade the system (assuming 'y' for update)
echo "Updating and upgrading the system..." | tee -a $LOGFILE
sudo apt update -y && sudo apt upgrade -y | tee -a $LOGFILE
check_success "System update and upgrade"

# Install necessary packages, including zsh
echo "Installing necessary packages..." | tee -a $LOGFILE
sudo apt install -y git curl wget cmake zsh unzip ffmpeg libfuse2t64 | tee -a $LOGFILE
check_success "Package installation"

# Download ProFont font
echo "Downloading Pro Font..." | tee -a $LOGFILE
wget -q 'https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/ProFont.zip' -O ProFont.zip
check_success "Pro Font download"

# Download JetBrains Mono font
echo "Downloading JetBrains Mono Font..." | tee -a $LOGFILE
wget -q 'https://download.jetbrains.com/fonts/JetBrainsMono-2.304.zip' -O JetBrainsMono.zip
check_success "JetBrains Mono Font download"

# Create directories for fonts
echo "Creating font directories..." | tee -a $LOGFILE
mkdir -p ~/.fonts
check_success "Font directory creation"

# Extract and install ProFont
echo "Installing Pro Font..." | tee -a $LOGFILE
unzip -q ProFont.zip -d ~/.fonts
check_success "Pro Font installation"

# Extract and install JetBrains Mono font
echo "Installing JetBrains Mono Font..." | tee -a $LOGFILE
unzip -q JetBrainsMono.zip -d ~/.fonts
check_success "JetBrains Mono Font installation"

# Clean up downloaded font archives
echo "Cleaning up downloaded font archives..." | tee -a $LOGFILE
rm ProFont.zip JetBrainsMono.zip
check_success "Font archive cleanup"

# Change the default shell to Zsh (using full path)
echo "Changing default shell to Zsh..." | tee -a $LOGFILE
sudo chsh -s /usr/bin/zsh $(whoami)
check_success "Default shell change to Zsh"

# Install Starship prompt
echo "Installing Starship prompt..." | tee -a $LOGFILE
curl -sS https://starship.rs/install.sh | sh | tee -a $LOGFILE
check_success "Starship installation"

# Add Starship initialization to ~/.zshrc
echo "Adding Starship initialization to ~/.zshrc..." | tee -a $LOGFILE
echo 'eval "$(starship init zsh)"' >> ~/.zshrc
check_success "Adding Starship to .zshrc"

# Prompt user to choose a Starship theme
echo "Choose a Starship theme to install:"
echo "1. Pastel Powerline"
echo "2. Gruvbox Rainbow"
read -p "Enter the number corresponding to your choice (1 or 2): " theme_choice

case "$theme_choice" in
  1 )
    echo "Applying Pastel Powerline theme..." | tee -a $LOGFILE
    mkdir -p ~/.config
    starship preset pastel-powerline -o ~/.config/starship.toml
    check_success "Applying pastel-powerline theme"
    ;;
  2 )
    echo "Applying Gruvbox Rainbow theme..." | tee -a $LOGFILE
    mkdir -p ~/.config
    starship preset gruvbox-rainbow -o ~/.config/starship.toml
    check_success "Applying gruvbox-rainbow theme"
    ;;
  * )
    echo "Invalid choice. No theme applied." | tee -a $LOGFILE
    ;;
esac

# Prompt user to choose whether to install VLC
read -p "Do you want to install VLC? (y/n): " vlc_choice
case "$vlc_choice" in
  y|Y )
    echo "Installing VLC..." | tee -a $LOGFILE
    sudo apt install -y vlc | tee -a $LOGFILE
    check_success "VLC installation"
    ;;
  n|N )
    echo "You chose not to install VLC." | tee -a $LOGFILE
    ;;
  * )
    echo "Invalid choice. VLC not installed." | tee -a $LOGFILE
    ;;
esac

# Prompt user to choose whether to install LibreOffice
read -p "Do you want to install LibreOffice? (y/n): " libreoffice_choice
case "$libreoffice_choice" in
  y|Y )
    echo "Installing LibreOffice..." | tee -a $LOGFILE
    sudo apt install -y libreoffice | tee -a $LOGFILE
    check_success "LibreOffice installation"
    ;;
  n|N )
    echo "You chose not to install LibreOffice." | tee -a $LOGFILE
    ;;
  * )
    echo "Invalid choice. LibreOffice not installed." | tee -a $LOGFILE
    ;;
esac

# Prompt to reboot the system - required for switching shell to Zsh
read -p "Setup complete. Do you want to reboot now? (y/n): " choice
case "$choice" in
  y|Y )
    sudo reboot now
    ;;
  n|N )
    echo "You chose not to reboot. Please reboot your system manually." | tee -a $LOGFILE
    ;;
  * )
    echo "Invalid choice. Please reboot your system manually." | tee -a $LOGFILE
    ;;
esac
