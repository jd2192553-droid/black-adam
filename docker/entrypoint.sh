#!/usr/bin/env bash

# Start the Flask API
python3 /opt/pentest_api/api.py &
API_PID=$!

# Start a simple static file server for the dashboard (using Python)
cd /var/www/html
python3 -m http.server 8080 &
WEB_PID=$!

# Wait for both processes (allows Docker to keep container alive)
wait $API_PID $WEB_PID
