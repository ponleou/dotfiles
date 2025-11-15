#!/bin/bash

script_dir="$(dirname "$(realpath "$0")")" # directory of where the script is

# save static settings.json to .build
# jq '."workbench.colorTheme" = "" | ."catppuccin.accentColor" = ""' "$script_dir/settings.json" > "$script_dir/settings.json.build"