#!/bin/bash

script_dir="$(dirname "$(realpath "$0")")" # directory of where the script is

build() {
  for package in "$@"; do
    bash "$script_dir/essentials/build/$package/build.sh"
  done
}

stow --dir=$script_dir/essentials --target=$HOME easyeffects GIMP mpv omz dolphin sway vesktop zen Code VSCodium
build Code VSCodium