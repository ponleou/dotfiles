#!/bin/bash

script_dir="$(dirname "$(realpath "$0")")" # directory of where the script is

cp $1 $script_dir/../wallpapers/

filename=$(basename $1)
echo "output * bg wallpapers/$filename fill" > $script_dir/../wallpaper