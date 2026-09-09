#!/usr/bin/env bash
# fw-fanctrl-Status für Waybar; Klick cycelt die Strategie. Farbe/Icon je Strategie.
export PATH="$HOME/.local/bin:/usr/bin:$PATH"
STRATS=(lazy laziest medium)

cur=$(fw-fanctrl print current 2>/dev/null | awk -F"'" '/in use/{print $2; exit}')
[ -z "$cur" ] && cur=$(fw-fanctrl print current 2>/dev/null | tr -d "'" | awk '/use/{print $NF; exit}')

if [ "$1" = "cycle" ]; then
  idx=0; for i in "${!STRATS[@]}"; do [ "${STRATS[$i]}" = "$cur" ] && idx=$i; done
  next=${STRATS[$(( (idx + 1) % ${#STRATS[@]} ))]}
  fw-fanctrl use "$next" >/dev/null 2>&1
  pkill -RTMIN+9 waybar 2>/dev/null
  exit 0
fi

icon=$'\U000f0210'   # nf-md-fan
case "$cur" in
  laziest) cls="quiet"   ;;   # leise (grün)
  lazy)    cls="normal"  ;;
  medium|agile|very-agile) cls="loud" ;;   # laut (orange)
  *)       cls="normal"  ;;
esac
printf '{"text":"%s","class":"%s","tooltip":"Lüfter: %s\\nKlick → nächste Strategie"}\n' \
  "$icon" "$cls" "${cur:-?}"
