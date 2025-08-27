#!/bin/bash
# Enhanced Termux Package Installer with Checks

echo "Updating Termux packages..."
pkg update -y && pkg upgrade -y

# Function to install package if not already installed
install_if_missing() {
    PACKAGE=$1
    if ! dpkg -s $PACKAGE >/dev/null 2>&1; then
        echo "Installing $PACKAGE..."
        pkg install -y $PACKAGE
    else
        echo "$PACKAGE is already installed. Skipping..."
    fi
}

echo "Installing essential core packages..."
for pkg_name in coreutils bash termux-tools; do
    install_if_missing $pkg_name
done

echo "Installing development packages..."
for pkg_name in python nodejs php openjdk git nano vim; do
    install_if_missing $pkg_name
done

echo "Installing system monitoring tools..."
for pkg_name in htop iftop ncdu; do
    install_if_missing $pkg_name
done

echo "Installing networking & connectivity tools..."
for pkg_name in openssh wget curl; do
    install_if_missing $pkg_name
done

echo "Installing Android integration tools..."
install_if_missing termux-api

echo "Installing utility packages..."
for pkg_name in figlet toilet; do
    install_if_missing $pkg_name
done

echo "Cleaning up..."
pkg autoclean -y

echo "All packages checked and installed successfully!"
