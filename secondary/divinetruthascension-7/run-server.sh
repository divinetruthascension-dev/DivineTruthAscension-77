#!/bin/bash

# PWA folder
PWA_DIR=~/divinetruthascension
PORTS=(9000 9100 9200 9300 9400)

cd $PWA_DIR || { echo "[✖] Directory not found: $PWA_DIR"; exit 1; }

for PORT in "${PORTS[@]}"; do
    # Try to start server in background quietly
    nohup python3 -m http.server $PORT &>/dev/null &
    sleep 1
    # Check if server started
    if lsof -i :$PORT | grep python3 >/dev/null; then
        echo "[✔] Server running at http://localhost:$PORT"
        exit 0
    fi
done

echo "[✖] Server failed to start on all tried ports: ${PORTS[*]}"
