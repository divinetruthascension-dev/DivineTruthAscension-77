#!/data/data/com.termux/files/usr/bin/bash

# 1️⃣ Allow Git to cross filesystem boundaries
export GIT_DISCOVERY_ACROSS_FILESYSTEM=1
echo "✅ GIT_DISCOVERY_ACROSS_FILESYSTEM set"

# 2️⃣ Install Git and Node.js if missing
echo "🔧 Installing Git and Node.js..."
pkg update -y
pkg upgrade -y
pkg install -y git nodejs jq

REPO_NAME="divinetruthascension-7"

# 3️⃣ Auto SSH & HTTPS login setup
echo "🔐 Setting up GitHub authentication..."
read -p "Use SSH or HTTPS? (ssh/https, default ssh): " METHOD
METHOD=${METHOD:-ssh}

read -p "Enter your GitHub username: " GH_USER

if [[ "$METHOD" == "ssh" ]]; then
    if [ ! -f ~/.ssh/id_ed25519 ]; then
        echo "⚠️ SSH key not found. Generating one..."
        ssh-keygen -t ed25519 -C "$GH_USER" -f ~/.ssh/id_ed25519 -N ""
        eval "$(ssh-agent -s)"
        ssh-add ~/.ssh/id_ed25519
        echo "Copy this key to GitHub (Settings → SSH and GPG keys):"
        cat ~/.ssh/id_ed25519.pub
        read -p "Press Enter after adding SSH key..."
    else
        eval "$(ssh-agent -s)"
        ssh-add ~/.ssh/id_ed25519
    fi
elif [[ "$METHOD" == "https" ]]; then
    if [ ! -f ~/.git-credentials ]; then
        read -p "Enter your GitHub Personal Access Token (PAT): " -s GH_PAT
        echo ""
        git config --global credential.helper store
        echo "https://$GH_USER:$GH_PAT@github.com" > ~/.git-credentials
        echo "✅ PAT saved for HTTPS login"
    else
        echo "✅ Using existing saved HTTPS credentials"
    fi
else
    echo "❌ Invalid option, must be 'ssh' or 'https'."
    exit 1
fi

# 4️⃣ Clone repo if not exists
if [ ! -d "$REPO_NAME" ]; then
    echo "📥 Cloning $REPO_NAME..."
    if [[ "$METHOD" == "ssh" ]]; then
        git clone git@github.com:$GH_USER/$REPO_NAME.git
    else
        git clone https://github.com/$GH_USER/$REPO_NAME.git
    fi
else
    echo "📂 Repo already exists, skipping clone"
fi

cd $REPO_NAME || { echo "❌ Failed to enter repo folder"; exit 1; }

# 5️⃣ Verify Git access
echo ""
echo "🔍 Verifying Git access..."
git remote -v
git status

# 6️⃣ Install dependencies if package.json exists
if [ -f package.json ]; then
    echo ""
    echo "📦 Installing project dependencies via npm..."
    npm install
    echo "✅ Dependencies installed."

    # Detect scripts
    echo ""
    echo "🔹 Available scripts in package.json:"
    SCRIPTS=($(jq -r '.scripts | keys[]' package.json))
    if [ ${#SCRIPTS[@]} -eq 0 ]; then
        echo "⚠️ No scripts found."
    else
        for i in "${!SCRIPTS[@]}"; do
            echo "$i) ${SCRIPTS[$i]}"
        done
        read -p "Enter the number of the script to run in background (default 0): " SCRIPT_IDX
        SCRIPT_IDX=${SCRIPT_IDX:-0}
        SCRIPT_NAME="${SCRIPTS[$SCRIPT_IDX]}"
    fi
else
    echo "⚠️ No package.json found. Skipping npm install and run."
fi

# 7️⃣ Function to start project in background
start_project() {
    if [ -n "$SCRIPT_NAME" ]; then
        echo "🚀 Running npm $SCRIPT_NAME in background..."
        nohup npm run $SCRIPT_NAME > project.log 2>&1 &
        echo $! > project.pid
        echo "✅ Project running in background. Output: project.log"
    fi
}

start_project

# 8️⃣ Auto-pull & restart setup
read -p "Enable auto-pull & auto-restart? (y/n, default n): " AUTO_RESTART
AUTO_RESTART=${AUTO_RESTART:-n}
if [[ "$AUTO_RESTART" == "y" || "$AUTO_RESTART" == "Y" ]]; then
    read -p "Enter the branches to watch, separated by space (default: main): " BRANCHES
    BRANCHES=(${BRANCHES:-main})
    read -p "Enter auto-pull interval in seconds (default: 30): " INTERVAL
    INTERVAL=${INTERVAL:-30}
    echo "🔁 Auto-pull & restart enabled for branches: ${BRANCHES[@]}, interval $INTERVAL seconds."
    echo "Press CTRL+C to stop."
    
    while true; do
        git fetch origin
        UPDATED=false
        for BR in "${BRANCHES[@]}"; do
            LOCAL=$(git rev-parse HEAD)
            REMOTE=$(git rev-parse origin/$BR 2>/dev/null)
            if [ "$LOCAL" != "$REMOTE" ]; then
                echo "⚡ Updates detected on branch $BR! Pulling and restarting project..."
                git pull origin $BR
                if [ -f project.pid ]; then
                    PID=$(cat project.pid)
                    kill $PID 2>/dev/null
                fi
                start_project
                UPDATED=true
                break
            fi
        done
        if [ "$UPDATED" = false ]; then
            echo "✅ No updates detected."
        fi
        sleep $INTERVAL
    done
fi

echo ""
echo "✅ Setup complete. Use 'tail -f project.log' to view output or 'jobs' to see background processes."
