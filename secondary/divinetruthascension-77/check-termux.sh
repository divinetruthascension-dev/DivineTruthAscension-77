#!/data/data/com.termux/files/usr/bin/bash
# Termux Health Check Script with Auto-Fix and Cleanup

echo "🔍 Checking Termux System..."

# Show Termux info
termux-info || { echo "✗ Failed to get termux-info"; exit 1; }

echo -e "\n[✓] Termux Info Collected\n"

# Update repos
echo "🔄 Updating package repositories..."
if ! pkg update -y; then
    echo "⚠️ Repo update failed. Trying to auto-fix..."
    yes | termux-change-repo
    echo "🔄 Retrying repo update..."
    pkg update -y || { echo "✗ Repo update still failed. Please run termux-change-repo manually."; exit 1; }
fi

echo -e "\n[✓] Repo Update Successful\n"

# Try installing a test package
echo "📦 Testing package installation (nano)..."
if ! pkg install -y nano; then
    echo "✗ Package install failed"
    exit 1
fi

echo -e "\n[✓] Package Install Test Passed\n"

# Cleanup test package
echo "🧹 Cleaning up test package..."
pkg uninstall -y nano >/dev/null 2>&1

echo -e "\n[✓] Cleanup complete\n"

echo "✅ Termux system and repos are fully functional!"
