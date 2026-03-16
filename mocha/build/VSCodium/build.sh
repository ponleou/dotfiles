#!/bin/bash

# variables with "expbuild_" prefix are exported variables by the build function when called

script_dir="$(dirname "$(realpath "$0")")" # directory of where the script is

# modify the settings.json
output=$(jq '."workbench.colorTheme" = "Catppuccin Mocha" | ."catppuccin.accentColor" = "'"$expbuild_accent"'"' "$script_dir/settings.json.build")

if [ $? -eq 0 ]; then
    echo "$output" > "$script_dir/settings.json"
else
    error=$(jq '."workbench.colorTheme" = "Catppuccin Mocha" | ."catppuccin.accentColor" = "'"$expbuild_accent"'"' "$script_dir/settings.json.build" 2>&1)
    echo "Unexpected error while building VSCodium: $error"
fi
