#!/usr/bin/env bash

OUTPUT=$(xrandr --query | grep '^DP-[0-9] connected' | awk '{print $1}')

if [ -n "${OUTPUT}" ]; then
    xrandr --output "${OUTPUT}" --left-of eDP-1 --auto
    feh --bg-fill ~/pictures/wallpapers/Landscape-night-sky-mountain-wallpapers-1920x1200.jpg \
        ~/pictures/wallpapers/lake-sky-2560x1080.jpg
else
    for OUTPUT in $(xrandr --query | grep '^DP-[0-9] disconnected' | awk '{print $1}'); do
        xrandr --output $OUTPUT --off
    done
    feh --bg-fill ~/pictures/wallpapers/Landscape-night-sky-mountain-wallpapers-1920x1200.jpg
fi
