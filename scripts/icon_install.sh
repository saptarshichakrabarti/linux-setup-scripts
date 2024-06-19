#!/bin/bash

# URL of the tar.gz file to download
URL="https://github.com/saptarshichakrabarti/linux-setup-scripts/raw/main/gruvbox-plus-icon-pack.5.4.tar.gz"

# Directory where the tar.gz file will be downloaded and extracted
DOWNLOAD_DIR="/tmp"

# Download the file
echo "Downloading $URL..."
wget -q --show-progress $URL -P $DOWNLOAD_DIR

# Extract the contents of the downloaded tar.gz file
echo "Extracting contents..."
tar -xf "$DOWNLOAD_DIR/gruvbox-plus-icon-pack.5.4.tar.gz" -C $DOWNLOAD_DIR

# Find the extracted directory name
EXTRACTED_DIR=$(tar -tf "$DOWNLOAD_DIR/gruvbox-plus-icon-pack.5.4.tar.gz" | head -n 1 | cut -d '/' -f 1)

if [ -z "$EXTRACTED_DIR" ]; then
    echo "Failed to determine extracted directory name."
    exit 1
fi

# Create .icons folder in the home directory if it doesn't exist
ICONS_DIR="$HOME/.icons"
mkdir -p $ICONS_DIR

# Move extracted contents to ~/.icons folder
echo "Moving files to $ICONS_DIR..."
mv "$DOWNLOAD_DIR/$EXTRACTED_DIR"/* $ICONS_DIR

# Clean up - remove the downloaded tar.gz file
echo "Cleaning up..."
rm "$DOWNLOAD_DIR/gruvbox-plus-icon-pack.5.4.tar.gz"

echo "Installation complete."
