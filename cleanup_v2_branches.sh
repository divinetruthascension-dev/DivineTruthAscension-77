#!/bin/bash

# --- Configuration ---
REPO_DIR="$HOME/storage/shared/divinetruthascension-v2"
GITHUB_REPO="https://github.com/divinetruthascension-dev/divinetruthascension-v2.git"  # Replace with your repo URL

# --- Step 1: Navigate to the project folder ---
cd "$REPO_DIR" || { echo "Repo folder not found!"; exit 1; }

# --- Step 2: Initialize Git if not already ---
if [ ! -d ".git" ]; then
    echo "Initializing Git..."
    git init
    git add .
    git commit -m "Initial commit from Replit"
fi

# --- Step 3: Add GitHub remote if not already added ---
if ! git remote | grep origin >/dev/null 2>&1; then
    git remote add origin "$GITHUB_REPO"
fi

# --- Step 4: Fetch all branches ---
git fetch origin

# --- Step 5: Ensure we are on main branch ---
if git show-ref --quiet refs/heads/main; then
    git checkout main
else
    git checkout -b main
fi

# --- Step 6: Merge 'Main' branch if it exists ---
if git show-ref --quiet refs/heads/Main; then
    echo "Merging 'Main' into 'main'..."
    git merge Main --allow-unrelated-histories -m "Merge Main into main"
fi

# --- Step 7: Delete 'Main' branch locally ---
git branch -D Main 2>/dev/null

# --- Step 8: Delete 'Main' branch on GitHub ---
git push origin --delete Main 2>/dev/null

# --- Step 9: Push 'main' branch to GitHub ---
git push -u origin main

echo "✅ Branch cleanup complete. Only 'main' remains."
