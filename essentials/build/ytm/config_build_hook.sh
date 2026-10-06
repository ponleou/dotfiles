#!/bin/bash

script_dir="$(dirname "$(realpath "$0")")" # directory of where the script is

output=$(jq 'del(."window-size", ."window-maximized", ."window-position", ."url") | .options.themes = [""] | .plugins."precise-volume".savedVolume = 0' "$script_dir/config.json")

if [ $? -eq 0 ]; then
    echo "$output" > "$script_dir/config.json.build"
fi
