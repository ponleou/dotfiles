#!/bin/bash

script_dir="$(dirname "$(realpath "$0")")" # directory of where the script is
wallpapers_dir="$script_dir/../wallpapers/"
filename=$(basename $1)

cp $1 $wallpapers_dir
echo "output * bg wallpapers/$filename fill" > $script_dir/../wallpaper