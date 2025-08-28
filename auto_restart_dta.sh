#!/data/data/com.termux/files/usr/bin/bash
# Auto-Restart Safe Start for DivineTruthAscension
# Frees ports and restarts the server automatically if it crashes

PORTS=(9000 9100 9200 9300 9400)
PROJECT_DIR=~/divinetruthascension
SERVER_SCRIPT=~/ultimate_start_dta.sh
LOG_FILE=~/divinetruthascension/server.log

echo "Starting Auto-Restart Safe Start..."
cd "$PROJECT_DIR" || { echo "❌ Cannot access $PROJECT_DIR"; exit 1; }

while true; do
    echo "Checking ports and freeing if needed..."

    for PORT in "${PORTS[@]}"; do
        # Use fuser to check if port is in use
        if fuser "$PORT"/tcp >/dev/null 2>&1; then
            PID=$(fuser "$PORT"/tcp 2>/dev/null)
            echo "Port $PORT in use by PID $PID, killing..."
            kill -9 $PID
        fi
        echo "✅ Port $PORT is free."
    done

    # Start the server
    if [[ ! -x "$SERVER_SCRIPT" ]]; then
        echo "❌ Server script $SERVER_SCRIPT not found or not executable!"
        exit 1
    fi

    echo "🚀 Starting DivineTruthAscension server..."
    # Run in background and log output
    "$SERVER_SCRIPT" start >> "$LOG_FILE" 2>&1

    # Monitor server status
    echo "🛠️ Server stopped. Restarting in 5 seconds..."
    sleep 5
done
