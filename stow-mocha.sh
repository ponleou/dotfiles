#!/bin/bash

accents=("peach" "yellow")

mocha_packages="btop konsole ghostwriter nwg-look qt6ct swaylock rofi swaync waybar wlogout"
mocha_bases="sway-base vesktop-base"

accent_packages="nwg-look qt6ct ytm zen"
accent_options="rofi-option swaync-option waybar-option wlogout-option sway-option vesktop-option"

build_packages="Code"

# parse flags
valid_accent=0
enable_blur=0

for accent in "${accents[@]}"; do
  if [[ "$1" == "$accent" ]]; then
    valid_accent=1
    break
  fi
done

if [[ "$2" == "blur" ]]; then
  enable_blur=1
fi

# run stows and scripts
script_dir="$(dirname "$(realpath "$0")")" # directory of where the script is

stow_accent() {
  local accent="$1"   # this is the variable after --dir=$script_dir/mocha/

  if [[ -f "$script_dir/settings/.current_accent" ]]; then
    local prev_accent=$(cat "$script_dir/settings/.current_accent")
    stow -D --dir="$script_dir/mocha/$prev_accent" --target="$HOME" $accent_packages
    stow -D --dir="$script_dir/mocha/$prev_accent" --target="$script_dir/mocha/options" $accent_options
  fi

  stow --dir="$script_dir/mocha/$accent" --target="$HOME" $accent_packages
  stow --dir="$script_dir/mocha/$accent" --target="$script_dir/mocha/options" $accent_options

  echo $accent > "$script_dir/settings/.current_accent"

  papirus-folders -C cat-mocha-$accent > /dev/null 2>&1
}

stow_mods() {
  local settings_prefix=".current_mod_"

  while [[ $# -gt 0 ]]; do
    local flag="${1##-}"

    if [[ -f "$script_dir/settings/$settings_prefix$flag" ]]; then
      local prev=$(cat "$script_dir/settings/$settings_prefix$flag")
      stow -D --dir=$script_dir/mocha/modlist/$flag --target=$script_dir/mocha/mods "$prev"
    fi

    stow --dir=$script_dir/mocha/modlist/$flag --target=$script_dir/mocha/mods "$2"

    echo $2 > $script_dir/settings/$settings_prefix$flag

    shift 2
  done

  if [[ -f "$script_dir/settings/.current_accent" ]]; then
    local prev_background=$(cat "$script_dir/settings/.current_mod_background")
    local prev_fx=$(cat "$script_dir/settings/.current_mod_fx")

    stow -D --dir=$script_dir/mocha/modlist/background --target=$script_dir/mocha/mods "$prev_background"
    stow -D --dir=$script_dir/mocha/modlist/fx --target=$script_dir/mocha/mods "$prev_fx"
  fi

  if [[ $enable_blur == 1 ]]; then
    stow --dir=$script_dir/mocha/modlist/background --target=$script_dir/mocha/mods transparent
    stow --dir=$script_dir/mocha/modlist/fx --target=$script_dir/mocha/mods blur

    echo transparent > "$script_dir/settings/.current_mod_background"
    echo blur > "$script_dir/settings/.current_mod_fx"
  else 
    stow --dir=$script_dir/mocha/modlist/background --target=$script_dir/mocha/mods default
    stow --dir=$script_dir/mocha/modlist/fx --target=$script_dir/mocha/mods default

    echo default > "$script_dir/settings/.current_mod_background"
    echo default > "$script_dir/settings/.current_mod_fx"
  fi
}

build() {
  export expbuild_accent=$accent

  for package in "$@"; do
    bash "$script_dir/mocha/build/$package/build.sh"
  done
}

stow --dir=$script_dir/mocha/base --target=$HOME $mocha_packages
stow --dir=$script_dir/mocha/base --target=$script_dir/essentials/bases $mocha_bases

if [[ $valid_accent == 1 ]]; then
  accent=$1
else
  echo "Accent not found, fallback to default accent ${accents[0]}"
  accent=${accents[0]}
fi

stow_accent $accent
stow_mods "${@:2}"

build $build_packages

swaymsg reload
swaync-client --reload-css >/dev/null 2>&1
nwg-look -a > /dev/null 2>&1


