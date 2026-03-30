#!/bin/bash

options="⏻ Shutdown\n Reboot\n󰍃 Logout\n󰌾 Lock"

choice=$(echo -e "$options" | rofi -dmenu -i -p "Power" -show-icons)

case "$choice" in
    *Shutdown*) systemctl poweroff ;;
    *Reboot*) systemctl reboot ;;
    *Logout*) hyprctl dispatch exit ;;
    *Lock*) hyprlock ;;
esac
