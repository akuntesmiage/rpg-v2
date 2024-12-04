#!/bin/bash
# start.sh

while true; do
    echo "Starting the app..."
    node start.js
    echo "App crashed with exit code: $?. Restarting..." # Optional logging
    sleep 5 # Add a short delay before restarting
done
