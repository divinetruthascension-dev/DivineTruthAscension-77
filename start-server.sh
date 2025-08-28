#!/bin/bash

# Directory of your PWA
PWA_DIR=~/divinetruthascension
PORT=8080

# Kill any process using port 8080
fuser -k $PORT/tcp 2>/dev/null

# Go to PWA directory
cd $PWA_DIR || { echo "[✖] Directory not found: $PWA_DIR"; exit 1; }

# Start Python HTTP server in background quietly
nohup python3 -m http.server $PORT &>/dev/null &

# Confirm server is running
sleep 1
if lsof -i :$PORT | grep python3 >/dev/null; then
    echo "[✔] Server running at http://localhost:$PORT"
else
    echo "[✖] Server failed to start"
fi
