#!/data/data/com.termux/files/usr/bin/bash
# File: deploy_netlify.sh
# Deploy divinetruthascension site from Termux without building plugins locally

# Check if environment variables are set
if [ -z "$NETLIFY_AUTH_TOKEN" ] || [ -z "$NETLIFY_SITE_ID" ]; then
  echo "ERROR: Please set NETLIFY_AUTH_TOKEN and NETLIFY_SITE_ID in your ~/.bashrc"
  exit 1
fi

# Path to your build folder
BUILD_DIR="dist"

# Verify dist folder exists
if [ ! -d "$BUILD_DIR" ]; then
  echo "ERROR: '$BUILD_DIR' folder not found. Make sure your static site is built."
  exit 1
fi

# Deploy to Netlify (production)
netlify deploy --prod --dir="$BUILD_DIR" --site="$NETLIFY_SITE_ID"

# Done
echo "Deployment complete!"
