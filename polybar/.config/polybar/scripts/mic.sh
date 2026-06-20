#!/usr/bin/env bash
# Print mic icon + state for the polybar `mic` module.
set -u

if ! command -v pactl >/dev/null 2>&1; then
  printf 'n/a'
  exit 0
fi

muted="$(pactl get-source-mute @DEFAULT_SOURCE@ 2>/dev/null | awk '{print $2}')"

if [ "$muted" = "yes" ]; then
  printf 'off'
else
  printf 'on'
fi
