#!/bin/bash

# --- Configuration ---
REPO_DIR="$HOME/storage/shared/divinetruthascension-v2"
GITHUB_REPO="https://github.com/divinetruthascension-dev/divinetruthascension-v2.git"  # Replace with your repo

# --- Step 1: Navigate to the repo ---
cd "$REPO_DIR" || { echo "Repo not found!"; exit 1; }

# --- Step 2: Fetch all remote branches ---
git fetch --all

# --- Step 3: Ensure we are on main ---
git checkout main

# --- Step 4: Merge master branch if exists ---
if git show-ref --quiet refs/heads/master; then
    echo "Merging master into main..."
    git merge master --allow-unrelated-histories -m "Merge master into main"
fi

# --- Step 5: Merge Master branch if exists ---
if git show-ref --quiet refs/heads/Master; then
    echo "Merging Master into main..."
    git merge Master --allow-unrelated-histories -m "Merge Master into main"
fi

# --- Step 6: Delete old branches locally ---
git branch -D master 2>/dev/null
git branch -D Master 2>/dev/null

# --- Step 7: Delete old branches on GitHub ---
git push origin --delete master 2>/dev/null
git push origin --delete Master 2>/dev/null

# --- Step 8: Push main branch to GitHub ---
git push -u origin main

echo "✅ Cleanup complete. Only 'main' branch remains."
