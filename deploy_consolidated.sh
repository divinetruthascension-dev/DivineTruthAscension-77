#!/bin/bash
# deploy_consolidated.sh
# Consolidate secondary repos, copy live content, and deploy to Netlify

# ------------------------------
# CONFIGURATION
# ------------------------------
PRIMARY_REPO="$HOME/divinetruthascension"
SECONDARY_REPOS=("divinetruthascension-7" "divinetruthascension-77")
PRIMARY_SITE_ID="7b18fe4a-bed2-4d6a-aa93-9f0ed93a41e8"  # Change if different
PUBLIC_DIR="$PRIMARY_REPO/public"
FUNCTIONS_DIR="$PRIMARY_REPO/functions"
SECONDARY_DIR="$PRIMARY_REPO/secondary"

# Optional: Set Netlify token
# export NETLIFY_AUTH_TOKEN="your_personal_access_token"

# ------------------------------
# STEP 1: Create secondary folder
# ------------------------------
mkdir -p "$SECONDARY_DIR"

# ------------------------------
# STEP 2: Copy secondary repos into secondary folder
# ------------------------------
for repo in "${SECONDARY_REPOS[@]}"; do
    SRC="$HOME/$repo"
    DEST="$SECONDARY_DIR/$repo"

    if [ -d "$SRC" ]; then
        echo "Copying $repo into $DEST..."
        mkdir -p "$DEST"
        cp -r "$SRC/"* "$DEST/"
    else
        echo "Warning: $repo not found in $HOME"
    fi
done

# ------------------------------
# STEP 3: Copy live content from secondary repos into public/
# ------------------------------
echo "Copying live content into public/..."
for repo in "${SECONDARY_REPOS[@]}"; do
    SRC="$SECONDARY_DIR/$repo"

    # Example: copy HTML, CSS, JS, assets if they exist
    [ -f "$SRC/index.html" ] && cp "$SRC/index.html" "$PUBLIC_DIR/"
    [ -f "$SRC/offline.html" ] && cp "$SRC/offline.html" "$PUBLIC_DIR/"
    [ -f "$SRC/styles.css" ] && cp "$SRC/styles.css" "$PUBLIC_DIR/"
    [ -d "$SRC/assets" ] && cp -r "$SRC/assets" "$PUBLIC_DIR/"

    # Copy functions if any
    [ -d "$SRC/functions" ] && cp -r "$SRC/functions/"* "$FUNCTIONS_DIR/"
done

# ------------------------------
# STEP 4: Deploy to Netlify
# ------------------------------
echo "Deploying to Netlify..."
cd "$PRIMARY_REPO" || exit
netlify deploy --dir=public --functions=functions --site="$PRIMARY_SITE_ID" --prod

echo "✅ Deployment complete!"
