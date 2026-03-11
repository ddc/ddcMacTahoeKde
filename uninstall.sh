#!/bin/bash
# DDCmacOsTahoeKdeTheme Theme Uninstaller
# Removes all DDCmacOsTahoeKdeTheme theme components and restores Breeze defaults.
#
# Usage: ./uninstall.sh [--keep-icons] [--keep-gtk]

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

info()  { echo -e "${BLUE}[INFO]${NC} $*"; }
ok()    { echo -e "${GREEN}[OK]${NC} $*"; }
warn()  { echo -e "${YELLOW}[WARN]${NC} $*"; }

REMOVE_ICONS=true
REMOVE_GTK=true

while [[ $# -gt 0 ]]; do
    case "$1" in
        --keep-icons) REMOVE_ICONS=false; shift ;;
        --keep-gtk)   REMOVE_GTK=false; shift ;;
        *)            echo "Unknown option: $1"; exit 1 ;;
    esac
done

# -------------------------------------------------------------------
# Remove Plasma desktop themes
# -------------------------------------------------------------------
info "Removing Plasma desktop themes..."
rm -rf "$HOME/.local/share/plasma/desktoptheme/DDCmacOsTahoeKdeTheme-dark"
ok "Desktop themes removed"

# -------------------------------------------------------------------
# Remove look-and-feel packages
# -------------------------------------------------------------------
info "Removing look-and-feel packages..."
rm -rf "$HOME/.local/share/plasma/look-and-feel/com.github.ddc.DDCmacOsTahoeKdeTheme-dark"
ok "Look-and-feel packages removed"

# -------------------------------------------------------------------
# Remove Aurorae window decorations
# -------------------------------------------------------------------
info "Removing Aurorae window decorations..."
rm -rf "$HOME/.local/share/aurorae/themes/DDCmacOsTahoeKdeTheme-dark"
rm -rf "$HOME/.local/share/aurorae/themes/DDCmacOsTahoeKdeTheme-dark-1.25x"
rm -rf "$HOME/.local/share/aurorae/themes/DDCmacOsTahoeKdeTheme-dark-1.5x"
ok "Aurorae decorations removed"

# -------------------------------------------------------------------
# Remove color schemes
# -------------------------------------------------------------------
info "Removing color schemes..."
rm -f "$HOME/.local/share/color-schemes/DDCmacOsTahoeKdeTheme-dark.colors"
ok "Color schemes removed"

# -------------------------------------------------------------------
# Remove Kvantum themes
# -------------------------------------------------------------------
info "Removing Kvantum theme..."
rm -rf "$HOME/.config/Kvantum/DDCmacOsTahoeKdeTheme-dark"
ok "Kvantum theme removed"

# -------------------------------------------------------------------
# Remove sound theme
# -------------------------------------------------------------------
info "Removing DDCmacOsKdeTheme-sounds..."
rm -rf "$HOME/.local/share/sounds/DDCmacOsKdeTheme-sounds"
ok "Sound theme removed"

# -------------------------------------------------------------------
# Remove icon themes (optional)
# -------------------------------------------------------------------
if $REMOVE_ICONS; then
    info "Removing DDCmacOsTahoeKdeTheme icon theme..."
    rm -rf "$HOME/.local/share/icons/DDCmacOsTahoeKdeTheme-icons-dark"
    ok "DDCmacOsTahoeKdeTheme icons removed"

    info "Removing DDCmacOsTahoe cursor themes..."
    rm -rf "$HOME/.local/share/icons/DDCmacOsTahoe-cursor-dark"
    rm -rf "$HOME/.local/share/icons/DDCmacOsTahoe-cursor-white"
    rm -rf "$HOME/.local/share/icons/DDCmacOsTahoe-cursor-mixed"
    rm -rf "$HOME/.local/share/icons/DDCmacOsMonterey-cursor-white"
    ok "Cursor themes removed"
else
    warn "Keeping icon themes (--keep-icons)"
fi

# -------------------------------------------------------------------
# Remove GTK themes (optional)
# -------------------------------------------------------------------
if $REMOVE_GTK; then
    info "Removing DDCmacOsTahoeKdeTheme GTK theme..."
    rm -rf "$HOME/.themes/DDCmacOsTahoeKdeTheme-dark"
    ok "GTK theme removed"
else
    warn "Keeping GTK themes (--keep-gtk)"
fi

# -------------------------------------------------------------------
# Restore Breeze defaults
# -------------------------------------------------------------------
info "Restoring Breeze defaults..."

if command -v plasma-apply-colorscheme &>/dev/null; then
    plasma-apply-colorscheme BreezeLight 2>/dev/null || plasma-apply-colorscheme BreezeDark 2>/dev/null || true
fi

if command -v plasma-apply-desktoptheme &>/dev/null; then
    plasma-apply-desktoptheme breeze-dark 2>/dev/null || true
fi

if command -v kvantummanager &>/dev/null; then
    kvantummanager --set Default 2>/dev/null || true
fi

if command -v kwriteconfig6 &>/dev/null; then
    kwriteconfig6 --file kwinrc --group org.kde.kdecoration2 --key library "org.kde.breeze"
    kwriteconfig6 --file kwinrc --group org.kde.kdecoration2 --key theme ""
    kwriteconfig6 --file kdeglobals --group Icons --key Theme "breeze-dark"
    kwriteconfig6 --file kcminputrc --group Mouse --key cursorTheme "breeze_cursors"
    kwriteconfig6 --file kdeglobals --group KDE --key widgetStyle "breeze"
    kwriteconfig6 --file kdeglobals --group Sounds --key Theme "ocean"
    qdbus6 org.kde.KWin /KWin reconfigure 2>/dev/null || true
fi

ok "Breeze defaults restored"

# -------------------------------------------------------------------
# Clear cache
# -------------------------------------------------------------------
info "Clearing Plasma SVG cache..."
rm -f "$HOME/.cache/plasma_theme_"*.kcache
rm -rf "$HOME/.cache/ksvg-elements/"
ok "Cache cleared"

echo ""
ok "DDCmacOsTahoeKdeTheme uninstallation complete!"
echo "  Log out and back in for all changes to take effect."
