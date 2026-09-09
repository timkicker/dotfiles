#!/usr/bin/env bash
# Wetter Helsinki via wttr.in für Waybar. Nerd-Font-Wetterglyph (kein Farb-Emoji) + Temp.
export PATH="/usr/bin:$PATH"

data=$(timeout 12 curl -sf 'https://wttr.in/Helsinki?format=%C|%t|%f|%h|%w|%p' 2>/dev/null)
if [ -z "$data" ]; then echo '{"text":"","tooltip":"Wetter n/a"}'; exit 0; fi
IFS='|' read -r cond temp feels hum wind precip <<<"$data"
cond_lc=$(printf '%s' "$cond" | tr '[:upper:]' '[:lower:]')

# Bedingung -> Nerd-Font-Wetterglyph (nf-weather, BMP e3xx)
case "$cond_lc" in
  *thunder*|*storm*)                 ic=$'' ;;
  *snow*|*sleet*|*blizzard*|*ice*)   ic=$'' ;;
  *rain*|*drizzle*|*shower*)         ic=$'' ;;
  *fog*|*mist*|*haze*|*smoke*)       ic=$'' ;;
  *overcast*|*cloudy*)               ic=$'' ;;
  *partly*|*cloud*)                  ic=$'' ;;
  *sunny*|*clear*)                   ic=$'' ;;
  *)                                 ic=$'' ;;   # na/unknown
esac

temp=$(printf '%s' "$temp" | tr -d ' ')
tip="Helsinki: ${cond}, ${temp} (gefühlt ${feels// /}), ${hum// /} Luftf., Wind ${wind// /}, ${precip// /} Regen"
tip=$(printf '%s' "$tip" | sed 's/"/\\"/g')
printf '{"text":"%s %s","class":"weather","tooltip":"%s"}\n' "$ic" "$temp" "$tip"
