#!/bin/bash
DESKTOP_DIR="$HOME/Desktop"
MODULES=""
CONFIG_CONTENT=""
get_icon_path() {
    local icon_name=$1
    if [[ "$icon_name" == /* ]]; then echo "$icon_name"
    else find /usr/share/icons ~/.local/share/icons -name "$icon_name.svg" -o -name "$icon_name.png" | head -n 1; fi
}
echo "{" > ~/.config/waybar/dock_modules.json
echo "    \"modules-center\": [" >> ~/.config/waybar/dock_modules.json
FILES=("$DESKTOP_DIR"/*.desktop)
VALID_FILES=()
for FILE in "${FILES[@]}"; do
    [ -e "$FILE" ] || continue
    grep -q "^Icon=" "$FILE" || continue
    VALID_FILES+=("$FILE")
done
for i in "${!VALID_FILES[@]}"; do
    FILE="${VALID_FILES[$i]}"
    FILENAME=$(basename "$FILE" .desktop)
    NAME=$(grep "^Name=" "$FILE" | head -1 | cut -d'=' -f2)
    ICON_NAME=$(grep "^Icon=" "$FILE" | head -1 | cut -d'=' -f2)
    FULL_ICON_PATH=$(get_icon_path "$ICON_NAME")
    [ -z "$FULL_ICON_PATH" ] && FULL_ICON_PATH="/usr/share/icons/hicolor/scalable/apps/system-run.svg"
    MODULES+="\"image#app_$i\""
    if [ $i -lt $((${#VALID_FILES[@]} - 1)) ]; then MODULES+=", "; fi
    CONFIG_CONTENT+="    \"image#app_$i\": { \"path\": \"$FULL_ICON_PATH\", \"size\": 42, \"on-click\": \"gtk-launch $FILENAME\", \"tooltip\": true, \"tooltip-format\": \"$NAME\" },"
done
echo "        $MODULES" >> ~/.config/waybar/dock_modules.json
echo "    ]," >> ~/.config/waybar/dock_modules.json
echo -e "${CONFIG_CONTENT%,}" >> ~/.config/waybar/dock_modules.json
echo "}" >> ~/.config/waybar/dock_modules.json
