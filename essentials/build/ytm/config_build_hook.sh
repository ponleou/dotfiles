#!/bin/bash

script_dir="$(dirname "$(realpath "$0")")" # directory of where the script is

jq 'del(."window-size", ."window-maximized", ."window-position", ."url") | .options.themes = [""]' config.json > config.json.build