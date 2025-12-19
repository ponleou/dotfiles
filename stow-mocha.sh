#!/bin/bash

accents=("peach" "yellow" "sapphire" "mauve" "green" "rosewater")

mocha_packages="btop konsole ghostwriter nwg-look qt6ct swaylock rofi swaync waybar wlogout"
mocha_bases="sway-base vesktop-base"

accent_packages="nwg-look qt6ct ytm zen"
accent_options="rofi-option swaync-option waybar-option wlogout-option sway-option vesktop-option"

build_packages="Code VSCodium ytm"

script_dir="$(dirname "$(realpath "$0")")" # directory of where the script is

# parse flags
validate_accent() {
  local accent="$1"

  if [[ ! -d "$script_dir/mocha/accents/$accent" ]]; then
    echo "Error: Unknown accent '$1'. Available accents:" >&2
    local files=$(ls -1 "$script_dir/mocha/accents/")
    echo "$files" >&2
    exit 1
  fi
}

validate_mods() {
  while [[ $# -gt 0 ]]; do
    local flag="${1##-}"
    local value="$2"

    if [[ $# -lt 2 ]]; then
      echo "Error: Flag '$1' requires a value" >&2
      exit 2
    fi

    if [[ ! -d "$script_dir/mocha/modlist/$flag" ]]; then
      echo "Error: Unknown mod '$flag'. Available mods:" >&2
      local files=$(ls -1 "$script_dir/mocha/modlist/")
      echo "$files" >&2
      exit 2
    fi

    if [[ ! -d "$script_dir/mocha/modlist/$flag/$value" ]]; then
      echo "Error: Invalid option '$value' for mod '$flag'. Available options:" >&2
      local files=$(ls -1 "$script_dir/mocha/modlist/$flag/")
      echo "$files" >&2
      exit 2
    fi

    shift 2
  done
}

# functions
stow_base() {
  local settings_file=".current_theme"
  local settings_file_path="$script_dir/settings/$settings_file"

  if [[ -f "$settings_file_path" ]]; then
    local prev_theme=$(cat "$settings_file_path")
    stow -D --dir=$script_dir/$prev_theme/base --target=$HOME $mocha_packages
    stow -D --dir=$script_dir/$prev_theme/base --target=$script_dir/essentials/bases $mocha_bases
  fi

  stow --dir=$script_dir/mocha/base --target=$HOME $mocha_packages
  stow --dir=$script_dir/mocha/base --target=$script_dir/essentials/bases $mocha_bases

  echo "mocha" > "$settings_file_path"
}

stow_accent() {
  local settings_file=".current_accent"
  local settings_file_path="$script_dir/settings/$settings_file"
  local accent="$1"   # this is the variable after --dir=$script_dir/mocha/

  if [[ -f "$settings_file_path" ]]; then
    local prev_accent=$(cat "$settings_file_path")
    stow -D --dir="$script_dir/mocha/accents/$prev_accent" --target="$HOME" $accent_packages
    stow -D --dir="$script_dir/mocha/accents/$prev_accent" --target="$script_dir/mocha/options" $accent_options
  fi

  stow --dir="$script_dir/mocha/accents/$accent" --target="$HOME" $accent_packages
  stow --dir="$script_dir/mocha/accents/$accent" --target="$script_dir/mocha/options" $accent_options

  papirus-folders -C cat-mocha-$accent > /dev/null 2>&1

  echo $accent > "$settings_file_path"
}

stow_mods() {
  local settings_prefix=".current_mod_"

  while [[ $# -gt 0 ]]; do
    local flag="${1##-}"
    local value="$2"

    if [[ -f "$script_dir/settings/$settings_prefix$flag" ]]; then
      local prev=$(cat "$script_dir/settings/$settings_prefix$flag")
      stow -D --dir=$script_dir/mocha/modlist/$flag --target=$script_dir/mocha/mods "$prev"
    fi

    stow --dir=$script_dir/mocha/modlist/$flag --target=$script_dir/mocha/mods "$value"

    echo $value > $script_dir/settings/$settings_prefix$flag

    shift 2
  done
}

build() {
  export expbuild_accent=$accent

  for package in "$@"; do
    bash "$script_dir/mocha/build/$package/build.sh"
  done
}

main() {
  accent=$1
  flags=${@:2}

  # verify arguments
  validate_accent $accent
  validate_mods $flags

  # base, accent and mods
  stow_base
  stow_accent $accent
  stow_mods $flags

  # build
  build $build_packages

  # update theme
  swaymsg reload
  swaync-client --reload-css >/dev/null 2>&1
  nwg-look -a > /dev/null 2>&1
}

main "$@"