#!/data/data/com.termux/files/usr/bin/bash

# === Config ===
REPO_NAME="divinetruthascension-7"
INTERVAL=30        # auto-pull interval in seconds
SCRIPTS_DIR=~/scripts

# === Detect GitHub username from SSH config if exists ===
if [ -f ~/.ssh/config ]; then
 divinetruthascension-dev=$(grep -i "user " ~/.ssh/config | head -1 | awk '{print $2}')
fi

# Fallback if not detected
if [ -z divinetruthascension-dev ]; then
    echo "⚠️ GitHub username not detected. Using default 'githubuser'. Edit script to change."
    GITHUB_USER=divinetruthascension-dev
fi

echo divinetruthascension-dev

# === Create scripts folder ===
mkdir -p $SCRIPTS_DIR
cd $SCRIPTS_DIR || exit 1

# === Clone repo if missing ===
if [ ! -d "$REPO_NAME" ]; then
    echo "📥 Cloning repository..."
    git clone git@github.com:$GITHUB_USER/$REPO_NAME.git $REPO_NAME || \
    git clone https://github.com/$GITHUB_USER/$REPO_NAME.git $REPO_NAME
fi

# === Enter repo folder ===
cd $REPO_NAME || exit 1

# === Detect default branch automatically ===
BRANCH=$(git remote show origin | grep "HEAD branch" | awk '{print $NF}')
echo "Detected default branch: $BRANCH"

# === Install dependencies ===
if [ -f package.json ]; then
    npm install
else
    echo "❌ package.json not found. Exiting."
    exit 1
fi

# === Detect first npm script automatically ===
SCRIPT_NAME=$(jq -r '.scripts | keys[0]' package.json)
if [ -z "$SCRIPT_NAME" ]; then
    echo "⚠️ No npm scripts found. Exiting."
    exit 1
fi
echo "✅ Running npm script: $SCRIPT_NAME"

# === Function to start project in background ===
start_project() {
    if [ -f project.pid ]; then
        PID=$(cat project.pid)
        kill $PID 2>/dev/null
    fi
    nohup npm run "$SCRIPT_NAME" > project.log 2>&1 &
    echo $! > project.pid
    echo "✅ $SCRIPT_NAME running. Logs: project.log"
}

# === Start project initially ===
start_project

# === Setup Termux auto-start ===
mkdir -p ~/.termux
BOOT_FILE=~/.termux/boot.sh
if [ ! -f "$BOOT_FILE" ]; then
    echo "bash $SCRIPTS_DIR/$REPO_NAME/setup_divinetruthascension7.sh" > "$BOOT_FILE"
    chmod +x "$BOOT_FILE"
    echo "✅ Termux boot script created."
fi

# === Auto-pull & restart loop ===
echo "🔁 Auto-pull & restart enabled on branch '$BRANCH', interval $INTERVAL seconds"
while true; do
    git fetch origin
    LOCAL=$(git rev-parse HEAD)
    REMOTE=$(git rev-parse origin/$BRANCH)
    if [ "$LOCAL" != "$REMOTE" ]; then
        echo "⚡ Update detected! Pulling and restarting..."
        git pull origin $BRANCH
        start_project
    fi
    sleep $INTERVAL
done
