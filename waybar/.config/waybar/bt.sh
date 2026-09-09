#!/usr/bin/env bash
# Bluetooth-Status für Waybar — crash-sicher via bluetoothctl (kein natives DBus-Modul,
# das die ganze Bar mitreißt, wenn BlueZ zickt). Fehler => leerer/neutraler Output.
export PATH="/usr/bin:$PATH"
icon=$'\uf293'   # nf-fa-bluetooth

show=$(timeout 3 bluetoothctl show 2>/dev/null)
powered=$(printf '%s\n' "$show" | awk '/Powered:/{print $2; exit}')
if [ -z "$show" ] || [ "$powered" = "no" ]; then
  printf '{"text":"%s","class":"off","tooltip":"Bluetooth aus/nicht bereit"}\n' "$icon"
  exit 0
fi

con=$(timeout 3 bluetoothctl devices Connected 2>/dev/null | sed 's/^Device [0-9A-F:]* //')
n=$(printf '%s' "$con" | grep -c .)
if [ "$n" -eq 0 ]; then
  printf '{"text":"%s","class":"on","tooltip":"Bluetooth an, nichts verbunden"}\n' "$icon"
else
  tip=$(printf '%s' "$con" | sed ':a;N;$!ba;s/\n/\\n/g; s/"/\\"/g')
  printf '{"text":"%s %d","class":"connected","tooltip":"Verbunden:\\n%s"}\n' "$icon" "$n" "$tip"
fi
