#!/bin/bash

script_dir="$(dirname "$(realpath "$0")")" # directory of where the script is

# save static settings.json to .build
output=$(jq '."workbench.colorTheme" = "" | ."catppuccin.accentColor" = ""' "$script_dir/settings.json")

if [ $? -eq 0 ]; then
    echo "$output" > "$script_dir/settings.json.build"
fi