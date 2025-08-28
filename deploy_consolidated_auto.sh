#!/bin/bash
# deploy_consolidated_auto.sh
# Fully automated consolidation and Netlify deployment for Termux
# Automatically clears public/, copies all HTML, CSS, JS, assets, and functions
# Automatically links Netlify using PAT if not linked

# ------------------------------
# CONFIGURATION
# ------------------------------
PRIMARY_REPO="$HOME/divinetruthascension"
SECONDARY_REPOS=("divinetruthascension-7" "divinetruthascension-77" "divinetruthascension-v2")
PRIMARY_SITE_ID="7b18fe4a-bed2-4d6a-aa93-9f0ed93a41e8"  # Change if different
PUBLIC_DIR="$PRIMARY_REPO/public"
FUNCTIONS_DIR="$PRIMARY_REPO/functions"
SECONDARY_DIR="$PRIMARY_REPO/secondary"

# Set your Netlify PAT (replace with your token if not using environment variable)
export NETLIFY_AUTH_TOKEN=nfp_vDjTEinUmeFknyQSphhSd9aFUpjgB7Nf6265

# ------------------------------
# STEP 0: Ensure Netlify CLI is linked
# ------------------------------
cd "$PRIMARY_REPO" || exit

if ! netlify status >/dev/null 2>&1; then
    echo "Netlify CLI not linked. Linking automatically using PAT..."
    netlify link --manual --site="$PRIMARY_SITE_ID"
fi

# ------------------------------
# STEP 1: Ensure directories exist
# ------------------------------
mkdir -p "$PUBLIC_DIR"
mkdir -p "$FUNCTIONS_DIR"
mkdir -p "$SECONDARY_DIR"

# ------------------------------
# STEP 2: Clean public/ before deploy
# ------------------------------
echo "Cleaning public/ directory..."
rm -rf "$PUBLIC_DIR"/*
echo "public/ cleared."

# ------------------------------
# STEP 3: Copy secondary repos into secondary/
# ------------------------------
for repo in "${SECONDARY_REPOS[@]}"; do
    SRC="$HOME/$repo"
    DEST="$SECONDARY_DIR/$repo"

    if [ -d "$SRC" ]; then
        echo "Copying $repo into $DEST..."
        mkdir -p "$DEST"
        cp -r "$SRC/"* "$DEST/"
    else
        echo "Warning: $repo not found in $HOME, skipping..."
    fi
done

# ------------------------------
# STEP 4: Recursively copy HTML, CSS, JS, and assets into public/
# ------------------------------
echo "Copying all HTML, CSS, JS, and assets into public/..."
for repo in "${SECONDARY_REPOS[@]}"; do
    SRC="$SECONDARY_DIR/$repo"

    if [ -d "$SRC" ]; then
        # Copy all HTML, CSS, JS files
        find "$SRC" -type f \( -name "*.html" -o -name "*.css" -o -name "*.js" \) | while read FILE; do
            REL_PATH="${FILE#$SRC/}"                 # relative path inside repo
            DEST_PATH="$PUBLIC_DIR/$REL_PATH"
            DEST_DIR=$(dirname "$DEST_PATH")
            mkdir -p "$DEST_DIR"
            cp "$FILE" "$DEST_PATH"
        done

        # Copy assets folders
        find "$SRC" -type d -name "assets" | while read ASSETS_DIR; do
            DEST_ASSETS_DIR="$PUBLIC_DIR/${ASSETS_DIR#$SRC/}"
            mkdir -p "$DEST_ASSETS_DIR"
            cp -r "$ASSETS_DIR/." "$DEST_ASSETS_DIR/"
        done

        # Copy functions if exists
        if [ -d "$SRC/functions" ]; then
            cp -r "$SRC/functions/." "$FUNCTIONS_DIR/"
        fi
    fi
done

# ------------------------------
# STEP 5: Deploy to Netlify
# ------------------------------
echo "Deploying to Netlify..."
netlify deploy --dir="$PUBLIC_DIR" --functions="$FUNCTIONS_DIR" --site="$PRIMARY_SITE_ID" --prod

echo "✅ Deployment complete!"
