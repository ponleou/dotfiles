#!/bin/bash

script_dir="$(dirname "$(realpath "$0")")" # directory of where the script is

cat $script_dir/config.json.build > $script_dir/config.json


ln -sf $script_dir/config_build_hook.sh $script_dir/../../../stow-scripts/hooks/ytm_build_essentials.sh