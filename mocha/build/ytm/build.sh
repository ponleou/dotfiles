#!/bin/bash

# variables with "expbuild_" prefix are exported variables by the build function when called

script_dir="$(dirname "$(realpath "$0")")" # directory of where the script is
jq '.options.themes = ["'"$HOME"'/.config/YouTube Music/mocha.css"]' "$script_dir/config.json" | sponge "$script_dir/config.json"