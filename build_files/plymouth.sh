
#!/usr/bin/env bash
set -e

echo "=== Installing Plymouth Theme ==="

# Theme selection — change this to whichever you want
THEME_NAME="metal_ball"
THEME_REPO="https://github.com/adi1090x/plymouth-themes"
THEME_DIR="/usr/share/plymouth/themes/$THEME_NAME"

# Clone themes repo into temporary location
TMP_DIR="/tmp/plymouth-themes"
git clone --depth=1 "$THEME_REPO" "$TMP_DIR"

# Copy selected theme into system themes directory
mkdir -p "$(dirname "$THEME_DIR")"
cp -r "$TMP_DIR/$THEME_NAME" "$THEME_DIR"

# Set theme
plymouth-set-default-theme -R "$THEME_NAME"

# Clean up
rm -rf "$TMP_DIR"

echo "=== Plymouth theme '$THEME_NAME' set successfully ==="
