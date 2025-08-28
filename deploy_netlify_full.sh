#!/data/data/com.termux/files/usr/bin/bash
# File: deploy_netlify_full.sh
# One-command deploy for divinetruthascension in Termux

# === Configuration ===
BUILD_DIR="dist"

# Check environment variables
if [ -z "$NETLIFY_AUTH_TOKEN" ] || [ -z "$NETLIFY_SITE_ID" ]; then
  echo "ERROR: Please set NETLIFY_AUTH_TOKEN and NETLIFY_SITE_ID in ~/.bashrc"
  exit 1
fi

# Step 1: Clean local Netlify plugins to avoid node-gyp errors
if [ -d ".netlify/plugins" ]; then
  echo "Cleaning local .netlify/plugins..."
  rm -rf .netlify/plugins
fi

# Step 2: Rebuild your dist folder (optional)
if [ -f "package.json" ]; then
  echo "Building project..."
  npm install
  npm run build
fi

# Step 3: Verify dist folder exists
if [ ! -d "$BUILD_DIR" ]; then
  echo "ERROR: '$BUILD_DIR' folder not found. Make sure your site is built."
  exit 1
fi

# Step 4: Deploy to Netlify
echo "Deploying $BUILD_DIR to Netlify site $NETLIFY_SITE_ID..."
netlify deploy --prod --dir="$BUILD_DIR" --site="$NETLIFY_SITE_ID"

echo "Deployment complete!"
