#!/bin/bash

script_dir="$(dirname "$(realpath "$0")")" # directory of where the script is
sed -i "s/\"workbench.colorTheme\": \"[^\"]*\"/\"workbench.colorTheme\": \"Catppuccin Mcha\"/" $script_dir/settings.json
sed -i "s/\"catppuccin.accentColor\": \"[^\"]*\"/\"catppuccin.accentColor\": \"$accent\"/" $script_dir/settings.json