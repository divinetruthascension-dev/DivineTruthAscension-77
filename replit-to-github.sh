#!/data/data/com.termux/files/usr/bin/bash
# Script to upload a Replit project (downloaded ZIP) to GitHub

# === SETTINGS (edit these) ===
ZIP_FILE="DivineTruthAscension.zip"   # your downloaded zip from Replit
GITHUB_USER=divinetruthascension-v2          # replace with your GitHub username
REPO_NAME="DivineTruthAscension"     # your GitHub repo name
BRANCH="main"                        # or "master" if your repo uses that
# ==============================

# Unzip project
echo "[*] Unzipping project..."
unzip -o "$ZIP_FILE" -d "$REPO_NAME"
cd "$REPO_NAME" || { echo "❌ Failed to cd into project folder"; exit 1; }

# Initialize Git
echo "[*] Initializing git..."
git init
git branch -M $BRANCH

# Add remote
echo "[*] Adding GitHub remote..."
git remote add origin https://github.com/$GITHUB_USER/$REPO_NAME.git

# Stage + commit
echo "[*] Staging and committing..."
git add .
git commit -m "Initial commit from Replit export"

# Push
echo "[*] Pushing to GitHub..."
git push -u origin $BRANCH --force

echo "✅ Done! Your Replit project is now on GitHub."
