#!/usr/bin/env bash
# Simple uninstaller for Gemz (matches the installer above).
# Usage: sudo ./uninstall_gemz.sh
set -euo pipefail

if [ "$(id -u)" -ne 0 ]; then
  echo "Please run with sudo: sudo $0"
  exit 1
fi

APP="/Applications/Gemz.app"
SHIM="/usr/local/bin/gemz"
SUPPORT_DIRS=(
  "/Library/Application Support/Gemz"
  "$HOME/Library/Application Support/Gemz"
)

echo "This will remove Gemz from this machine. Press Enter to continue, Ctrl-C to abort."
read -r

if [ -d "$APP" ]; then
  echo "Removing $APP"
  rm -rf "$APP"
else
  echo "$APP not found, skipping."
fi

if [ -f "$SHIM" ]; then
  echo "Removing shim $SHIM"
  rm -f "$SHIM"
else
  echo "$SHIM not found, skipping."
fi

for d in "${SUPPORT_DIRS[@]}"; do
  if [ -e "$d" ]; then
    echo "Removing $d"
    rm -rf "$d"
  fi
done

# Try to forget a pkg receipt if one exists (harmless if not)
PKG_ID="com.jammy8603.Gemz"
if /usr/sbin/pkgutil --pkg-info "$PKG_ID" >/dev/null 2>&1; then
  echo "Forgetting pkg receipt: $PKG_ID"
  /usr/sbin/pkgutil --forget "$PKG_ID"
fi

echo "Uninstall complete."
