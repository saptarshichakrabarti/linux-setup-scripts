#!/usr/bin/env bash
#
# MiniHack Environment Setup Script
# to run, execute: sh setup_minihack.sh
#
# Author: Saptarshi Chakrabarti
#
# Description: This script sets up the MiniHack environment using conda and installs necessary dependencies.

# Create and activate MiniHack conda environment
conda create -n minihack python=3.8 -y
conda activate minihack

# Install necessary packages
sudo apt install -y cmake build-essential autoconf libtool pkg-config python3-dev python3-pip python3-numpy git flex bison libbz2-dev

# Install MiniHack
pip install minihack

echo "MiniHack environment setup complete."
