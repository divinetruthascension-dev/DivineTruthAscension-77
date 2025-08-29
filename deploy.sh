#!/data/data/com.termux/files/usr/bin/bash
# 🚀 Full Auto Build, Node-Gyp, Git & Netlify Deploy Script for Termux
# Smart Build Detection, Auto Commit, Auto-detect deploy folder, Netlify login check

set -e  # Stop if any command fails

# -----------------------------
# 0. Check Netlify login
# -----------------------------
if ! netlify status &> /dev/null; then
  echo "❌ Netlify CLI not logged in. Please run 'netlify login' first."
  exit 1
fi

# -----------------------------
# 1. Clean old dependencies
# -----------------------------
echo "🔄 Cleaning old dependencies..."
rm -rf node_modules package-lock.json

# -----------------------------
# 2. Install fresh dependencies
# -----------------------------
echo "📦 Installing dependencies..."
npm install --legacy-peer-deps

# -----------------------------
# 3. Rebuild native modules
# -----------------------------
echo "🛠️ Rebuilding native modules with node-gyp..."
npm install -g node-gyp
node-gyp rebuild || echo "⚠️ node-gyp rebuild failed or no native modules, skipping"

# -----------------------------
# 4. Build the project (if script exists)
# -----------------------------
if npm run | grep -q 'build'; then
  echo "🏗️ Build script found, running npm run build..."
  npm run build
  echo "✅ Build completed"
else
  echo "ℹ️ No build script found in package.json, skipping build step"
fi

# -----------------------------
# 5. Commit & push local changes if any
# -----------------------------
if [ -n "$(git status --porcelain)" ]; then
  echo "💾 Committing local changes..."
  git add .
  git commit -m "Auto-commit before Netlify deploy"
  echo "🚀 Pushing to GitHub..."
  git push origin main
else
  echo "ℹ️ No local changes to commit, skipping Git push"
fi

# -----------------------------
# 6. Auto-detect deploy folder
# -----------------------------
if [ -d "dist" ]; then
  DEPLOY_DIR="dist"
elif [ -d "build" ]; then
  DEPLOY_DIR="build"
else
  DEPLOY_DIR="."
fi

echo "🌍 Deploying to Netlify from folder: $DEPLOY_DIR"
netlify deploy --prod --dir="$DEPLOY_DIR"

# -----------------------------
# 7. Monitor deploy logs
# -----------------------------
echo "⏳ Streaming Netlify deploy logs..."
netlify deploy:monitor

echo "✅ Deployment finished from $DEPLOY_DIR!"
