#!/usr/bin/env bash

OUTPUT=$(xrandr --query | grep '^DP-[0-9] connected' | awk '{print $1}')

if [ -n "${OUTPUT}" ]; then
    xrandr --output "${OUTPUT}" --left-of eDP-1 --auto
else
    for OUTPUT in $(xrandr --query | grep '^DP-[0-9] disconnected' | awk '{print $1}'); do
        xrandr --output $OUTPUT --off
    done
fi

feh --bg-center ~/.config/i3/wallpaper.jpg
