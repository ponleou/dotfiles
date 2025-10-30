# Dotfiles Architecture Documentation [AI GENERATED]

**DISCLAIMER**: 100% of this document is entirely AI generated. A manual rewrite will be made in the future.

## 📚 Table of Contents

1. [Overview](#overview)
2. [Directory Structure](#directory-structure)
3. [Symlink Architecture](#symlink-architecture)
4. [Folder Terminology](#folder-terminology)
5. [How It All Works Together](#how-it-all-works-together)
6. [Usage Examples](#usage-examples)

---

## Overview

This is a **modular, themeable dotfiles system** using **GNU Stow** for symlink management. The architecture supports:

-   Multiple color accents (peach, yellow)
-   Visual effect modifications (blur/solid backgrounds)
-   Theme-independent base configurations
-   Automatic Git workflow for changes

**Key Concept**: Configurations are split into layers that stack on top of each other through symlinks.

---

## Directory Structure

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
│   │           └── [mod-package]/                      # Contains mod files
│   │               └── FILES/                          # STOW FILES—Stowed to [theme]/mods/[mod-package]
│   │
│   ├── mods/
│   │   └── [mod-package]/
│   │       └── FILES/                                  # STOW TARGET—Stowed from [theme]'s [mod-package]/FILES, contains active mods symlinks
│   ├── options/                                        # STOW TARGET—Stowed from [theme]'s OPTION PACKAGES, extension files for THEME
│   └── build/                                          # Build scripts for dynamic theme-dependent configs
│
├── script/              # User scripts
├── service/             # Systemd user services
├── settings/            # Runtime state tracking
├── stow-scripts/        # Git automation scripts
└── tmp/                 # Runtime temp files
```

---

## Symlink Architecture

### 🔗 Symlink Flow Diagram

```
USER HOME (~/)
    ↑
    │ (GNU Stow creates symlinks)
    │
┌───┴────────────────────────────────────────────────────┐
│                                                         │
│  essentials/[app]/           mocha/base/[app]/         │
│  mocha/base/[app]/           mocha/[accent]/[app]/     │
│                                                         │
└─────────────────────────────────────────────────────────┘
    ↓ (Internal symlinks)
    │
┌───┴────────────────────────────────────────────────────┐
│                                                         │
│  essentials/sway/config                                 │
│      includes: base/theme  ──────┐                      │
│                                   ↓                     │
│  essentials/bases/sway/ ────→ mocha/base/sway-base/sway│
│      (symlink)                    ↓                     │
│                              includes: mocha-option/    │
│                              includes: mod/             │
│                                   ↓                     │
│  mocha/base/sway-base/sway/mocha-option/ ──→ mocha/options/sway/
│      (symlink)                    ↓                     │
│                              mocha/options/sway/ ───→ mocha/yellow/sway-option/sway/
│                                  (symlink)             │
│                                   ↓                     │
│  mocha/base/sway-base/sway/mod/ ──→ mocha/mods/sway/   │
│      (symlink)                    ↓                     │
│                              mocha/mods/sway/fx ───→ mocha/modlist/background/blur/sway/fx
│                                  (symlink)             │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

### 📍 Symlink Types & Purposes

#### **1. Base Theme Symlinks** (`essentials/bases/`)

**Location**: `essentials/bases/[app]/` → `mocha/base/[app-base]/[app]/`

**Example**:

```bash
essentials/bases/sway/ → ../../mocha/base/sway-base/sway
```

**Purpose**: Links essential configs to themed base configurations
**Created by**: `stow-mocha.sh` via `stow --dir=mocha/base --target=essentials/bases`

---

#### **2. Option Symlinks** (`mocha/base/[app]/option/`)

**Location**: `mocha/base/[app]/.config/[app]/option/` → `../../../../options/[app]/`

**Example**:

```bash
mocha/base/waybar/.config/waybar/option/ → ../../../../options/waybar/
```

**Purpose**: Points to directory containing active accent files
**Created by**: Manually created, permanent part of structure

---

#### **3. Mod Symlinks** (`mocha/base/[app]/mod/`)

**Location**: `mocha/base/[app]/.config/[app]/mod/` → `../../../../mods/[app]/`

**Example**:

```bash
mocha/base/waybar/.config/waybar/mod/ → ../../../../mods/waybar/
```

**Purpose**: Points to directory containing active mod files
**Created by**: Manually created, permanent part of structure

---

#### **4. Active Accent Symlinks** (`mocha/options/[app]/`)

**Location**: `mocha/options/[app]/` → `../[accent]/[app-option]/[app]/`

**Example**:

```bash
mocha/options/waybar/ → ../yellow/waybar-option/waybar/
```

**Purpose**: Points to the currently selected accent color directory
**Created by**: `stow_accent()` function in `stow-mocha.sh`
**Managed by**: GNU Stow (stowed from `mocha/[accent]/` to `mocha/options/`)

---

#### **5. Active Mod File Symlinks** (`mocha/mods/[app]/[file]`)

**Location**: `mocha/mods/[app]/[file]` → `../../modlist/[mod]/[option]/[app]/[file]`

**Example**:

```bash
mocha/mods/waybar/background.css → ../../modlist/background/blur/waybar/background.css
```

**Purpose**: Points to specific mod configuration files for the active option
**Created by**: `stow_mods()` function in `stow-mocha.sh`
**Managed by**: GNU Stow (stowed from `mocha/modlist/[mod]/[option]/` to `mocha/mods/`)

---

## Folder Terminology

### 🏗️ **`base/`** Directories

#### **Location 1: `essentials/bases/`**

-   **Type**: Stow target directory
-   **Contains**: Symlinks created by stowing `mocha/base/*-base/` packages
-   **Purpose**: Bridge between theme-independent essentials and themed configs
-   **Gitignored**: Yes (symlinks are dynamically generated)

#### **Location 2: `mocha/base/`**

-   **Type**: Source directory
-   **Contains**: Core Catppuccin Mocha theme files for each application
-   **Purpose**: Base theme that gets customized by accents and mods
-   **Naming pattern**: Apps ending in `-base` (e.g., `sway-base`, `vesktop-base`) are stowed to `essentials/bases/`

**Why split?**

-   Some apps have theme-independent configs in `essentials/`
-   Those configs need to `include` or `@import` themed files
-   The `bases/` directory acts as the connection point

---

### 🎨 **`option/`** Directories

#### **Location 1: `mocha/base/[app]/.config/[app]/option/`**

-   **Type**: Symlink → `mocha/options/[app]/`
-   **Purpose**: Import point for accent-specific styles
-   **Used in**: CSS `@import`, Sway `include` statements

#### **Location 2: `mocha/options/[app]/`**

-   **Type**: Symlink → `mocha/[accent]/[app-option]/[app]/`
-   **Purpose**: Points to currently active accent directory
-   **Created by**: `stow_accent()` function
-   **Gitignored**: Yes (dynamically managed)

#### **Location 3: `mocha/[accent]/[app-option]/[app]/`**

-   **Type**: Source files
-   **Contains**: Accent color definitions (e.g., `accent.css`, `accent.rasi`)
-   **Purpose**: Store accent-specific configurations for each app

**Example Chain**:

```
style.css imports: ./option/accent.css
                       ↓
./option/ → ../../../../options/waybar/
                       ↓
options/waybar/ → ../yellow/waybar-option/waybar/
                       ↓
yellow/waybar-option/waybar/accent.css
    Content: @define-color accent #f9e2af;
```

---

### 🎭 **`mod/`** Directories

#### **Location 1: `mocha/base/[app]/.config/[app]/mod/`**

-   **Type**: Symlink → `mocha/mods/[app]/`
-   **Purpose**: Import point for mod-specific styles
-   **Used in**: CSS `@import`, Sway `include` statements

#### **Location 2: `mocha/mods/[app]/`**

-   **Type**: Directory containing symlinks to mod files
-   **Purpose**: Holds currently active mod configurations
-   **Created by**: `stow_mods()` function
-   **Gitignored**: Partially (content is symlinks, structure is kept)

#### **Location 3: `mocha/modlist/[mod-name]/[option]/[app]/`**

-   **Type**: Source files
-   **Contains**: Actual mod configuration files
-   **Purpose**: Store different variants of visual modifications

**Example Chain**:

```
style.css imports: ./mod/background.css
                       ↓
./mod/ → ../../../../mods/waybar/
                       ↓
mods/waybar/background.css → ../../modlist/background/blur/waybar/background.css
                       ↓
modlist/background/blur/waybar/background.css
    Content: @define-color background rgba(30, 30, 46, 0.6);
```

---

### 🔨 **`build/`** Directories

#### **Location 1: `essentials/build/[app]/`**

-   **Purpose**: Theme-independent build scripts
-   **Example**: `Code/build.sh` - copies template to actual file

#### **Location 2: `mocha/build/[app]/`**

-   **Purpose**: Theme-aware build scripts
-   **Example**: `Code/build.sh` - applies accent color to VS Code settings
-   **Access to**: `$expbuild_accent` environment variable

**When used**: Called by `build()` function in main stow scripts

---

### 🎯 **`modlist/`** Directory

**Location**: `mocha/modlist/[mod-name]/[option]/`

**Structure**:

```
modlist/
└── background/              # Mod name
    ├── blur/                # Option 1
    │   ├── sway/
    │   ├── waybar/
    │   ├── rofi/
    │   └── ...
    └── solid/               # Option 2
        ├── sway/
        ├── waybar/
        ├── rofi/
        └── ...
```

**Purpose**:

-   Source storage for all mod variants
-   Each option contains configs for ALL affected applications
-   Provides a single source of truth for each visual modification

**Extensibility**: Add new mods by creating `modlist/[new-mod]/[option1]/`, `[option2]/`, etc.

---

## How It All Works Together

### 🎬 Execution Flow

#### **1. Running `stow-essentials.sh`**

```bash
./stow-essentials.sh
```

**What happens**:

1. Stows essential app configs to `~/`
    - `essentials/sway/` → `~/.config/sway/`
    - `essentials/Code/` → `~/.config/Code/`
    - etc.
2. Runs `essentials/build/Code/build.sh`
    - Copies `settings.json.build` template → `settings.json`

**Result**: Base apps configured, ready for theming

---

#### **2. Running `stow-mocha.sh yellow -background blur`**

```bash
./stow-mocha.sh yellow -background blur
```

**What happens**:

**Step 1: Stow base theme**

```bash
stow --dir=mocha/base --target=$HOME btop konsole ghostwriter ...
```

-   Creates: `~/.config/waybar/` → `mocha/base/waybar/.config/waybar/`
-   Creates: `~/.config/rofi/` → `mocha/base/rofi/.config/rofi/`
-   etc.

**Step 2: Stow bases to essentials**

```bash
stow --dir=mocha/base --target=essentials/bases sway-base vesktop-base
```

-   Creates: `essentials/bases/sway/` → `mocha/base/sway-base/sway/`
-   Creates: `essentials/bases/vesktop/` → `mocha/base/vesktop-base/vesktop/`

**Step 3: Stow accent (`stow_accent yellow`)**

```bash
# Unstow previous accent
stow -D --dir=mocha/peach --target=$HOME nwg-look qt6ct ytm zen
stow -D --dir=mocha/peach --target=mocha/options rofi-option swaync-option ...

# Stow new accent
stow --dir=mocha/yellow --target=$HOME nwg-look qt6ct ytm zen
stow --dir=mocha/yellow --target=mocha/options rofi-option swaync-option ...
```

-   Creates: `mocha/options/waybar/` → `mocha/yellow/waybar-option/waybar/`
-   Creates: `mocha/options/rofi/` → `mocha/yellow/rofi-option/rofi/`
-   Saves: `yellow` → `settings/.current_accent`
-   Runs: `papirus-folders -C cat-mocha-yellow`

**Step 4: Stow mods (`stow_mods -background blur`)**

```bash
# Unstow previous mod option
stow -D --dir=mocha/modlist/background --target=mocha/mods solid

# Stow new mod option
stow --dir=mocha/modlist/background --target=mocha/mods blur
```

-   Creates: `mocha/mods/waybar/background.css` → `mocha/modlist/background/blur/waybar/background.css`
-   Creates: `mocha/mods/sway/fx` → `mocha/modlist/background/blur/sway/fx`
-   Saves: `blur` → `settings/.current_mod_background`

**Step 5: Build theme-aware configs**

```bash
export expbuild_accent=yellow
bash mocha/build/Code/build.sh
```

-   Modifies VS Code settings with Catppuccin Mocha theme + yellow accent

**Step 6: Reload**

```bash
swaymsg reload
swaync-client --reload-css
nwg-look -a
```

---

### 🔄 Import Resolution Example

When Sway starts and loads `~/.config/sway/config`:

```
~/.config/sway/config (from essentials/sway/)
    include base/theme
        ↓
    base/ → essentials/bases/sway/
        ↓
    essentials/bases/sway/ → mocha/base/sway-base/sway/
        ↓
    mocha/base/sway-base/sway/theme contains:
        include ./mocha-option/accent
            ↓
        mocha-option/ → mocha/options/sway/
            ↓
        mocha/options/sway/ → mocha/yellow/sway-option/sway/
            ↓
        mocha/yellow/sway-option/sway/accent
            Content: set $accent #f9e2af

        include ./mod/fx
            ↓
        mod/ → mocha/mods/sway/
            ↓
        mocha/mods/sway/fx → mocha/modlist/background/blur/sway/fx
            Content: blur enable
                     blur_passes 4
                     ...
```

**Final result**: Sway loads with:

-   Base Catppuccin Mocha colors
-   Yellow accent (`#f9e2af`)
-   Blur effects enabled

---

## Usage Examples

### 🎨 Changing Accent Colors

```bash
# Switch to peach accent (keeps current mods)
./stow-mocha.sh peach

# Switch to yellow accent (keeps current mods)
./stow-mocha.sh yellow
```

---

### 🖼️ Changing Visual Mods

```bash
# Apply blur with transparent backgrounds
./stow-mocha.sh yellow -background blur

# Apply solid backgrounds without blur
./stow-mocha.sh yellow -background solid

# Change only the mod (keeps current accent)
./stow-mocha.sh yellow -background solid  # If already on yellow
```

---

### ➕ Adding a New Mod

**Example: Adding a "font" mod with "small" and "large" options**

1. Create mod structure:

```bash
mkdir -p mocha/modlist/font/{small,large}/{waybar,rofi,swaync}
```

2. Create config files:

```bash
# mocha/modlist/font/small/waybar/font.css
echo "* { font-size: 10px; }" > mocha/modlist/font/small/waybar/font.css

# mocha/modlist/font/large/waybar/font.css
echo "* { font-size: 14px; }" > mocha/modlist/font/large/waybar/font.css
```

3. Update base theme to import mod:

```css
/* mocha/base/waybar/.config/waybar/style.css */
@import "mocha.css";
@import "./option/accent.css";
@import "./mod/background.css";
@import "./mod/font.css"; /* Add this */
```

4. Use it:

```bash
./stow-mocha.sh yellow -background blur -font large
```

**The system automatically**:

-   Validates the mod exists
-   Creates symlinks in `mocha/mods/waybar/font.css`
-   Tracks state in `settings/.current_mod_font`

---

### 🔍 Debugging Symlinks

```bash
# Check where a symlink points
readlink -f ~/.config/waybar/style.css

# See all symlinks in mocha
find mocha -type l -ls

# Verify accent is correct
cat mocha/options/waybar/accent.css

# Verify mod is correct
cat mocha/mods/waybar/background.css
```

---

### 📝 Adding a New Application

**Example: Adding "kitty" terminal with theme support**

1. Create essential config:

```bash
mkdir -p essentials/kitty/.config/kitty
# Add your base kitty.conf
```

2. Create mocha base theme:

```bash
mkdir -p mocha/base/kitty/.config/kitty
# Create kitty theme with @import "./option/accent.conf"
```

3. Create accent variants:

```bash
mkdir -p mocha/peach/kitty-option/kitty
mkdir -p mocha/yellow/kitty-option/kitty
# Create accent.conf in each with accent colors
```

4. Create mod support (optional):

```bash
mkdir -p mocha/modlist/background/{blur,solid}/kitty
# Create transparency configs
```

5. Update stow scripts:

```bash
# In stow-essentials.sh, add "kitty" to stow command
# In stow-mocha.sh, add "kitty" to mocha_packages
# Add "kitty-option" to accent_options
```

---

## 🎓 Key Concepts Summary

| Concept         | Purpose                    | Example                                            |
| --------------- | -------------------------- | -------------------------------------------------- |
| **base/**       | Core theme files           | `mocha/base/waybar/`                               |
| **option/**     | Accent color variants      | `mocha/options/waybar/` → `yellow/waybar-option/`  |
| **mod/**        | Visual modifications       | `mocha/mods/waybar/` → `modlist/background/blur/`  |
| **modlist/**    | Source of all mod variants | `modlist/background/{blur,solid}`                  |
| **build/**      | Dynamic config generation  | `build/Code/build.sh` applies accent               |
| **bases/**      | Bridge to theme files      | `essentials/bases/sway/` → `mocha/base/sway-base/` |
| **Stow Target** | Where symlinks are created | `~/`, `mocha/options/`, `mocha/mods/`              |
| **Stow Source** | What gets symlinked        | `mocha/base/`, `modlist/background/blur/`          |

---

## 📚 Further Reading

-   **GNU Stow Manual**: Understanding symlink management
-   **Catppuccin**: Color palette reference
-   **SwayFX**: Blur effects documentation
-   **stow-mocha.sh**: Implementation details of the theming system

---

**Last Updated**: October 28, 2025
**Architecture Version**: 2.0 (Unified Mod System)
