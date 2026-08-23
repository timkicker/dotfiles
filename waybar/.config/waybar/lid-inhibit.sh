#!/usr/bin/env bash
# lid-inhibit.sh — Waybar toggle: Suspend beim Zuklappen an/aus.
#
# Hält einen User-Space-systemd-inhibit-Lock auf handle-lid-switch im block-Modus.
# logind respektiert handle-lid-switch-Locks immer -> Zuklappen suspendiert nicht,
# solange der Lock läuft. Kein Root, kein Session-Teardown, nested compositors bleiben.
#
#   --toggle   Lock an/aus schalten und Waybar refreshen (SIGRTMIN+8)
#   --status   JSON-State für das Waybar-Modul ausgeben
set -euo pipefail

UNIT="lid-inhibit.service"

# Nerd-Font-Glyphen als bash-ANSI-C-Escapes (direkt getippt gehen sie verloren):
ICON_ACTIVE=$''      # nf-fa-sun  = bleibt wach (aktiv)
ICON_INACTIVE=$''    # nf-fa-moon = schläft beim Zuklappen

is_active() {
    systemctl --user is-active --quiet "$UNIT"
}

start_lock() {
    # Transienter User-Service (returnt sofort, läuft im Hintergrund).
    systemd-run --user --unit="${UNIT%.service}" \
        --description="waybar lid suspend inhibitor" \
        systemd-inhibit \
            --what=handle-lid-switch:sleep \
            --who="waybar-lid-toggle" \
            --why="keep running with lid closed" \
            --mode=block \
            sleep infinity >/dev/null 2>&1
}

stop_lock() {
    systemctl --user stop "$UNIT" >/dev/null 2>&1 || true
}

case "${1:---status}" in
    --toggle)
        if is_active; then
            stop_lock
        else
            start_lock
        fi
        # Waybar-Modul (signal: 8) sofort neu zeichnen lassen
        pkill -RTMIN+8 waybar 2>/dev/null || true
        ;;
    --status)
        if is_active; then
            printf '{"text":"%s","alt":"active","class":"active","tooltip":"Lid-Suspend blockiert – Laptop bleibt beim Zuklappen an"}\n' "$ICON_ACTIVE"
        else
            printf '{"text":"%s","alt":"inactive","class":"inactive","tooltip":"Normal – Laptop suspendet beim Zuklappen"}\n' "$ICON_INACTIVE"
        fi
        ;;
    *)
        echo "usage: $0 [--toggle|--status]" >&2
        exit 2
        ;;
esac
