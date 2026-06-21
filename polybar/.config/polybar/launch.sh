#!/usr/bin/env bash
# Tray is enabled only on the primary monitor via POLY_MODULES_RIGHT.
set -u

CONFIG="$HOME/.config/polybar/config.ini"

# Stop any running bars and wait for them to die.
polybar-msg cmd quit >/dev/null 2>&1 || killall -q polybar
while pgrep -u "$UID" -x polybar >/dev/null; do sleep 0.2; done

# `polybar -m` prints lines like "HDMI-0:1920x1080+1920+0 (primary)".
primary="$(polybar -m 2>/dev/null | awk -F: '/\(primary\)/ {print $1; exit}')"

while IFS= read -r line; do
  [ -z "$line" ] && continue
  mon="${line%%:*}"
  if [ "$mon" = "$primary" ]; then
    POLY_MODULES_RIGHT="pulseaudio mic network filesystem memory cpu date powermenu systray"
  else
    POLY_MODULES_RIGHT="pulseaudio mic network filesystem memory cpu date powermenu"
  fi
  MONITOR="$mon" POLY_MODULES_RIGHT="$POLY_MODULES_RIGHT" polybar --reload --config="$CONFIG" main >/dev/null 2>&1 &
done < <(polybar -m 2>/dev/null)

echo "polybar launched on: $(polybar -m 2>/dev/null | sed 's/:.*//' | paste -sd' ')"
