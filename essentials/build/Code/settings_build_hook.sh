#!/bin/bash

script_dir="$(dirname "$(realpath "$0")")" # directory of where the script is

# save static settings.json to .build
static=$(sed "s/\"workbench.colorTheme\": \"[^\"]*\"/\"workbench.colorTheme\": \"\"/; s/\"catppuccin.accentColor\": \"[^\"]*\"/\"catppuccin.accentColor\": \"\"/" "$script_dir/settings.json")
echo "$static" > "$script_dir/settings.json.build"