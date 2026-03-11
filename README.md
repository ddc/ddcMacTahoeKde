<h1 align="center">
  <img src="https://raw.githubusercontent.com/ddc/macOsTahoeKdeTheme/refs/heads/master/assets/ddcSoftwaresThemesIcon.svg" alt="ddcSoftwaresThemesIcon" width="150">
  <br>
  DDC macOS Tahoe KDE Plasma 6 Theme
</h1>

<p align="center">
    <a href="https://github.com/sponsors/ddc"><img src="https://img.shields.io/static/v1?style=plastic&label=Sponsor&message=%E2%9D%A4&logo=GitHub&color=ff69b4" alt="Sponsor"/></a>
    <br>
    <a href="https://ko-fi.com/ddcsta"><img src="https://img.shields.io/badge/Ko--fi-ddcsta-FF5E5B?style=plastic&logo=kofi&logoColor=white&color=brightgreen" alt="Ko-fi"/></a>
    <a href="https://www.paypal.com/ncp/payment/6G9Z78QHUD4RJ"><img src="https://img.shields.io/badge/Donate-PayPal-brightgreen.svg?style=plastic&logo=paypal&logoColor=white" alt="Donate"/></a>
    <br>
    <a href="https://github.com/ddc/macOsTahoeKdeTheme/blob/master/LICENSE"><img src="https://img.shields.io/badge/License-GPLv3-blue.svg?style=plastic&logo=gnu&logoColor=white" alt="License: GPLv3"/></a>
    <a href="https://github.com/ddc/macOsTahoeKdeTheme/releases/latest"><img src="https://img.shields.io/github/v/release/ddc/macOsTahoeKdeTheme?style=plastic&logo=github&logoColor=white" alt="Release"/></a>
    <br>
    <a href="https://github.com/ddc/macOsTahoeKdeTheme/issues"><img src="https://img.shields.io/github/issues/ddc/macOsTahoeKdeTheme?style=plastic&logo=github&logoColor=white" alt="issues"/></a>
    <a href="https://github.com/ddc/macOsTahoeKdeTheme/actions/workflows/workflow.yml"><img src="https://img.shields.io/github/actions/workflow/status/ddc/macOsTahoeKdeTheme/workflow.yml?style=plastic&logo=github&logoColor=white&label=CI%2FCD%20Pipeline" alt="CI/CD Pipeline"/></a>
    <a href="https://actions-badge.atrox.dev/ddc/macOsTahoeKdeTheme/goto?ref=master"><img src="https://img.shields.io/endpoint.svg?url=https%3A//actions-badge.atrox.dev/ddc/macOsTahoeKdeTheme/badge?ref=master&label=build&logo=github&style=plastic" alt="Build Status"/></a>
</p>

<p align="center">A dark theme suite for <a href="https://kde.org/pt-br/plasma-desktop">KDE Plasma 6</a>, based on <a href="https://github.com/vinceliuice/MacTahoe-kde">MacTahoe KDE</a> and recolored to match <a href="https://github.com/KDE/breeze">Breeze Dark's palette</a>.</p>

# Table of Contents

