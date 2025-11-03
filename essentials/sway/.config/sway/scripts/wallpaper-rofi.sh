#!/bin/bash

file_path=$(rofi -theme fullscreen-preview.rasi -display-file-browser-extended " wallpaper" -show file-browser-extended -file-browser-hide-parent -file-browser-only-files -file-browser-cmd 'echo' -file-browser-dir ~/.config/sway/wallpapers)
script_dir="$(dirname "$(realpath "$0")")" # directory of where the script is
wallpapers_dir="$script_dir/../wallpapers/"
file_name=$(basename "$file_path")

echo $file_path

cp "$file_path" $wallpapers_dir
echo "output * bg 'wallpapers/$file_name' fill" > $script_dir/../wallpaper
swaymsg reload