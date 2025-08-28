#!/data/data/com.termux/files/usr/bin/bash
# ultimate_safe_start_dta.sh
# Safe starter for DivineTruthAscension

PORTS=(9000 9100 9200 9300 9400)
SERVER_SCRIPT="./ultimate_start_dta.sh"

echo "🔎 Checking and freeing ports if needed..."

for PORT in "${PORTS[@]}"; do
    # Find PIDs using this port
    PIDS=$(python3 - <<END
import psutil
port = $PORT
pids = []
for proc in psutil.process_iter(['pid']):
    try:
        for conn in proc.connections(kind='inet'):
            if conn.laddr.port == port:
                pids.append(proc.info['pid'])
    except Exception:
        pass
print(" ".join(map(str, pids)))
END
)
    if [ -n "$PIDS" ]; then
        echo "⚠️ Port $PORT in use by PID(s): $PIDS. Killing..."
        for PID in $PIDS; do
            kill -9 $PID 2>/dev/null
        done
        echo "✅ Freed port $PORT"
    else
        echo "✅ Port $PORT is free"
    fi
done

echo "🚀 Starting DivineTruthAscension server..."
if [ -f "$SERVER_SCRIPT" ]; then
    $SERVER_SCRIPT start
else
    echo "❌ Server script $SERVER_SCRIPT not found!"
fi