- [What's Changed](#whats-changed)
- [Components](#components)
- [Install Locations](#install-locations)
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
- [Support](#support)

# What's Changed

This project takes [vinceliuice's MacTahoe theme](https://github.com/vinceliuice/MacTahoe-kde) and applies the following
modifications:

- **Plasma desktop theme SVGs** — replaced with Breeze Dark originals for consistent panel/widget styling
- **Kvantum colors
  ** — dark variant recolored from warm grays (#1f1f1f, #282828, #333333) to Breeze Dark's cool blue-grays (#141618,
  #202326, #292c30)
- **KDE color scheme** — selection/highlight colors corrected
- **Inactive window behavior** — fixed (no dimming, blur on all windows)
- **Tab alignment** — left-aligned tabs in Konsole, Kate, and other apps (Kvantum `left_tabs=true`)
- **GTK theme** — color patch for `_colors.scss` to match the Breeze Dark palette
- **Look-and-feel defaults** — corrected icons, cursors, and sound theme references
- **Widget configuration icons** — replaced with Breeze defaults for consistent close/config buttons

# Components

| Component          | Name                                 |
|--------------------|--------------------------------------|
| Color Scheme       | DDCmacOsTahoeKdeTheme-dark           |
| Application Style  | kvantum-dark                         |
| Plasma Theme       | DDCmacOsTahoeKdeTheme-dark           |
| Window Decorations | DDCmacOsTahoeKdeTheme-dark (Aurorae) |
| Icons              | DDCmacOsTahoeKdeTheme-icons-dark     |
| Cursors (default)  | DDCmacOsTahoe-cursor-dark            |
| Cursors            | DDCmacOsTahoe-cursor-mixed           |
| Cursors            | DDCmacOsTahoe-cursor-white           |
| Cursors            | DDCmacOsMonterey-cursor-white        |
| System Sounds      | DDCmacOsKdeTheme-sounds              |
| GTK Style          | DDCmacOsTahoeKdeTheme-dark           |
| Kvantum Style      | DDCmacOsTahoeKdeTheme-dark           |

# Install Locations

| Component            | Install Location                                                                 |
|----------------------|----------------------------------------------------------------------------------|
| Plasma Desktop Theme | `~/.local/share/plasma/desktoptheme/DDCmacOsTahoeKdeTheme-dark/`                 |
| Look-and-Feel        | `~/.local/share/plasma/look-and-feel/com.github.ddc.DDCmacOsTahoeKdeTheme-dark/` |
| Aurorae Decorations  | `~/.local/share/aurorae/themes/DDCmacOsTahoeKdeTheme-dark{,-1.25x,-1.5x}/`       |
| Color Scheme         | `~/.local/share/color-schemes/DDCmacOsTahoeKdeTheme-dark.colors`                 |
| Sound Theme          | `~/.local/share/sounds/DDCmacOsKdeTheme-sounds/`                                 |
| Icon Theme           | `~/.local/share/icons/DDCmacOsTahoeKdeTheme-icons-dark/`                         |
| Cursor Themes        | `~/.local/share/icons/DDCmacOsTahoe-cursor-{dark,white,mixed}/`                  |
| Cursor Theme         | `~/.local/share/icons/DDCmacOsMonterey-cursor-white/`                            |
| GTK Theme            | `~/.themes/DDCmacOsTahoeKdeTheme-dark/`                                          |
| Kvantum Theme        | `~/.config/Kvantum/DDCmacOsTahoeKdeTheme-dark/`                                  |

# Installation

## Dependencies

- `kvantum` — Qt style engine

On Fedora:

```bash
sudo dnf install -y kvantum
```

On Ubuntu / Debian:

```bash
sudo apt install -y qt6-style-kvantum
```

On Arch:

```bash
sudo pacman -S --noconfirm kvantum
```

## Install

```bash
# Install everything and apply the theme
./install.sh

# Install without icons/GTK
./install.sh --no-icons --no-gtk

# Install files only, don't apply
./install.sh --no-apply
```

## Uninstall

```bash
# Remove everything and restore Breeze defaults
./uninstall.sh

# Keep icons and GTK themes
./uninstall.sh --keep-icons --keep-gtk
```

# What the Installer Does

1. Copies Plasma desktop theme, look-and-feel package, Aurorae window decorations, color scheme, and Kvantum theme to their proper locations
2. Copies the DDCmacOsKdeTheme-sounds theme
3. Installs the bundled icon theme (DDCmacOsTahoeKdeTheme-icons-dark)
4. Installs four bundled cursor themes (DDCmacOsTahoe-cursor-dark, DDCmacOsTahoe-cursor-white, DDCmacOsTahoe-cursor-mixed, DDCmacOsMonterey-cursor-white) and converts text aliases to symlinks
5. Installs the bundled GTK theme (DDCmacOsTahoeKdeTheme-dark)
6. Applies the dark theme (color scheme, Plasma theme, Kvantum, GTK, Aurorae, icons, cursors, sounds)
7. Clears the Plasma SVG cache

# Extras

## Thunderbird / Betterbird Dark Theme

A `userChrome.css` is included for dark-themed Thunderbird/Betterbird:

1. Copy `extras/userChrome.css` to your profile's `chrome/` folder
2. Copy `extras/user.js` to your profile root folder
3. Restart Thunderbird/Betterbird

# Project Structure

```
macOsTahoeKdeTheme/
├── install.sh                           # Theme installer
├── uninstall.sh                         # Theme uninstaller
├── VERSION                              # Version file
├── plasma/
│   ├── desktoptheme/                    # Patched Plasma SVGs
│   │   └── DDCmacOsTahoeKdeTheme-dark/
│   └── look-and-feel/                   # Global theme package
│       └── com.github.ddc.DDCmacOsTahoeKdeTheme-dark/
├── aurorae/themes/                      # Window decorations (3 scale variants)
│   ├── DDCmacOsTahoeKdeTheme-dark/
│   ├── DDCmacOsTahoeKdeTheme-dark-1.25x/
│   └── DDCmacOsTahoeKdeTheme-dark-1.5x/
├── color-schemes/                       # KDE color scheme
│   └── DDCmacOsTahoeKdeTheme-dark.colors
├── kvantum/                             # Kvantum theme configs + SVGs
│   └── DDCmacOsTahoeKdeTheme-dark/
├── sounds/                              # System sound theme
│   └── DDCmacOsKdeTheme-sounds/
├── icons/                               # Icon theme
│   └── DDCmacOsTahoeKdeTheme-icons-dark/
├── cursors/                             # Cursor themes
│   ├── DDCmacOsTahoe-cursor-dark/
│   ├── DDCmacOsTahoe-cursor-white/
│   ├── DDCmacOsTahoe-cursor-dark/       # Default cursor theme
│   └── DDCmacOsMonterey-cursor-white/
├── gtk/themes/                          # GTK theme
│   └── DDCmacOsTahoeKdeTheme-dark/
├── scripts/                             # Helper scripts
│   └── add_cursor_sizes.py              # Adds 36px/40px cursor sizes
├── bump_version.sh                      # Version bump utility
└── extras/                              # Thunderbird/Betterbird theme
```

# Color Scheme Differences (DDC vs Breeze Dark)

The DDC theme uses a deep blue accent and orange active highlights instead of Breeze Dark's light blue. Below are all the color values that differ:

| Section              | Setting             | DDC Theme     | Breeze Dark  |
|----------------------|---------------------|---------------|--------------|
| Colors:Button        | DecorationFocus     | `49,91,239`   | `61,174,233` |
| Colors:Button        | DecorationHover     | `49,91,239`   | `61,174,233` |
| Colors:Button        | ForegroundLink      | `41,128,185`  | `29,153,243` |
| Colors:Button        | ForegroundVisited   | `127,140,141` | `155,89,182` |
| Colors:Selection     | BackgroundAlternate | `41,44,48`    | `30,87,116`  |
| Colors:Selection     | DecorationFocus     | `49,91,239`   | `61,174,233` |
| Colors:Selection     | DecorationHover     | `49,91,239`   | `61,174,233` |
| Colors:Selection     | ForegroundActive    | `246,116,0`   | `61,174,233` |
| Colors:Selection     | ForegroundLink      | `49,91,239`   | `29,153,243` |
| Colors:Selection     | ForegroundNegative  | `237,21,21`   | `218,68,83`  |
| Colors:Selection     | ForegroundNeutral   | `201,206,59`  | `246,116,0`  |
| Colors:Selection     | ForegroundPositive  | `17,209,22`   | `39,174,96`  |
| Colors:Selection     | ForegroundVisited   | `49,91,239`   | `155,89,182` |
| Colors:Tooltip       | DecorationFocus     | `49,91,239`   | `61,174,233` |
| Colors:Tooltip       | DecorationHover     | `49,91,239`   | `61,174,233` |
| Colors:Tooltip       | ForegroundActive    | `246,116,0`   | `61,174,233` |
| Colors:Tooltip       | ForegroundLink      | `49,91,239`   | `29,153,243` |
| Colors:Tooltip       | ForegroundNegative  | `237,21,21`   | `218,68,83`  |
| Colors:Tooltip       | ForegroundNeutral   | `201,206,59`  | `246,116,0`  |
| Colors:Tooltip       | ForegroundPositive  | `17,209,22`   | `39,174,96`  |
| Colors:Tooltip       | ForegroundVisited   | `49,91,239`   | `155,89,182` |
| Colors:View          | BackgroundAlternate | `41,44,48`    | `32,35,38`   |
| Colors:View          | BackgroundNormal    | `32,35,38`    | `41,44,48`   |
| Colors:View          | DecorationFocus     | `49,91,239`   | `61,174,233` |
| Colors:View          | DecorationHover     | `49,91,239`   | `61,174,233` |
| Colors:View          | ForegroundActive    | `49,91,239`   | `61,174,233` |
| Colors:View          | ForegroundLink      | `49,91,239`   | `29,153,243` |
| Colors:View          | ForegroundVisited   | `127,140,141` | `155,89,182` |
| Colors:Complementary | DecorationFocus     | `49,91,239`   | `61,174,233` |
| Colors:Complementary | DecorationHover     | `49,91,239`   | `61,174,233` |
| Colors:Complementary | ForegroundActive    | `49,91,239`   | `61,174,233` |
| Colors:Complementary | ForegroundLink      | `49,91,239`   | `29,153,243` |
| Colors:Complementary | ForegroundVisited   | `120,120,120` | `155,89,182` |
| Colors:Header        | DecorationFocus     | `49,91,239`   | `61,174,233` |
| Colors:Header        | DecorationHover     | `49,91,239`   | `61,174,233` |
| Colors:Header        | ForegroundActive    | `49,91,239`   | `61,174,233` |
| Colors:Header        | ForegroundLink      | `49,91,239`   | `29,153,243` |
| Colors:Header        | ForegroundVisited   | `120,120,120` | `155,89,182` |

# Credits

This project is a color-corrected fork of themes by [vinceliuice](https://github.com/vinceliuice):

- [MacTahoe-kde](https://github.com/vinceliuice/MacTahoe-kde) — Plasma desktop theme, Aurorae decorations, Kvantum theme, color schemes
- [MacTahoe-gtk-theme](https://github.com/vinceliuice/MacTahoe-gtk-theme) — GTK theme
- [MacTahoe-icon-theme](https://github.com/vinceliuice/MacTahoe-icon-theme) — Cursors
- [WhiteSur-icon-theme](https://github.com/vinceliuice/WhiteSur-icon-theme) — Icon theme (with close icons patched to Breeze X)
- MacOS Sounds — System sound theme (Apple macOS sound effects)

# License

Released under the [GPLv3](https://github.com/ddc/macOsTahoeKdeTheme/blob/master/LICENSE)

# Support

If you find this project helpful, consider supporting development:

- [GitHub Sponsor](https://github.com/sponsors/ddc)
- [ko-fi](https://ko-fi.com/ddcsta)
- [PayPal](https://www.paypal.com/ncp/payment/6G9Z78QHUD4RJ)
