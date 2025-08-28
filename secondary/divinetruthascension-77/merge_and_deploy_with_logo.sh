#!/bin/bash

# --- CONFIGURE YOUR VARIABLES ---
GITHUB_USER=divinetruthascension-dev 
REPO_README="divinetruthascension"
REPO_JS="divinetruthascension-7"
MERGE_DIR="DivineSocial"
NETLIFY_SITE_ID=7b18fe4a-bed2-4d6a-aa93-9f0ed93a41e8   # optional
NETLIFY_AUTH_TOKEN=nfp_btXPyrG829hrPC65Q5dcnh15Z6LMU7Wzc41f

# --- INSTALL DEPENDENCIES IF MISSING ---
pkg install -y git nodejs
npm install -g netlify-cli

# --- CLEANUP OLD CLONES ---
rm -rf $REPO_README $REPO_JS $MERGE_DIR

# --- CLONE BOTH REPOS ---
git clone https://github.com/$GITHUB_USER/$REPO_README.git
git clone https://github.com/$GITHUB_USER/$REPO_JS.git

# --- CREATE MERGE DIRECTORY ---
mkdir $MERGE_DIR
mkdir -p $MERGE_DIR/css $MERGE_DIR/js $MERGE_DIR/images/avatars $MERGE_DIR/images/badges

# --- COPY FILES ---
cp -r $REPO_README/* $MERGE_DIR/
cp -r $REPO_JS/* $MERGE_DIR/js/

# --- COPY LOGO ---
if [ -f "$REPO_README/logo.png" ]; then
    cp "$REPO_README/logo.png" $MERGE_DIR/images/logo.png
    cp "$REPO_README/logo.png" $MERGE_DIR/images/favicon.png
else
    echo "⚠️ logo.png not found in $REPO_README"
fi

# --- CREATE index.html ---
cat > $MERGE_DIR/index.html <<EOL
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>DivineTruthAscension</title>
<link rel="stylesheet" href="css/styles.css">
<link rel="icon" type="image/png" href="images/favicon.png">
</head>
<body>
<!-- Particle Layer -->
<div id="particle-layer"></div>

<!-- Header / Navigation -->
<header>
<img src="images/logo.png" alt="DivineTruthAscension Logo" style="height:50px;margin-right:1rem;">
<h1>DivineTruthAscension</h1>
<nav>
<a href="#feed">Feed</a>
<a href="#profiles">Profiles</a>
</nav>
</header>

<!-- Welcome Section -->
<section id="welcome">
<h2>✨ Illuminating truth where darkness resides ✨</h2>
</section>

<!-- Feed Section -->
<main id="feed-container">
<!-- Posts generated dynamically by JS -->
</main>

<!-- Footer -->
<footer>© 2025 DivineTruthAscension • Spiritual Static Platform</footer>

<script src="js/app.js"></script>
</body>
</html>
EOL

# --- CREATE DEFAULT CSS ---
cat > $MERGE_DIR/css/styles.css <<EOL
body { font-family: sans-serif; background: #111; color: #eee; margin:0; padding:0; }
header { display:flex; align-items:center; padding:1rem; background:#222; }
header nav a { margin-left:1rem; color:#fff; text-decoration:none; }
#particle-layer { position:fixed; width:100%; height:100%; top:0; left:0; z-index:-1; }
section#welcome { text-align:center; padding:3rem; font-size:1.5rem; }
footer { text-align:center; padding:1rem; background:#222; margin-top:2rem; }
EOL

# --- INITIALIZE GIT IN MERGE DIR ---
cd $MERGE_DIR
git init
git remote add origin https://github.com/$GITHUB_USER/$REPO_README.git
git add .
git commit -m "Merged JS + README + logo into fully branded static site"
git push -u origin main --force

# --- NETLIFY DEPLOY (Optional) ---
if [ ! -z "$NETLIFY_SITE_ID" ] && [ ! -z "$NETLIFY_AUTH_TOKEN" ]; then
    export NETLIFY_AUTH_TOKEN=$NETLIFY_AUTH_TOKEN
    netlify deploy --dir=. --site=$NETLIFY_SITE_ID --prod
fi

echo "✅ Merge, branding, and deploy completed!"
