#!/bin/bash

packages="easyeffects GIMP mpv omz dolphin sway vesktop zen Code VSCodium ytm nvim"
build_packages="Code VSCodium ytm"

script_dir="$(dirname "$(realpath "$0")")" # directory of where the script is

build() {
  for package in "$@"; do
    bash "$script_dir/essentials/build/$package/build.sh"
  done
}

stow -D --dir=$script_dir/essentials --target=$HOME $packages

stow --dir=$script_dir/essentials --target=$HOME $packages
build $build_packages