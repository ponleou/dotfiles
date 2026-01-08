# Swayfx Dotfiles (Arch Linux and Catppuccin)

My personal rice for my Arch Linux + SwayFX machine based on Catppuccin color palette. Possibly overengineered for modularity in extensible color palettes, accents, and mods, with automatic git commit scripts and services. Feel free to take inspiration or copy for yourself.

## Screenshots

## Keybinds

## Additional Information

### Dependencies

-   nwg-look
-   catppuccin-gtk-theme-mocha
-   qt6ct-kde
-   papirus-folders-catppuccin-git
-   papirus-icon-theme
-   darkly
-   xdg-desktop-portal-gtk
-   moreutils

Fonts:

-   ttf-work-sans
-   ttf-fira-code
-   ttf-nerd-fonts-symbols
-   otf-font-awesome
-   woff2-font-awesome

Optional:

-   autotiling
-   gpu-screen-record
-   cliphist
-   oh-my-zsh
-   rofi-emoji
-   rofi-file-browser-extended-patched
-   rofi-calc

### Directory Structure

```
ROOT
├── essentials/
│   ├── bases/                                          # STOW TARGET—Stowed from [theme]'s BASE PACKAGES, extension files for essential's STOW PACKAGES
│   ├── build/                                          # Build scripts for dynamic configs
│   └── [package]/                                      # STOW PACKAGES—Stowed to $HOME, independent from themes
│
├── [theme] (e.g. mocha, latte)/
│   ├── base/
│   │   ├── [package]/                                  # STOW PACKAGES—Stowed to $HOME, standalone theme configs (doesn't require accent)
│   │   └── [*-base]/                                   # BASE PACKAGES—Stowed to essentials/bases/
│   │
│   ├── accents/
│   │   └── [accent] (e.g. yellow, peach, etc.)/
│   │       └── [package]/                              # STOW PACKAGES—Stowed to $HOME, dependent on accent
│   │       └── [*-option]/                             # OPTION PACKAGES—Stowed to [theme]/options/
│   │
│   ├── modlist/
│   │   └── [mods] (e.g. background)/
│   │       └── [mod-option]/
│   │           └── [mod-package]/
│   │               └── FILES                           # MOD FILES—Stowed to [theme]/mods/[mod-package]
│   │
│   ├── mods/
│   │   └── [mod-package]/
│   │       └── FILES                                   # STOW TARGET—Stowed from [theme]'s [mod-package]/FILES, are active mod symlinks
│   │
│   ├── options/                                        # STOW TARGET—Stowed from [theme]'s OPTION PACKAGES, extension files for [theme]
│   └── build/                                          # Build scripts for dynamic theme-dependent configs
│
├── script/                                             # Contains stow packages for personal scripts
├── service/                                            # Contains stow packages for personal systemd services
├── settings/                                           # Active config accents and mods
├── stow-scripts/                                       # Git automation scripts (used by pon-autocommit-stow systemd service)
└── tmp/                                                # Runtime temp files for automation scripts and services (pon-autocommit-stow)
```

### Notes:

-   Built config files, that are built with build scripts, contains a base template in \*.build
-   for Vesktop config packages, stow only owns the vesktop/settings/ directory
-   for YouTube Music config packages, stow only owns the "YouTube Music"/config.json and /[theme].css files
-   for Code config packages, stow only owns the Code/User/settings.json file (along with its \*.build file), and necessary extensions must be installed manually
