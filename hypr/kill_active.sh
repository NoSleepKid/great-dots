#!/bin/bash
# Get active window PID
pid=$(hyprctl activewindow -j | jq -r '.pid')

# Brutally kill it and all children
if [[ -n "$pid" && "$pid" != "null" ]]; then
    # Kill the main PID and all descendants
    pkill -9 -P "$pid" 2>/dev/null
    kill -9 "$pid" 2>/dev/null
fi
