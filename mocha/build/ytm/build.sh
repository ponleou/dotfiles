#!/bin/bash

# variables with "expbuild_" prefix are exported variables by the build function when called

script_dir="$(dirname "$(realpath "$0")")" # directory of where the script is
output=$(jq '.options.themes = ["'"$HOME"'/.config/YouTube Music/mocha.css"]' "$script_dir/config.json.build")

if [ $? -eq 0 ]; then
    echo "$output" > "$script_dir/config.json"
else
    error=$(jq '.options.themes = ["'"$HOME"'/.config/YouTube Music/mocha.css"]' "$script_dir/config.json.build")
    echo "Error $script_dir/$0: $error"
fi
