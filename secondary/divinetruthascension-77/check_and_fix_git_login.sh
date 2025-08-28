#!/data/data/com.termux/files/usr/bin/bash

echo "🔍 Checking Git setup..."

# 1. Check if git is installed
if ! command -v git &> /dev/null
then
    echo "❌ Git is not installed. Run: pkg install git"
    exit 1
fi

# 2. Show git global config
echo ""
echo "📝 Git global config:"
git config --global --list || echo "No global config found."

# 3. Test SSH login
echo ""
echo "🔑 Testing SSH login to GitHub..."
if ssh -T git@github.com 2>&1 | grep -q "successfully authenticated"; then
    echo "✅ SSH authentication works!"
else
    echo "⚠️ SSH authentication failed."
    echo "👉 Trying to fix..."
    if [ -f ~/.ssh/id_ed25519 ]; then
        eval "$(ssh-agent -s)"
        ssh-add ~/.ssh/id_ed25519
        echo "🔁 Retesting SSH..."
        ssh -T git@github.com
    else
        echo "❌ No SSH key found (~/.ssh/id_ed25519). You may need to generate one."
    fi
fi

# 4. Test HTTPS login
echo ""
echo "🌐 Checking HTTPS authentication..."
if [ -f ~/.git-credentials ]; then
    if git ls-remote https://github.com >/dev/null 2>&1; then
        echo "✅ HTTPS authentication works!"
    else
        echo "⚠️ HTTPS credentials invalid. You may need to reset your PAT."
    fi
else
    echo "ℹ️ No saved HTTPS credentials."
    read -p "Do you want to add a GitHub Personal Access Token now? (y/n): " CHOICE
    if [[ "$CHOICE" == "y" || "$CHOICE" == "Y" ]]; then
        read -p "Enter your GitHub username: " GH_USER
        read -p "Enter your GitHub PAT (paste carefully, hidden): " -s GH_PAT
        echo ""
        git config --global credential.helper store
        echo "https://$GH_USER:$GH_PAT@github.com" > ~/.git-credentials
        echo "✅ Saved HTTPS credentials to ~/.git-credentials"
    fi
fi

echo ""
echo "✅ Git login check & fix complete."
