#!/usr/bin/env bash
set -e

echo "=== Installing Plymouth Theme ==="

# Configuration
PACK="pack_3"
THEME_NAME="metal_ball"
THEME_REPO="https://github.com/adi1090x/plymouth-themes"
THEME_SOURCE_DIR="/tmp/plymouth-themes/$PACK/$THEME_NAME"
THEME_TARGET_DIR="/usr/share/plymouth/themes/$THEME_NAME"

# Clone repo
TMP_DIR="/tmp/plymouth-themes"
git clone --depth=1 "$THEME_REPO" "$TMP_DIR"

# Copy selected theme
mkdir -p "$(dirname "$THEME_TARGET_DIR")"
cp -r "$THEME_SOURCE_DIR" "$THEME_TARGET_DIR"

# Set theme
plymouth-set-default-theme "$THEME_NAME"

# Clean up
rm -rf "$TMP_DIR"

echo "=== Plymouth theme '$THEME_NAME' set successfully ==="
