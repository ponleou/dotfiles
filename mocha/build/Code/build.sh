#!/bin/bash

script_dir="$(dirname "$(realpath "$0")")" # directory of where the script is
sed -i --follow-symlinks "s/\"workbench.colorTheme\": \"[^\"]*\"/\"workbench.colorTheme\": \"Catppuccin Mcha\"/" $script_dir/settings.json
sed -i --follow-symlinks "s/\"catppuccin.accentColor\": \"[^\"]*\"/\"catppuccin.accentColor\": \"$accent\"/" $script_dir/settings.json