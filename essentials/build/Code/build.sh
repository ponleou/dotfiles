#!/bin/bash

script_dir="$(dirname "$(realpath "$0")")" # directory of where the script is

cat $script_dir/settings.json.build > $script_dir/settings.json