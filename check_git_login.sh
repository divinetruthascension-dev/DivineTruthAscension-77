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
    echo "⚠️ SSH authentication failed (no key or not added)."
fi

# 4. Test HTTPS login if credentials are stored
echo ""
if [ -f ~/.git-credentials ]; then
    echo "🌐 Found saved HTTPS credentials."
    if git ls-remote https://github.com >/dev/null 2>&1; then
        echo "✅ HTTPS authentication works!"
    else
        echo "⚠️ HTTPS credentials saved but authentication failed."
    fi
else
    echo "ℹ️ No saved HTTPS credentials found (~/.git-credentials missing)."
fi

echo ""
echo "✅ Git login check complete."
