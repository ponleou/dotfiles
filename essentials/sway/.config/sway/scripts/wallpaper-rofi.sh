#!/bin/bash

script_dir="$(dirname "$(realpath "$0")")" # directory of where the script is
file_path=$(rofi -theme wallpaper-file-browser.rasi -display-file-browser-extended " wallpaper" -show file-browser-extended -file-browser-hide-parent -file-browser-only-files -file-browser-cmd 'echo' -file-browser-dir ~/.config/sway/wallpapers)

wallpapers_dir="$script_dir/../wallpapers/"
file_name=$(basename "$file_path")


if [ "$file_path" ]; then
    cp "$file_path" $wallpapers_dir
    echo "output * bg 'wallpapers/$file_name' fill" > $script_dir/../wallpaper
    swaymsg reload
fi