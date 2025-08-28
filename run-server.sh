#!/data/data/com.termux/files/usr/bin/bash
# Simple server launcher for Termux

PORTS=(9000 9100 9200 9300 9400)
SERVER_CMD="python3 -m http.server"

for PORT in "${PORTS[@]}"; do
    echo "Trying port $PORT..."
    $SERVER_CMD $PORT >/dev/null 2>&1 &
    PID=$!

    # wait a second to see if server stays up
    sleep 2
    if ps -p $PID >/dev/null 2>&1; then
        echo "✅ Server started on http://localhost:$PORT"
        wait $PID
        exit 0
    else
        echo "❌ Port $PORT failed, trying next..."
    fi
done

echo "[✖] Server failed to start on all tried ports: ${PORTS[*]}"
exit 1
