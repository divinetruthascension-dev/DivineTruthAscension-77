#!/bin/bash
set -e

# === CONFIGURATION ===
PRIMARY_DIR="$HOME/divinetruthascension"
SOURCE_DIR="$HOME/divinetruthascension-77"
BACKUP_DIR="$HOME/divinetruthascension-backup-$(date +%Y%m%d%H%M%S)"
SITE_ID="PUT-YOUR-SITE-ID-HERE"   # <-- replace with divinetruthascension Site ID from Netlify

echo "=== STEP 1: Backup primary project ==="
cp -r "$PRIMARY_DIR" "$BACKUP_DIR"
echo "Backup saved at $BACKUP_DIR"

echo "=== STEP 2: Clean old Netlify config ==="
rm -rf "$PRIMARY_DIR/.netlify" "$PRIMARY_DIR/netlify.toml" || true

echo "=== STEP 3: Merge code from $SOURCE_DIR into $PRIMARY_DIR ==="
cp -r "$SOURCE_DIR"/* "$PRIMARY_DIR"/
cp -r "$SOURCE_DIR"/.[^.]* "$PRIMARY_DIR"/ 2>/dev/null || true

echo "=== STEP 4: Link to Netlify primary project ==="
cd "$PRIMARY_DIR"
netlify link --manual --site=$SITE_ID

echo "=== STEP 5: Deploying to Netlify ==="
netlify deploy --dir=public --prod

echo "✅ Migration complete! Your site is live on primary project."
