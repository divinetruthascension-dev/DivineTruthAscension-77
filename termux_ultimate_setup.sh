#!/bin/bash
# Ultimate Termux Setup Script
LOG_FILE="$HOME/termux_full_install_log.txt"
echo "Ultimate Termux Installation Log - $(date)" > "$LOG_FILE"

# Function: Install package with checks, logging, and silent install
install_package() {
    PACKAGE=$1
    if ! dpkg -s $PACKAGE >/dev/null 2>&1; then
        echo "Installing $PACKAGE..." | tee -a "$LOG_FILE"
        pkg install -y $PACKAGE >> "$LOG_FILE" 2>&1
        if [ $? -eq 0 ]; then
            echo "[✔] $PACKAGE installed successfully." | tee -a "$LOG_FILE"
        else
            echo "[✖] Failed to install $PACKAGE." | tee -a "$LOG_FILE"
        fi
    else
        echo "[→] $PACKAGE already installed. Skipping..." | tee -a "$LOG_FILE"
    fi
}

# Function: Display progress percentage
show_progress() {
    CURRENT=$1
    TOTAL=$2
    PERCENT=$(( CURRENT * 100 / TOTAL ))
    echo "Progress: [$CURRENT/$TOTAL] ($PERCENT%)"
}

# Package categories
ESSENTIAL=(coreutils bash termux-tools)
DEVELOPMENT=(python nodejs php openjdk git nano vim)
SYSTEM_MONITOR=(htop iftop ncdu)
NETWORK=(openssh wget curl)
ANDROID_API=(termux-api)
UTILITY=(figlet toilet)

# Combine all packages into one array
ALL_PACKAGES=("${ESSENTIAL[@]}" "${DEVELOPMENT[@]}" "${SYSTEM_MONITOR[@]}" \
"${NETWORK[@]}" "${ANDROID_API[@]}" "${UTILITY[@]}")

TOTAL=${#ALL_PACKAGES[@]}
COUNT=0

# Update Termux first
echo "Updating Termux packages..." | tee -a "$LOG_FILE"
pkg update -y >> "$LOG_FILE" 2>&1
pkg upgrade -y >> "$LOG_FILE" 2>&1

# Install all packages with progress and logging
for pkg_name in "${ALL_PACKAGES[@]}"; do
    COUNT=$((COUNT + 1))
    show_progress $COUNT $TOTAL
    install_package $pkg_name
done

# Cleanup
echo "Cleaning up..." | tee -a "$LOG_FILE"
pkg autoclean -y >> "$LOG_FILE" 2>&1

echo "Ultimate Termux setup completed!"
echo "Check log for details: $LOG_FILE"
