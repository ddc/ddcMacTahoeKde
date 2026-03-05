#!/bin/bash
# DDCmacOsTahoeKdeTheme Theme Installer
# Installs the DDCmacOsTahoeKdeTheme dark theme suite with Breeze Dark-aligned colors.
#
# Usage: ./install.sh [OPTIONS]
#
# Options:
#   --no-sddm       Skip SDDM theme installation
#   --no-icons      Skip icon/cursor theme installation
#   --no-gtk        Skip GTK theme installation
#   --no-apply      Install files only, don't apply the theme
#   -h, --help      Show this help message

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VERSION="$(cat "$SCRIPT_DIR/VERSION")"

# Defaults
INSTALL_SDDM=true
INSTALL_ICONS=true
INSTALL_GTK=true
APPLY_THEME=true

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

info()  { echo -e "${BLUE}[INFO]${NC} $*"; }
ok()    { echo -e "${GREEN}[OK]${NC} $*"; }
warn()  { echo -e "${YELLOW}[WARN]${NC} $*"; }
error() { echo -e "${RED}[ERROR]${NC} $*" >&2; }

usage() {
    sed -n '2,/^$/s/^# \?//p' "$0"
    exit 0
}

# Parse arguments
while [[ $# -gt 0 ]]; do
    case "$1" in
        --no-sddm)   INSTALL_SDDM=false; shift ;;
        --no-icons)  INSTALL_ICONS=false; shift ;;
        --no-gtk)    INSTALL_GTK=false; shift ;;
        --no-apply)  APPLY_THEME=false; shift ;;
        -h|--help)   usage ;;
        *)           error "Unknown option: $1"; usage ;;
    esac
done

# -------------------------------------------------------------------
# Step 1: Check dependencies
# -------------------------------------------------------------------
info "Checking dependencies..."

MISSING=()
for cmd in kvantummanager; do
    if ! command -v "$cmd" &>/dev/null; then
        MISSING+=("$cmd")
    fi
done

