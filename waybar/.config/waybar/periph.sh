#!/usr/bin/env bash
# Logitech-Peripherie-Akkus (Tastatur/Maus) für Waybar. Zeigt niedrigsten Stand + Icon.
export PATH="/usr/bin:$PATH"
low=101; tip=""
while IFS= read -r dev; do
  info=$(upower -i "$dev" 2>/dev/null)
  model=$(printf '%s\n' "$info" | awk -F: '/model/{gsub(/^[ \t]+/,"",$2);print $2;exit}')
  pct=$(printf '%s\n' "$info" | awk -F: '/percentage/{gsub(/[^0-9]/,"",$2);print $2;exit}')
  st=$(printf '%s\n'  "$info" | awk -F: '/state/{gsub(/^[ \t]+/,"",$2);print $2;exit}')
  [ -z "$pct" ] && continue
  # "should be ignored"-geräte (fully-charged Fake-100%) trotzdem anzeigen, aber nicht als low werten
  tip="${tip}${model:-?}: ${pct}% (${st})\\n"
  case "$st" in fully-charged|charging) : ;; *) [ "$pct" -lt "$low" ] && low=$pct ;; esac
done < <(upower -e 2>/dev/null | grep -iE 'hidpp|logitech')

if [ -z "$tip" ]; then echo '{"text":"","tooltip":""}'; exit 0; fi
[ "$low" -gt 100 ] && low=$(printf '%s' "$tip" | grep -oE '[0-9]+%' | head -1 | tr -d '%')

icon=$''   # nf-fa-keyboard
cls="ok"; [ "${low:-100}" -le 20 ] && cls="warning"; [ "${low:-100}" -le 10 ] && cls="critical"
printf '{"text":"%s %s%%","class":"%s","tooltip":"%s"}\n' "$icon" "${low:-?}" "$cls" "${tip%\\n}"
