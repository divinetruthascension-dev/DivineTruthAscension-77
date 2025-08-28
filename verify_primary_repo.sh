#!/data/data/com.termux/files/usr/bin/bash
# Verify divinetruthascension primary repo and merged content

PRIMARY_REPO=~/divinetruthascension
SECONDARY_FOLDER=secondary

cd $PRIMARY_REPO || { echo "Primary repo not found!"; exit 1; }

echo "=== Git Status ==="
git status -s
echo ""

echo "=== Top-level files ==="
ls -1
echo ""

echo "=== Dist folder contents ==="
if [ -d "dist" ]; then
    ls -1 dist
else
    echo "No dist folder found!"
fi
echo ""

echo "=== Secondary folder contents ==="
if [ -d "$SECONDARY_FOLDER" ]; then
    for sub in "$SECONDARY_FOLDER"/*; do
        [ -d "$sub" ] || continue
        echo "-- $(basename $sub) --"
        ls -1 "$sub"
        echo ""
    done
else
    echo "No secondary folder found!"
fi

echo "=== Merge commits ==="
git log --oneline --grep="Merge"
echo ""

echo "✅ Verification complete!"