if [[ ${#MISSING[@]} -gt 0 ]]; then
    error "Missing required commands: ${MISSING[*]}"
    if command -v dnf &>/dev/null; then
        echo "  Install them with: sudo dnf install kvantum"
    elif command -v apt &>/dev/null; then
        echo "  Install them with: sudo apt install qt6-style-kvantum"
    elif command -v pacman &>/dev/null; then
        echo "  Install them with: sudo pacman -S kvantum"
    else
        echo "  Install: kvantum"
    fi
    exit 1
fi

if $APPLY_THEME; then
    for cmd in plasma-apply-desktoptheme plasma-apply-colorscheme; do
        if ! command -v "$cmd" &>/dev/null; then
            warn "$cmd not found — theme will be installed but not applied automatically"
            APPLY_THEME=false
        fi
    done
fi

ok "Dependencies satisfied"

# -------------------------------------------------------------------
# Step 2: Copy Plasma desktop theme
# -------------------------------------------------------------------
PLASMA_THEME_DIR="$HOME/.local/share/plasma/desktoptheme"
mkdir -p "$PLASMA_THEME_DIR"

info "Installing Plasma desktop theme: DDCmacOsTahoeKdeTheme-Dark..."
cp -a "$SCRIPT_DIR/plasma/desktoptheme/DDCmacOsTahoeKdeTheme-Dark" "$PLASMA_THEME_DIR/"
ok "DDCmacOsTahoeKdeTheme-Dark desktop theme installed"

# -------------------------------------------------------------------
# Step 3: Copy look-and-feel package
# -------------------------------------------------------------------
LAF_DIR="$HOME/.local/share/plasma/look-and-feel"
mkdir -p "$LAF_DIR"

info "Installing look-and-feel: DDCmacOsTahoeKdeTheme-Dark..."
cp -a "$SCRIPT_DIR/plasma/look-and-feel/com.github.ddc.DDCmacOsTahoeKdeTheme-Dark" "$LAF_DIR/"
ok "DDCmacOsTahoeKdeTheme-Dark look-and-feel installed"

# -------------------------------------------------------------------
# Step 4: Copy Aurorae window decorations
# -------------------------------------------------------------------
AURORAE_DIR="$HOME/.local/share/aurorae/themes"
mkdir -p "$AURORAE_DIR"

info "Installing Aurorae decorations: DDCmacOsTahoeKdeTheme-Dark..."
cp -a "$SCRIPT_DIR/aurorae/themes/DDCmacOsTahoeKdeTheme-Dark" "$AURORAE_DIR/"
cp -a "$SCRIPT_DIR/aurorae/themes/DDCmacOsTahoeKdeTheme-Dark-1.25x" "$AURORAE_DIR/"
cp -a "$SCRIPT_DIR/aurorae/themes/DDCmacOsTahoeKdeTheme-Dark-1.5x" "$AURORAE_DIR/"
ok "DDCmacOsTahoeKdeTheme-Dark Aurorae decorations installed"

# -------------------------------------------------------------------
# Step 5: Copy color scheme
# -------------------------------------------------------------------
COLOR_DIR="$HOME/.local/share/color-schemes"
mkdir -p "$COLOR_DIR"

info "Installing color scheme: DDCmacOsTahoeKdeThemeDark..."
cp -a "$SCRIPT_DIR/color-schemes/DDCmacOsTahoeKdeThemeDark.colors" "$COLOR_DIR/"
ok "DDCmacOsTahoeKdeThemeDark color scheme installed"

# -------------------------------------------------------------------
# Step 6: Copy Kvantum theme
# -------------------------------------------------------------------
KVANTUM_DIR="$HOME/.config/Kvantum/DDCmacOsTahoeKdeTheme"
mkdir -p "$KVANTUM_DIR"

info "Installing Kvantum theme: DDCmacOsTahoeKdeTheme..."
cp -a "$SCRIPT_DIR/kvantum/DDCmacOsTahoeKdeTheme/"* "$KVANTUM_DIR/"
ok "Kvantum theme installed"

# -------------------------------------------------------------------
# Step 7: Copy sound theme
# -------------------------------------------------------------------
SOUNDS_DIR="$HOME/.local/share/sounds"
mkdir -p "$SOUNDS_DIR"

info "Installing sound theme: DDCmacOsTahoeKdeTheme Sounds..."
cp -a "$SCRIPT_DIR/sounds/DDCmacOsTahoeKdeTheme Sounds" "$SOUNDS_DIR/"
ok "DDCmacOsTahoeKdeTheme Sounds installed"

# -------------------------------------------------------------------
# Step 8: Install bundled icons and cursors
# -------------------------------------------------------------------
if $INSTALL_ICONS; then
    ICON_DIR="$HOME/.local/share/icons"
    mkdir -p "$ICON_DIR"

    info "Installing DDCmacOsTahoeKdeTheme-icons-dark..."
    cp -a "$SCRIPT_DIR/icons/DDCmacOsTahoeKdeTheme-icons-dark" "$ICON_DIR/"
    ok "Icon theme installed"

    # -------------------------------------------------------------------
    # Step 9: Install bundled cursors
    # -------------------------------------------------------------------
    info "Installing DDCmacOsTahoeKdeTheme cursors..."
    cp -a "$SCRIPT_DIR/cursors/DDCmacOsTahoeKdeTheme" "$ICON_DIR/"
    cp -a "$SCRIPT_DIR/cursors/DDCmacOsTahoeKdeTheme-dark" "$ICON_DIR/"

    # Fix cursor aliases: upstream uses text-content alias files instead of symlinks.
    # KDE's cursor KCM calls XcursorFilenameLoadAllImages("cursors/left_ptr") to
    # detect available sizes, but libXcursor can't follow text aliases — only symlinks.
    # Without this fix, the cursor size dropdown won't appear in System Settings.
    info "Converting cursor text aliases to symlinks..."
    for cursor_theme in DDCmacOsTahoeKdeTheme DDCmacOsTahoeKdeTheme-dark; do
        cursor_dir="${ICON_DIR}/${cursor_theme}/cursors"
        if [[ -d "$cursor_dir" ]]; then
            for f in "$cursor_dir"/*; do
                if [[ -f "$f" ]] && file "$f" | grep -q "ASCII text"; then
                    target=$(cat "$f")
                    rm "$f"
                    ln -s "$target" "$f"
                fi
            done
        fi
    done
    ok "Cursor aliases fixed"

    # Add 36px and 40px cursor sizes (upstream only ships 18,24,32,48,64,72).
    # Scales from 32px→36px and 48px→40px using Pillow.
    if command -v python3 &>/dev/null && python3 -c "from PIL import Image" 2>/dev/null; then
        info "Adding 36px and 40px cursor sizes..."
        python3 "$SCRIPT_DIR/scripts/add_cursor_sizes.py" \
            "${ICON_DIR}/DDCmacOsTahoeKdeTheme/cursors" \
            "${ICON_DIR}/DDCmacOsTahoeKdeTheme-dark/cursors"
        ok "Cursor sizes 36 and 40 added"
    else
        warn "python3-pillow not found — skipping extra cursor sizes (36, 40)"
    fi

    # Fix PyCharm cursor: replace size_hor with col-resize symlink
    info "Fixing PyCharm cursor (size_hor → col-resize)..."
    for cursor_theme in DDCmacOsTahoeKdeTheme DDCmacOsTahoeKdeTheme-dark; do
        cursor_dir="${ICON_DIR}/${cursor_theme}/cursors"
        if [[ -d "$cursor_dir" ]] && [[ -e "$cursor_dir/size_hor" ]] && [[ ! -e "$cursor_dir/col-resize" ]]; then
            ln -s size_hor "$cursor_dir/col-resize"
        fi
    done
    ok "PyCharm cursor fix applied"
else
    warn "Skipping icon/cursor installation (--no-icons)"
fi

# -------------------------------------------------------------------
# Step 10: Install bundled GTK theme
# -------------------------------------------------------------------
if $INSTALL_GTK; then
    GTK_DIR="$HOME/.themes"
    mkdir -p "$GTK_DIR"

    info "Installing GTK theme: DDCmacOsTahoeKdeTheme-Dark..."
    cp -a "$SCRIPT_DIR/gtk/themes/DDCmacOsTahoeKdeTheme-Dark" "$GTK_DIR/"
    ok "GTK theme installed"
else
    warn "Skipping GTK theme installation (--no-gtk)"
fi

# -------------------------------------------------------------------
# Step 11: Install SDDM theme (requires sudo)
# -------------------------------------------------------------------
if $INSTALL_SDDM; then
    info "Installing SDDM theme: DDCmacOsTahoeKdeTheme-Dark (requires sudo)..."
    sudo cp -a "$SCRIPT_DIR/sddm/DDCmacOsTahoeKdeTheme-Dark" /usr/share/sddm/themes/
    ok "SDDM theme installed"
else
    warn "Skipping SDDM theme installation (--no-sddm)"
fi

# -------------------------------------------------------------------
# Step 12: Apply theme
# -------------------------------------------------------------------
if $APPLY_THEME; then
    info "Applying dark theme..."
    plasma-apply-colorscheme DDCmacOsTahoeKdeThemeDark
    plasma-apply-desktoptheme DDCmacOsTahoeKdeTheme-Dark
    kvantummanager --set DDCmacOsTahoeKdeThemeDark

    # Set Aurorae decoration
    kwriteconfig6 --file kwinrc --group org.kde.kdecoration2 --key library "org.kde.kwin.aurorae"
    kwriteconfig6 --file kwinrc --group org.kde.kdecoration2 --key theme "__aurorae__svg__DDCmacOsTahoeKdeTheme-Dark"

    # Set icons and cursor
    kwriteconfig6 --file kdeglobals --group Icons --key Theme "DDCmacOsTahoeKdeTheme-icons-dark"
    kwriteconfig6 --file kcminputrc --group Mouse --key cursorTheme "DDCmacOsTahoeKdeTheme"
    kwriteconfig6 --file kcminputrc --group Mouse --key cursorSize "32"

    # Set application style
    kwriteconfig6 --file kdeglobals --group KDE --key widgetStyle "kvantum-dark"

    # Set sound theme
    kwriteconfig6 --file kdeglobals --group Sounds --key Theme "DDCmacOsTahoeKdeTheme Sounds"

    ok "Dark theme applied"

    # Reload KWin to pick up decoration changes
    qdbus6 org.kde.KWin /KWin reconfigure 2>/dev/null || true
else
    warn "Skipping theme application (--no-apply)"
fi

# -------------------------------------------------------------------
# Step 13: Clear Plasma SVG cache
# -------------------------------------------------------------------
info "Clearing Plasma SVG cache..."
rm -f "$HOME/.cache/plasma_theme_"*.kcache
rm -rf "$HOME/.cache/ksvg-elements/"
ok "Cache cleared"

# -------------------------------------------------------------------
# Done
# -------------------------------------------------------------------
echo ""
ok "DDCmacOsTahoeKdeTheme v${VERSION} installation complete!"
echo ""
echo "Notes:"
echo "  - Log out and back in for all changes to take effect"
echo "  - To reinstall without icons/GTK/SDDM:"
echo "    ./install.sh --no-icons --no-gtk --no-sddm"
echo ""
echo "  Thunderbird/Betterbird dark theme (optional):"
echo "    1. Copy extras/userChrome.css to your profile's chrome/ folder"
echo "    2. Copy extras/user.js to your profile root folder"
echo "    3. Restart Thunderbird/Betterbird"
