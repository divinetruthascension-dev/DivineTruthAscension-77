#!/bin/bash
# DivineTruthAscension progress tracker

PROJECT_DIR=~/divinetruthascension
cd "$PROJECT_DIR"

# Check for changes
if git status --porcelain | grep .; then
    # Ask for commit message
    read -p "Enter commit message: " MSG
    # Commit changes
    git add .
    git commit -m "$MSG"
    echo "✅ Changes committed."

    # Update progress.txt
    DATE=$(date "+%Y-%m-%d %H:%M:%S")
    echo "[$DATE] $MSG" >> progress.txt
    echo "📄 progress.txt updated."
else
    echo "✔ No changes detected. Working tree clean."
fi
