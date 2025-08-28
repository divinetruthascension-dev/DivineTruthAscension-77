#!/data/data/com.termux/files/usr/bin/bash
# ============================================================
# Script: stabilize_and_netlify_divinetruthascension.sh
# Purpose: Backup, clean, secure, and deploy DivineTruthAscension
# Author: Your Termux Setup
# ============================================================

set -e

# --- 1️⃣ Define directories ---
HOME_DIR="$HOME"
PROJECT_NAME="divinetruthascension-7"
PROJECT_DIR="$HOME_DIR/$PROJECT_NAME"
BACKUP_DIR="$HOME_DIR/${PROJECT_NAME}-backup-$(date +%Y%m%d%H%M%S)"

echo "Home directory: $HOME_DIR"
echo "Project directory: $PROJECT_DIR"
echo "Backup directory: $BACKUP_DIR"

# --- 2️⃣ Backup current project ---
echo "Backing up current project..."
cp -r "$PROJECT_DIR" "$BACKUP_DIR"
echo "Backup completed: $BACKUP_DIR"

# --- 3️⃣ Remove problematic plugins ---
echo "Removing Puppeteer, LMDB, and native plugins..."
cd "$PROJECT_DIR"
npm uninstall puppeteer lmdb @netlify/plugin-lighthouse @vgs/netlify-plugin-vgs || echo "No problematic plugins found"
rm -rf node_modules package-lock.json

# --- 4️⃣ Install only essential dependencies ---
echo "Installing essential dependencies..."
npm install

# --- 5️⃣ Ensure safe Git state ---
echo "Checking Git status..."
git add -A
git commit -m "Cleaned project for Netlify deployment" || echo "Nothing to commit"

# --- 6️⃣ Configure netlify.toml ---
NETLIFY_FILE="$PROJECT_DIR/netlify.toml"
if [ ! -f "$NETLIFY_FILE" ]; then
    echo "Creating basic netlify.toml for static deploy..."
    cat > "$NETLIFY_FILE" <<EOL
[build]
  publish = "public"
  command = ""

[[plugins]]
package = "netlify-plugin-checklinks"
EOL
    echo "netlify.toml created."
else
    echo "netlify.toml already exists."
fi

# --- 7️⃣ Link project to Netlify site ---
if ! netlify status &>/dev/null; then
    echo "Linking project to Netlify..."
    netlify link || echo "Project already linked or failed to link. Run 'netlify link' manually if needed."
fi

# --- 8️⃣ Local HTTP preview ---
PUBLISH_DIR="$PROJECT_DIR/public"
if [ ! -d "$PUBLISH_DIR" ]; then
    echo "Publish directory not found, defaulting to project root."
    PUBLISH_DIR="$PROJECT_DIR"
fi

echo "Starting local HTTP server at port 8080..."
http-server "$PUBLISH_DIR" -p 8080 &

# --- 9️⃣ Deploy to Netlify without Puppeteer ---
echo "Attempting production deploy..."
netlify deploy --dir="$PUBLISH_DIR" --prod || echo "Deployment failed. Ensure Netlify site is linked."

echo ""
echo "✅ Stabilization and deployment script complete!"
echo "Local preview available at: http://127.0.0.1:8080"
echo "Backup location: $BACKUP_DIR"
echo "You can stop the server with: kill $!"
