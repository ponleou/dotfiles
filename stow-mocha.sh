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
    local files=$(ls -1 "$script_dir/moca/accents/")
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


valid_accent=0

for accent in "${accents[@]}"; do
  if [[ "$1" == "$accent" ]]; then
    valid_accent=1
    break
  fi
done

# functions
stow_accent() {
  local accent="$1"   # this is the variable after --dir=$script_dir/mocha/

  if [[ -f "$script_dir/settings/.current_accent" ]]; then
    local prev_accent=$(cat "$script_dir/settings/.current_accent")
    stow -D --dir="$script_dir/mocha/accents/$prev_accent" --target="$HOME" $accent_packages
    stow -D --dir="$script_dir/mocha/accents/$prev_accent" --target="$script_dir/mocha/options" $accent_options
  fi

  stow --dir="$script_dir/mocha/accents/$accent" --target="$HOME" $accent_packages
  stow --dir="$script_dir/mocha/accents/$accent" --target="$script_dir/mocha/options" $accent_options

  echo $accent > "$script_dir/settings/.current_accent"

  papirus-folders -C cat-mocha-$accent > /dev/null 2>&1
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
  # verifying accent
  if [[ $valid_accent == 1 ]]; then
    accent=$1
  else
    echo "Accent not found, fallback to default accent ${accents[0]}"
    accent=${accents[0]}
  fi

  # base
  stow --dir=$script_dir/mocha/base --target=$HOME $mocha_packages
  stow --dir=$script_dir/mocha/base --target=$script_dir/essentials/bases $mocha_bases

  # accent and mods
  stow_accent $accent
  stow_mods "${@:2}"

  # build
  build $build_packages

  # update theme
  swaymsg reload
  swaync-client --reload-css >/dev/null 2>&1
  nwg-look -a > /dev/null 2>&1
}

main "$@"