#!/bin/bash

# Filename: customise_gnome.sh
# Author: Saptarshi Chakrabarti
# Description: This script installs gnome-tweaks and gnome-shell-extensions,
# prompts the user to activate the 'Dash to Panel' extension, installs the Graphite-gtk-theme with colour tweaks,
# installs the Gruvbox Plus icon pack, and optionally installs a bootloader theme.

# Update and upgrade the system
echo "Starting system update and upgrade..."
if ! sudo apt update && sudo apt upgrade -y; then
    echo "Failed to update and upgrade the system."
    exit 1
fi

# Install gnome-tweaks and gnome-shell-extensions
echo "Installing gnome-tweaks and gnome-shell-extensions..."
if ! sudo apt install -y gnome-tweaks gnome-shell-extension-manager; then
    echo "Failed to install gnome-tweaks and gnome-shell-extension-manager."
    exit 1
fi

# Prompt the user to activate 'Dash to Panel' extension manually
echo "Please add and activate the 'Dash to Panel' extension from GNOME Extensions."
read -p "Press Enter to continue once you have done this."

# Clone or check Graphite-gtk-theme repository
echo "Checking if Graphite-gtk-theme repository already exists..."
if [ ! -d "Graphite-gtk-theme" ]; then
    echo "Cloning Graphite-gtk-theme repository..."
    if ! git clone https://github.com/vinceliuice/Graphite-gtk-theme.git; then
        echo "Failed to clone Graphite-gtk-theme repository."
        exit 1
    fi
else
    echo "Graphite-gtk-theme repository already exists."
fi

# Change directory to Graphite-gtk-theme
echo "Changing to Graphite-gtk-theme directory..."
cd Graphite-gtk-theme || { echo "Failed to change directory to Graphite-gtk-theme."; exit 1; }

# Run installation commands for Graphite-gtk-theme with different tweaks
echo "Running installation commands..."
chmod +x install.sh
for tweak in "-t all" "--tweaks rimless" "--tweaks normal" "--tweaks nord" "--tweaks nord darker" "--tweaks darker" "--tweaks black" "--tweaks float colorful nord rimless -t teal" "--tweaks float colorful nord -t teal" "--tweaks float colorful nord rimless -t yellow" "--tweaks float colorful nord -t yellow" "--tweaks float colorful nord rimless -t purple" "--tweaks float colorful nord -t purple" "--tweaks float colorful nord rimless -t green" "--tweaks float colorful nord -t green" "--tweaks float colorful nord rimless -t blue" "--tweaks float colorful nord -t blue"; do
    if ! ./install.sh $tweak; then
        echo "Failed to run ./install.sh $tweak"
        exit 1
    fi
done

# URL of the tar.gz file to download
URL="https://github.com/saptarshichakrabarti/linux-setup-scripts/raw/main/gruvbox-plus-icon-pack.5.4.tar.gz"

# Directory where the script is being run
SCRIPT_DIR=$(pwd)

# Download the file
echo "Downloading $URL..."
if ! wget -q --show-progress "$URL" -P "$SCRIPT_DIR"; then
    echo "Failed to download $URL."
    exit 1
fi

# Extract the contents of the downloaded tar.gz file
echo "Extracting contents..."
if ! tar -xf "$SCRIPT_DIR/gruvbox-plus-icon-pack.5.4.tar.gz" -C "$SCRIPT_DIR"; then
    echo "Failed to extract $SCRIPT_DIR/gruvbox-plus-icon-pack.5.4.tar.gz."
    exit 1
fi

# Find the extracted directory name
EXTRACTED_DIR=$(tar -tf "$SCRIPT_DIR/gruvbox-plus-icon-pack.5.4.tar.gz" | head -n 1 | cut -d '/' -f 1)

if [ -z "$EXTRACTED_DIR" ]; then
    echo "Failed to determine extracted directory name."
    exit 1
fi

# Create .icons folder in the home directory if it doesn't exist
ICONS_DIR="$HOME/.icons"
mkdir -p "$ICONS_DIR"

# Move extracted contents to ~/.icons folder
echo "Moving files to $ICONS_DIR..."
if ! mv "$SCRIPT_DIR/$EXTRACTED_DIR"/* "$ICONS_DIR"; then
    echo "Failed to move files to $ICONS_DIR."
    exit 1
fi

# Clean up - remove the downloaded tar.gz file
echo "Cleaning up..."
if ! rm "$SCRIPT_DIR/gruvbox-plus-icon-pack.5.4.tar.gz"; then
    echo "Failed to remove $SCRIPT_DIR/gruvbox-plus-icon-pack.5.4.tar.gz."
    exit 1
fi

echo "Gruvbox Plus icon pack installation complete."

# Prompt to install bootloader theme
read -p "Do you want to install the bootloader theme? (yes/no): " install_bootloader
if [[ "$install_bootloader" == "yes" ]]; then
    if [ -d "other/grub2" ]; then
        echo "Installing bootloader theme..."
        cd other/grub2 || { echo "Failed to change directory to other/grub2."; exit 1; }
        if ! sudo ./install.sh; then
            echo "Failed to install bootloader theme."
            exit 1
        fi
        cd ../.. || { echo "Failed to change directory back to Graphite-gtk-theme."; exit 1; }
    else
        echo "Bootloader theme directory other/grub2 not found."
        exit 1
    fi
fi

echo "For theming file manager: Look inside the .themes folder in Home for a gtk4 folder. Copy the contents of the folder to ~/.config/gtk-4.0 and logout and back in."
echo "Setup complete."
