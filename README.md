<h1 align="center">
  <img src="https://raw.githubusercontent.com/ddc/macOsTahoeKdeTheme/refs/heads/master/assets/ddcTheme-icon.svg" alt="ddcTheme" width="150">
  <br>
  DDC macOS Tahoe KDE Plasma 6 Theme
</h1>

<p align="center">
    <a href="https://www.paypal.com/ncp/payment/6G9Z78QHUD4RJ"><img src="https://img.shields.io/badge/Donate-PayPal-brightgreen.svg?style=plastic&logo=paypal&logoColor=3776AB" alt="Donate"/></a>
    <a href="https://github.com/sponsors/ddc"><img src="https://img.shields.io/static/v1?style=plastic&label=Sponsor&message=%E2%9D%A4&logo=GitHub&color=ff69b4" alt="Sponsor"/></a>
    <br>
    <a href="https://www.gnu.org/licenses/gpl-3.0"><img src="https://img.shields.io/badge/License-GPLv3-blue.svg?style=plastic&logo=gnu&logoColor=white" alt="License: GPLv3"/></a>
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

This project takes [vinceliuice's MacTahoe theme](https://github.com/vinceliuice/MacTahoe-kde) and applies the following modifications:

- **Plasma desktop theme SVGs** — replaced with Breeze Dark originals for consistent panel/widget styling
- **Kvantum colors
  ** — dark variant recolored from warm grays (#1f1f1f, #282828, #333333) to Breeze Dark's cool blue-grays (#141618, #202326, #292c30)
- **KDE color scheme** — selection/highlight colors corrected
- **Inactive window behavior** — fixed (no dimming, blur on all windows)
- **Tab alignment** — left-aligned tabs in Konsole, Kate, and other apps (Kvantum `left_tabs=true`)
- **GTK theme** — color patch for `_colors.scss` to match the Breeze Dark palette
- **Look-and-feel defaults** — corrected icons (WhiteSur), cursors, and sound theme references
- **Widget configuration icons** — replaced with Breeze defaults for consistent close/config buttons

# Components

| Component          | Name                                 |
|--------------------|--------------------------------------|
| Color Scheme       | DDCmacOsTahoeKdeThemeDark            |
| Application Style  | kvantum-dark                         |
| Plasma Theme       | DDCmacOsTahoeKdeTheme-Dark           |
| Window Decorations | DDCmacOsTahoeKdeTheme-Dark (Aurorae) |
| Icons              | WhiteSur-dark                        |
| Cursors            | MacTahoe                             |
| System Sounds      | MacOS Sounds                         |
| Splash Screen      | DDCmacOsTahoeKdeTheme-Dark           |
| SDDM               | DDCmacOsTahoeKdeTheme-Dark           |
| GTK Style          | MacTahoe-Dark-Darker                 |
| Kvantum Style      | DDCmacOsTahoeKdeThemeDark            |

# Installation

## Dependencies

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

## Install

```bash
# Install everything and apply the theme
./install.sh

# Install without downloading icons/GTK/SDDM
./install.sh --no-icons --no-gtk --no-sddm

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
2. Copies the MacOS system sounds theme
3. Downloads and installs [WhiteSur icon theme](https://github.com/vinceliuice/WhiteSur-icon-theme) (icons, with close icons patched to Breeze X)
4. Downloads and installs [MacTahoe icon theme](https://github.com/vinceliuice/MacTahoe-icon-theme) (cursors)
5. Downloads [MacTahoe GTK theme](https://github.com/vinceliuice/MacTahoe-gtk-theme), applies the Breeze Dark color patch, and builds the dark variant
6. Installs the SDDM login theme (requires sudo)
7. Applies the dark theme
8. Clears the Plasma SVG cache

# Extras

## Thunderbird / Betterbird Dark Theme

A `userChrome.css` is included for dark-themed Thunderbird/Betterbird:

1. Copy `extras/userChrome.css` to your profile's `chrome/` folder
2. Copy `extras/user.js` to your profile root folder
3. Restart Thunderbird/Betterbird

# Project Structure

```
DDCmacOsTahoeKdeTheme/
├── install.sh
├── uninstall.sh
├── plasma/
│   ├── desktoptheme/          # Patched Plasma SVGs
│   └── look-and-feel/         # Global theme packages
├── aurorae/themes/            # Window decorations (3 scale variants)
├── color-schemes/             # KDE color schemes
├── kvantum/DDCmacOsTahoeKdeTheme/    # Kvantum theme configs + SVGs
├── sddm/DDCmacOsTahoeKdeTheme-Dark/  # SDDM login theme
├── sounds/MacOS Sounds/       # System sound theme
├── gtk/colors.patch           # Breeze Dark color patch for GTK
└── extras/                    # Thunderbird/Betterbird theme
```

# Credits

This project is a color-corrected fork of themes by [vinceliuice](https://github.com/vinceliuice):

- [MacTahoe-kde](https://github.com/vinceliuice/MacTahoe-kde) — Plasma desktop theme, Aurorae decorations, Kvantum theme, color schemes, SDDM theme
- [MacTahoe-gtk-theme](https://github.com/vinceliuice/MacTahoe-gtk-theme) — GTK theme (patched via `gtk/colors.patch`)
- [MacTahoe-icon-theme](https://github.com/vinceliuice/MacTahoe-icon-theme) — Icon theme and cursors
- [WhiteSur-icon-theme](https://github.com/vinceliuice/WhiteSur-icon-theme) — Icon theme (with close icons patched to Breeze X)
- MacOS Sounds — System sound theme (Apple macOS sound effects)

# License

GPLv3, same as the original MacTahoe themes.

# Support
If you find this project helpful, consider supporting development:

- [GitHub Sponsor](https://github.com/sponsors/ddc)
- [ko-fi](https://ko-fi.com/ddcsta)
- [PayPal](https://www.paypal.com/ncp/payment/6G9Z78QHUD4RJ)
