# ddcMacTahoeKde

A dark theme suite for KDE Plasma 6, based on [MacTahoe KDE](https://github.com/vinceliuice/MacTahoe-kde) and recolored to match Breeze Dark's cool blue-gray palette — eliminating the original warm brown/gray tones.

## Table of Contents

- [What's Changed](#whats-changed)
- [Components](#components)
- [Installation](#installation)
  - [Dependencies](#dependencies)
  - [Install](#install)
  - [Uninstall](#uninstall)
- [What the Installer Does](#what-the-installer-does)
- [Extras](#extras)
  - [Thunderbird / Betterbird Dark Theme](#thunderbird--betterbird-dark-theme)
- [Project Structure](#project-structure)
- [Credits](#credits)
- [License](#license)

## What's Changed

This project takes [vinceliuice's MacTahoe theme](https://github.com/vinceliuice/MacTahoe-kde) and applies the following modifications:

- **Plasma desktop theme SVGs** — replaced with Breeze Dark originals for consistent panel/widget styling
- **Kvantum colors** — dark variant recolored from warm grays (#1f1f1f, #282828, #333333) to Breeze Dark's cool blue-grays (#141618, #202326, #292c30)
- **KDE color scheme** — selection/highlight colors corrected
- **Inactive window behavior** — fixed (no dimming, blur on all windows)
- **Tab alignment** — left-aligned tabs in Konsole, Kate, and other apps (Kvantum `left_tabs=true`)
- **GTK theme** — color patch for `_colors.scss` to match the Breeze Dark palette
- **Look-and-feel defaults** — corrected icons (WhiteSur), cursors, and sound theme references
- **Widget configuration icons** — replaced with Breeze defaults for consistent close/config buttons

## Components

| Component          | Name                              |
|--------------------|-----------------------------------|
| Color Scheme       | ddcMacTahoeKdeDark                |
| Application Style  | kvantum-dark                      |
| Plasma Theme       | ddcMacTahoeKde-Dark               |
| Window Decorations | ddcMacTahoeKde-Dark (Aurorae)     |
| Icons              | WhiteSur-dark                     |
| Cursors            | MacTahoe                          |
| System Sounds      | MacOS Sounds                      |
| Splash Screen      | ddcMacTahoeKde-Dark               |
| SDDM               | ddcMacTahoeKde-Dark               |
| GTK Style          | MacTahoe-Dark-Darker              |
| Kvantum Style      | ddcMacTahoeKdeDark                |

## Installation

### Dependencies

- `kvantum` — Qt style engine
- `sassc` — SCSS compiler (for GTK theme build)
- `git` — for downloading icon and GTK themes

On Fedora:
```bash
sudo dnf install -y kvantum sassc git
```

On Ubuntu / Debian:
```bash
sudo apt install -y qt6-style-kvantum sassc git
```

On Arch:
```bash
sudo pacman -S --noconfirm kvantum sassc git
```

### Install

```bash
# Install everything and apply the theme
./install.sh

# Install without downloading icons/GTK/SDDM
./install.sh --no-icons --no-gtk --no-sddm

# Install files only, don't apply
./install.sh --no-apply
```

### Uninstall

```bash
# Remove everything and restore Breeze defaults
./uninstall.sh

# Keep icons and GTK themes
./uninstall.sh --keep-icons --keep-gtk
```

## What the Installer Does

1. Copies Plasma desktop theme, look-and-feel package, Aurorae window decorations, color scheme, and Kvantum theme to their proper locations
2. Copies the MacOS system sounds theme
3. Downloads and installs [WhiteSur icon theme](https://github.com/vinceliuice/WhiteSur-icon-theme) (icons, with close icons patched to Breeze X)
4. Downloads and installs [MacTahoe icon theme](https://github.com/vinceliuice/MacTahoe-icon-theme) (cursors)
5. Downloads [MacTahoe GTK theme](https://github.com/vinceliuice/MacTahoe-gtk-theme), applies the Breeze Dark color patch, and builds the dark variant
6. Installs the SDDM login theme (requires sudo)
7. Applies the dark theme
8. Clears the Plasma SVG cache

## Extras

### Thunderbird / Betterbird Dark Theme

A `userChrome.css` is included for dark-themed Thunderbird/Betterbird:

1. Copy `extras/userChrome.css` to your profile's `chrome/` folder
2. Copy `extras/user.js` to your profile root folder
3. Restart Thunderbird/Betterbird

## Project Structure

```
ddcMacTahoeKde/
├── install.sh
├── uninstall.sh
├── plasma/
│   ├── desktoptheme/          # Patched Plasma SVGs
│   └── look-and-feel/         # Global theme packages
├── aurorae/themes/            # Window decorations (3 scale variants)
├── color-schemes/             # KDE color schemes
├── kvantum/ddcMacTahoeKde/    # Kvantum theme configs + SVGs
├── sddm/ddcMacTahoeKde-Dark/  # SDDM login theme
├── sounds/MacOS Sounds/       # System sound theme
├── gtk/colors.patch           # Breeze Dark color patch for GTK
└── extras/                    # Thunderbird/Betterbird theme
```

## Credits

This project is a color-corrected fork of themes by [vinceliuice](https://github.com/vinceliuice):

- [MacTahoe-kde](https://github.com/vinceliuice/MacTahoe-kde) — Plasma desktop theme, Aurorae decorations, Kvantum theme, color schemes, SDDM theme
- [MacTahoe-gtk-theme](https://github.com/vinceliuice/MacTahoe-gtk-theme) — GTK theme (patched via `gtk/colors.patch`)
- [MacTahoe-icon-theme](https://github.com/vinceliuice/MacTahoe-icon-theme) — Icon theme and cursors
- [WhiteSur-icon-theme](https://github.com/vinceliuice/WhiteSur-icon-theme) — Icon theme (with close icons patched to Breeze X)
- MacOS Sounds — System sound theme (Apple macOS sound effects)

## License

GPLv3, same as the original MacTahoe themes.
