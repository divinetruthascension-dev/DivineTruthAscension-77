#!/data/data/com.termux/files/usr/bin/bash
# ultimate_start_dta.sh - Safe start for DivineTruthAscension with backup

# ---- CONFIG ----
PROJECT_DIR="$HOME/divinetruthascension"
BACKUP_DIR="$HOME/divinetruthascension-backups"
PORTS=(9000 9100 9200 9300 9400)
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

# ---- FUNCTIONS ----
check_command() {
    command -v "$1" >/dev/null 2>&1 || {
        echo "[⚠] $1 is not installed. Installing..."
        pkg install -y "$1"
    }
}

check_port() {
    local port=$1
    if ss -ltn | awk '{print $4}' | grep -q ":$port\$"; then
        return 1
    else
        return 0
    fi
}

backup_project() {
    mkdir -p "$BACKUP_DIR"
    BACKUP_PATH="$BACKUP_DIR/divinetruthascension_$TIMESTAMP"
    echo "[💾] Backing up project to $BACKUP_PATH ..."
    cp -r "$PROJECT_DIR" "$BACKUP_PATH"
    echo "[✔] Backup complete."
}

start_server() {
    cd "$PROJECT_DIR" || { echo "[✖] Cannot enter project directory."; exit 1; }

    backup_project  # Backup before starting

    # Try each port
    for port in "${PORTS[@]}"; do
        if check_port "$port"; then
            echo "[✔] Starting server on port $port..."
            python3 -m http.server "$port" &
            echo $! > "$PROJECT_DIR/server.pid"
            echo "[✔] Server started with PID $(cat $PROJECT_DIR/server.pid)"
            return 0
        else
            echo "[⚠] Port $port is in use, trying next..."
        fi
    done

    echo "[✖] All ports are in use. Cannot start server."
    exit 1
}

stop_server() {
    if [[ -f "$PROJECT_DIR/server.pid" ]]; then
        PID=$(cat "$PROJECT_DIR/server.pid")
        echo "[⚠] Stopping server with PID $PID..."
        kill "$PID" && rm "$PROJECT_DIR/server.pid"
        echo "[✔] Server stopped."
    else
        echo "[⚠] No server PID found. Is it running?"
    fi
}

# ---- CHECK DEPENDENCIES ----
check_command python3
check_command ss

# ---- MAIN ----
case "$1" in
    start)
        start_server
        ;;
    stop)
        stop_server
        ;;
    restart)
        stop_server
        start_server
        ;;
    *)
        echo "Usage: $0 {start|stop|restart}"
        exit 1
        ;;
esac
