#!/bin/bash
set -e

PRIMARY_DIR="$HOME/divinetruthascension"
cd "$PRIMARY_DIR"

# === Add remotes for secondary repos ===
git remote add repo7 https://github.com/divinetruthascension-dev/divinetruthascension-7.git || true
git remote add repo77 https://github.com/divinetruthascension-dev/divinetruthascension-77.git || true

# === Fetch secondary repos ===
git fetch repo7
git fetch repo77

# === Merge repo7 ===
echo "=== Merging divinetruthascension-7 ==="
git merge repo7/main --allow-unrelated-histories || true

echo "Resolving conflicts from repo7..."
./resolve-merge.sh

# === Merge repo77 ===
echo "=== Merging divinetruthascension-77 ==="
git merge repo77/main --allow-unrelated-histories || true

echo "Resolving conflicts from repo77..."
./resolve-merge.sh

echo "✅ All secondary repos merged into primary repo successfully!"
