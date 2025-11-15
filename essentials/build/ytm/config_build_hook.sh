#!/bin/bash

script_dir="$(dirname "$(realpath "$0")")" # directory of where the script is

jq 'del(."window-size", ."window-maximized", ."window-position", ."url") | .options.themes = [""] | .plugins."precise-volume".savedVolume = 0' "$script_dir/config.json" > "$script_dir/config.json.build"