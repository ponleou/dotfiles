#!/bin/bash

script_dir="$(dirname "$(realpath "$0")")" # directory of where the script is

cat $script_dir/settings.json.build > $script_dir/settings.json


ln -sf $script_dir/settings_build_hook.sh $script_dir/../../../service-scripts/hooks/Code_build_essentials.sh