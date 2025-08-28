#!/data/data/com.termux/files/usr/bin/bash

# Config
SERVER_DIR="$HOME/divinetruthascension"
SERVER_SCRIPT="ultimate_start_dta.sh"
LOG_FILE="$SERVER_DIR/server.log"
PORTS=(9000 9100 9200 9300 9400)
MAX_RETRIES=5
COOLDOWN=15  # seconds

cd "$SERVER_DIR" || { echo "Server directory not found!"; exit 1; }

retry_count=0

while true; do
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Checking ports..." | tee -a "$LOG_FILE"

    # Free ports if needed
    for PORT in "${PORTS[@]}"; do
        if ss -ltnp 2>/dev/null | grep -q ":$PORT"; then
            echo "[$(date '+%Y-%m-%d %H:%M:%S')] Port $PORT in use. Killing process..." | tee -a "$LOG_FILE"
            pkill -f "$PORT"
            sleep 1
        else
            echo "[$(date '+%Y-%m-%d %H:%M:%S')] Port $PORT free." | tee -a "$LOG_FILE"
        fi
    done

    # Start server
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Starting DivineTruthAscension server..." | tee -a "$LOG_FILE"
    ./"$SERVER_SCRIPT" start >> "$LOG_FILE" 2>&1

    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Server stopped." | tee -a "$LOG_FILE"
    
    # Retry logic
    retry_count=$((retry_count + 1))
    if [ "$retry_count" -ge "$MAX_RETRIES" ]; then
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] Max retries reached ($MAX_RETRIES). Exiting loop." | tee -a "$LOG_FILE"
        break
    fi

    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Waiting $COOLDOWN seconds before retry..." | tee -a "$LOG_FILE"
    sleep "$COOLDOWN"
done

