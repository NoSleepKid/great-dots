#!/bin/bash

# Initialize the cache folder with clean baseline images on startup
MONITOR_NAME=$(hyprctl monitors -j | jq -r '.[] | select(.focused == true) | .name')
if command -v grim &>/dev/null && [ -n "$MONITOR_NAME" ]; then
    grim -o "$MONITOR_NAME" /tmp/rofi-slices/default_bg.png &>/dev/null
fi

# Connect to Hyprland's event pipe
socat -U - UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock | while read -r line; do
    # Trigger on workspace change events
    if [[ "$line" =~ ^workspace\>\>([0-9]+) ]]; then
        PREV_WS=$(hyprctl workspaces -j | jq -r '.[] | select(.id != '"${BASH_REMATCH[1]}"') | .id' | tail -n 1)
        ACTIVE_MON=$(hyprctl monitors -j | jq -r '.[] | select(.focused == true) | .name')
        
        # Silently log the visual state of the workspace we just walked away from
        if [ -n "$PREV_WS" ] && [ -n "$ACTIVE_MON" ]; then
            grim -o "$ACTIVE_MON" "/tmp/rofi-slices/ws_${PREV_WS}.png" &>/dev/null
        fi
    fi
done
