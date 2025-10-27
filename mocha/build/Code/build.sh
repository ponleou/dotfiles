#!/bin/bash

script_dir="$(dirname "$(realpath "$0")")" # directory of where the script is
sed -i --follow-symlinks "s/\"workbench.colorTheme\": \"[^\"]*\"/\"workbench.colorTheme\": \"Catppuccin Mocha\"/" $script_dir/settings.json
sed -i --follow-symlinks "s/\"catppuccin.accentColor\": \"[^\"]*\"/\"catppuccin.accentColor\": \"$expbuild_accent\"/" $script_dir/settings.json