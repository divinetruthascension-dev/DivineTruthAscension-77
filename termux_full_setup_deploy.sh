#!/bin/bash
# Ultimate Termux Setup Script with Netlify CLI + GitHub + Two Repo Updates
LOG_FILE="$HOME/termux_full_install_log.txt"
echo "Ultimate Termux Installation Log - $(date)" > "$LOG_FILE"

# ---------------------------
# Helper Functions
# ---------------------------
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

show_progress() {
    CURRENT=$1
    TOTAL=$2
    PERCENT=$(( CURRENT * 100 / TOTAL ))
    echo "Progress: [$CURRENT/$TOTAL] ($PERCENT%)"
}

# ---------------------------
# Package Lists
# ---------------------------
ESSENTIAL=(coreutils bash termux-tools)
DEVELOPMENT=(python nodejs php openjdk git nano vim)
SYSTEM_MONITOR=(htop iftop ncdu)
NETWORK=(openssh wget curl)
ANDROID_API=(termux-api)
UTILITY=(figlet toilet)

ALL_PACKAGES=("${ESSENTIAL[@]}" "${DEVELOPMENT[@]}" "${SYSTEM_MONITOR[@]}" \
"${NETWORK[@]}" "${ANDROID_API[@]}" "${UTILITY[@]}")

TOTAL=${#ALL_PACKAGES[@]}
COUNT=0

# ---------------------------
# Update & Install Packages
# ---------------------------
echo "Updating Termux packages..." | tee -a "$LOG_FILE"
pkg update -y >> "$LOG_FILE" 2>&1
pkg upgrade -y >> "$LOG_FILE" 2>&1

for pkg_name in "${ALL_PACKAGES[@]}"; do
    COUNT=$((COUNT + 1))
    show_progress $COUNT $TOTAL
    install_package $pkg_name
done

# ---------------------------
# Install Netlify CLI
# ---------------------------
if ! command -v netlify >/dev/null 2>&1; then
    echo "Installing Netlify CLI..." | tee -a "$LOG_FILE"
    npm install -g netlify-cli --unsafe-perm >> "$LOG_FILE" 2>&1
    if [ $? -eq 0 ]; then
        echo "[✔] Netlify CLI installed successfully." | tee -a "$LOG_FILE"
    else
        echo "[✖] Failed to install Netlify CLI." | tee -a "$LOG_FILE"
    fi
else
    echo "[→] Netlify CLI already installed. Skipping..." | tee -a "$LOG_FILE"
fi

# ---------------------------
# GitHub SSH Key Setup
# ---------------------------
if [ ! -f ~/.ssh/id_ed25519 ]; then
    echo "Generating SSH key for GitHub..." | tee -a "$LOG_FILE"
    ssh-keygen -t ed25519 -C "your-email@example.com" -f ~/.ssh/id_ed25519 -N "" >> "$LOG_FILE" 2>&1
    eval "$(ssh-agent -s)" >> "$LOG_FILE" 2>&1
    ssh-add ~/.ssh/id_ed25519 >> "$LOG_FILE" 2>&1
    echo "[✔] SSH key generated." | tee -a "$LOG_FILE"
    echo "Copy the following public key to GitHub:"
    cat ~/.ssh/id_ed25519.pub
else
    echo "[→] SSH key already exists. Skipping..." | tee -a "$LOG_FILE"
fi

# ---------------------------
# GitHub Global Config
# ---------------------------
git config --global user.name "Your Name"
git config --global user.email "your-email@example.com"

# ---------------------------
# Clone or Update Repos (divinetruthascension & divinetruthascension-7)
# ---------------------------
REPOS=("divinetruthascension" "divinetruthascension-7")
for REPO in "${REPOS[@]}"; do
    if [ ! -d ~/$REPO ]; then
        echo "Cloning $REPO repository..." | tee -a "$LOG_FILE"
        git clone git@github.com:username/$REPO.git ~/$REPO >> "$LOG_FILE" 2>&1
    else
        echo "[→] $REPO already exists. Pulling latest changes..." | tee -a "$LOG_FILE"
        cd ~/$REPO
        git pull >> "$LOG_FILE" 2>&1
    fi
done

# ---------------------------
# Deploy Only Once (from main repo)
# ---------------------------
MAIN_REPO="divinetruthascension"
echo "Deploying $MAIN_REPO to Netlify..." | tee -a "$LOG_FILE"
cd ~/$MAIN_REPO
if [ ! -f .netlify/state.json ]; then
    netlify init --manual >> "$LOG_FILE" 2>&1
fi
netlify deploy --dir=. >> "$LOG_FILE" 2>&1
netlify deploy --prod --dir=. >> "$LOG_FILE" 2>&1
echo "[✔] Deployment complete." | tee -a "$LOG_FILE"

# ---------------------------
# Cleanup
# ---------------------------
echo "Cleaning up..." | tee -a "$LOG_FILE"
pkg autoclean -y >> "$LOG_FILE" 2>&1

echo "Ultimate Termux setup + GitHub + Repos update + Netlify deploy completed!"
echo "Check log for details: $LOG_FILE"
echo "To login to Netlify manually, run: netlify login"
