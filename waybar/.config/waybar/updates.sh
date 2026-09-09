#!/usr/bin/env bash
# Ausstehende Updates (Repo + AUR) für Waybar. Klick öffnet yay -Syu.
export PATH="$HOME/.local/bin:/usr/bin:$PATH"
repo=$(timeout 40 checkupdates 2>/dev/null | wc -l)
aur=$(timeout 40 yay -Qua 2>/dev/null | wc -l)
total=$(( repo + aur ))

icon=$''   # nf-fa-refresh
if [ "$total" -eq 0 ]; then
  printf '{"text":"","class":"updated","tooltip":"System aktuell"}\n'
else
  cls="pending"; [ "$total" -ge 50 ] && cls="many"
  printf '{"text":"%s %d","class":"%s","tooltip":"%d Updates — %d Repo, %d AUR\\nKlick → yay -Syu"}\n' \
    "$icon" "$total" "$cls" "$total" "$repo" "$aur"
fi
