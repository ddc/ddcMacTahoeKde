#!/bin/bash
# Reads the version from the VERSION file and updates all metadata files to match.
#
# Usage: Edit VERSION, then run ./bump_version.sh

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

NEW_VERSION="$(cat "$ROOT_DIR/VERSION")"

if ! [[ "$NEW_VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "Error: VERSION file must contain a semver version (e.g. 1.2.0)"
    exit 1
fi

echo "Syncing metadata files to version $NEW_VERSION"

# Update metadata.json files ("Version": "x.y.z")
while IFS= read -r -d '' file; do
    sed -i "s/\"Version\": \"[0-9]\+\.[0-9]\+\.[0-9]\+\"/\"Version\": \"$NEW_VERSION\"/" "$file"
    echo "  Updated ${file#"$ROOT_DIR/"}"
done < <(find "$ROOT_DIR" -name "metadata.json" -print0)

# Update metadata.desktop files (X-KDE-PluginInfo-Version=x.y.z and Version=x.y.z)
while IFS= read -r -d '' file; do
    sed -i "s/^X-KDE-PluginInfo-Version=.*/X-KDE-PluginInfo-Version=$NEW_VERSION/" "$file"
    sed -i "s/^Version=[0-9]\+\.[0-9]\+\.[0-9]\+$/Version=$NEW_VERSION/" "$file"
    echo "  Updated ${file#"$ROOT_DIR/"}"
done < <(find "$ROOT_DIR" -name "metadata.desktop" -print0)

echo ""
echo "Done. All metadata files updated to $NEW_VERSION"
