#!/bin/bash
# ddcMacTahoeKde Theme Installer
# Installs the ddcMacTahoeKde dark theme suite with Breeze Dark-aligned colors.
#
# Usage: ./install.sh [OPTIONS]
#
# Options:
#   --no-sddm       Skip SDDM theme installation
#   --no-icons      Skip icon/cursor theme download & install
#   --no-gtk        Skip GTK theme download & build
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
for cmd in kvantummanager sassc git; do
    if ! command -v "$cmd" &>/dev/null; then
        MISSING+=("$cmd")
    fi
done

if [[ ${#MISSING[@]} -gt 0 ]]; then
    error "Missing required commands: ${MISSING[*]}"
    if command -v dnf &>/dev/null; then
        echo "  Install them with: sudo dnf install kvantum sassc git"
    elif command -v apt &>/dev/null; then
        echo "  Install them with: sudo apt install qt6-style-kvantum sassc git"
    elif command -v pacman &>/dev/null; then
        echo "  Install them with: sudo pacman -S kvantum sassc git"
    else
        echo "  Install: kvantum, sassc, git"
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

info "Installing Plasma desktop theme: ddcMacTahoeKde-Dark..."
cp -a "$SCRIPT_DIR/plasma/desktoptheme/ddcMacTahoeKde-Dark" "$PLASMA_THEME_DIR/"
ok "ddcMacTahoeKde-Dark desktop theme installed"

# -------------------------------------------------------------------
# Step 3: Copy look-and-feel package
# -------------------------------------------------------------------
LAF_DIR="$HOME/.local/share/plasma/look-and-feel"
mkdir -p "$LAF_DIR"

info "Installing look-and-feel: ddcMacTahoeKde-Dark..."
cp -a "$SCRIPT_DIR/plasma/look-and-feel/com.github.ddc.ddcMacTahoeKde-Dark" "$LAF_DIR/"
ok "ddcMacTahoeKde-Dark look-and-feel installed"

# -------------------------------------------------------------------
# Step 4: Copy Aurorae window decorations
# -------------------------------------------------------------------
AURORAE_DIR="$HOME/.local/share/aurorae/themes"
mkdir -p "$AURORAE_DIR"

info "Installing Aurorae decorations: ddcMacTahoeKde-Dark..."
cp -a "$SCRIPT_DIR/aurorae/themes/ddcMacTahoeKde-Dark" "$AURORAE_DIR/"
cp -a "$SCRIPT_DIR/aurorae/themes/ddcMacTahoeKde-Dark-1.25x" "$AURORAE_DIR/"
cp -a "$SCRIPT_DIR/aurorae/themes/ddcMacTahoeKde-Dark-1.5x" "$AURORAE_DIR/"
ok "ddcMacTahoeKde-Dark Aurorae decorations installed"

# -------------------------------------------------------------------
# Step 5: Copy color scheme
# -------------------------------------------------------------------
COLOR_DIR="$HOME/.local/share/color-schemes"
mkdir -p "$COLOR_DIR"

info "Installing color scheme: ddcMacTahoeKdeDark..."
cp -a "$SCRIPT_DIR/color-schemes/ddcMacTahoeKdeDark.colors" "$COLOR_DIR/"
ok "ddcMacTahoeKdeDark color scheme installed"

# -------------------------------------------------------------------
# Step 6: Copy Kvantum theme
# -------------------------------------------------------------------
KVANTUM_DIR="$HOME/.config/Kvantum/ddcMacTahoeKde"
mkdir -p "$KVANTUM_DIR"

info "Installing Kvantum theme: ddcMacTahoeKde..."
cp -a "$SCRIPT_DIR/kvantum/ddcMacTahoeKde/"* "$KVANTUM_DIR/"
ok "Kvantum theme installed"

# -------------------------------------------------------------------
# Step 7: Copy MacOS Sounds
# -------------------------------------------------------------------
SOUNDS_DIR="$HOME/.local/share/sounds"
mkdir -p "$SOUNDS_DIR"

info "Installing sound theme: MacOS Sounds..."
cp -a "$SCRIPT_DIR/sounds/MacOS Sounds" "$SOUNDS_DIR/"
ok "MacOS Sounds installed"

# -------------------------------------------------------------------
# Step 8: Download & install WhiteSur icons
# -------------------------------------------------------------------
if $INSTALL_ICONS; then
    TMPDIR="$(mktemp -d)"
    trap 'rm -rf "$TMPDIR"' EXIT

    info "Downloading WhiteSur icon theme..."
    git clone --depth 1 https://github.com/vinceliuice/WhiteSur-icon-theme.git "$TMPDIR/WhiteSur-icon-theme"
    info "Installing WhiteSur icons..."
    "$TMPDIR/WhiteSur-icon-theme/install.sh"
    ok "WhiteSur icons installed"

    # Patch WhiteSur close icons — replace red circle with Breeze's simple X
    info "Patching WhiteSur close icons (replacing red circles with Breeze X)..."
    ICON_DIR="$HOME/.local/share/icons"
    for variant in WhiteSur-dark WhiteSur-light; do
        if [[ "$variant" == *dark* ]]; then
            BREEZE_VARIANT="breeze-dark"
        else
            BREEZE_VARIANT="breeze"
        fi
        for size in 16 22 24 32; do
            for name in window-close dialog-close document-close view-close view-left-close view-right-close; do
                src="/usr/share/icons/${BREEZE_VARIANT}/actions/${size}/${name}.svg"
                dst="${ICON_DIR}/${variant}/actions/${size}/${name}.svg"
                if [[ -f "$src" && -f "$dst" ]]; then
                    cp "$src" "$dst"
                fi
            done
        done
    done
    ok "Close icons patched"

    # -------------------------------------------------------------------
    # Step 9: Download & install MacTahoe icons/cursors
    # -------------------------------------------------------------------
    info "Downloading MacTahoe icon theme..."
    git clone --depth 1 https://github.com/vinceliuice/MacTahoe-icon-theme.git "$TMPDIR/MacTahoe-icon-theme"
    info "Installing MacTahoe icons and cursors..."
    "$TMPDIR/MacTahoe-icon-theme/install.sh"
    ok "MacTahoe icons and cursors installed"

    # Fix cursor aliases: upstream uses text-content alias files instead of symlinks.
    # KDE's cursor KCM calls XcursorFilenameLoadAllImages("cursors/left_ptr") to
    # detect available sizes, but libXcursor can't follow text aliases — only symlinks.
    # Without this fix, the cursor size dropdown won't appear in System Settings.
    info "Converting cursor text aliases to symlinks..."
    for cursor_theme in MacTahoe MacTahoe-dark MacTahoe-light; do
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
            "${ICON_DIR}/MacTahoe/cursors" \
            "${ICON_DIR}/MacTahoe-dark/cursors" \
            "${ICON_DIR}/MacTahoe-light/cursors"
        ok "Cursor sizes 36 and 40 added"
    else
        warn "python3-pillow not found — skipping extra cursor sizes (36, 40)"
    fi

    # Fix PyCharm cursor: replace size_hor with col-resize symlink
    info "Fixing PyCharm cursor (size_hor → col-resize)..."
    for cursor_theme in MacTahoe MacTahoe-dark MacTahoe-light; do
        cursor_dir="${ICON_DIR}/${cursor_theme}/cursors"
        if [[ -d "$cursor_dir" ]] && [[ -e "$cursor_dir/size_hor" ]] && [[ ! -e "$cursor_dir/col-resize" ]]; then
            ln -s size_hor "$cursor_dir/col-resize"
        fi
    done
    ok "PyCharm cursor fix applied"

    trap - EXIT
    rm -rf "$TMPDIR"
else
    warn "Skipping icon theme installation (--no-icons)"
fi

# -------------------------------------------------------------------
# Step 10: Download & build GTK theme
# -------------------------------------------------------------------
if $INSTALL_GTK; then
    TMPDIR="$(mktemp -d)"

    info "Downloading MacTahoe GTK theme..."
    git clone --depth 1 https://github.com/vinceliuice/MacTahoe-gtk-theme.git "$TMPDIR/MacTahoe-gtk-theme"

    info "Applying Breeze Dark color patch..."
    patch -p1 -d "$TMPDIR/MacTahoe-gtk-theme" < "$SCRIPT_DIR/gtk/colors.patch"

    info "Building & installing GTK dark theme..."
    "$TMPDIR/MacTahoe-gtk-theme/install.sh" -c dark --darker

    ok "MacTahoe GTK dark theme installed"
    rm -rf "$TMPDIR"
else
    warn "Skipping GTK theme build (--no-gtk)"
fi

# -------------------------------------------------------------------
# Step 11: Install SDDM theme (requires sudo)
# -------------------------------------------------------------------
if $INSTALL_SDDM; then
    info "Installing SDDM theme: ddcMacTahoeKde-Dark (requires sudo)..."
    sudo cp -a "$SCRIPT_DIR/sddm/ddcMacTahoeKde-Dark" /usr/share/sddm/themes/
    ok "SDDM theme installed"
else
    warn "Skipping SDDM theme installation (--no-sddm)"
fi

# -------------------------------------------------------------------
# Step 12: Apply theme
# -------------------------------------------------------------------
if $APPLY_THEME; then
    info "Applying dark theme..."
    plasma-apply-colorscheme ddcMacTahoeKdeDark
    plasma-apply-desktoptheme ddcMacTahoeKde-Dark
    kvantummanager --set ddcMacTahoeKdeDark

    # Set Aurorae decoration
    kwriteconfig6 --file kwinrc --group org.kde.kdecoration2 --key library "org.kde.kwin.aurorae"
    kwriteconfig6 --file kwinrc --group org.kde.kdecoration2 --key theme "__aurorae__svg__ddcMacTahoeKde-Dark"

    # Set icons and cursor
    kwriteconfig6 --file kdeglobals --group Icons --key Theme "WhiteSur-dark"
    kwriteconfig6 --file kcminputrc --group Mouse --key cursorTheme "MacTahoe"
    kwriteconfig6 --file kcminputrc --group Mouse --key cursorSize "32"

    # Set application style
    kwriteconfig6 --file kdeglobals --group KDE --key widgetStyle "kvantum-dark"

    # Set sound theme
    kwriteconfig6 --file kdeglobals --group Sounds --key Theme "MacOS Sounds"

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
ok "ddcMacTahoeKde v${VERSION} installation complete!"
echo ""
echo "Notes:"
echo "  - Log out and back in for all changes to take effect"
echo "  - To reinstall without downloading icons/GTK/SDDM:"
echo "    ./install.sh --no-icons --no-gtk --no-sddm"
echo ""
echo "  Thunderbird/Betterbird dark theme (optional):"
echo "    1. Copy extras/userChrome.css to your profile's chrome/ folder"
echo "    2. Copy extras/user.js to your profile root folder"
echo "    3. Restart Thunderbird/Betterbird"
