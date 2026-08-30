#!/usr/bin/env bash
# Simple installer for Gemz WITHOUT using pkgbuild/productbuild.
# Usage:
# 1) If you have Gemz.app in the same folder: ./install_gemz.sh Gemz.app
# 2) If you have a zip in the same folder: ./install_gemz.sh Gemz-0.3.6-beta.zip
# Requires: sudo for writing to /Applications
set -euo pipefail

show_usage() {
  echo "Usage: $0 <Gemz.app | Gemz-*.zip>"
  exit 2
}

if [ "$#" -ne 1 ]; then
  show_usage
fi

SRC="$1"
TMPDIR="$(mktemp -d)"
cleanup() { rm -rf "$TMPDIR"; }
trap cleanup EXIT

# If source is a zip, unzip it to TMPDIR
if [[ "$SRC" == *.zip ]]; then
  if [ ! -f "$SRC" ]; then
    echo "Zip not found: $SRC"
    exit 1
  fi
  echo "Unzipping $SRC..."
  unzip -q "$SRC" -d "$TMPDIR"
  # find Gemz.app inside tmp
  APP_PATH="$(find "$TMPDIR" -maxdepth 2 -type d -name 'Gemz.app' -print -quit || true)"
  if [ -z "$APP_PATH" ]; then
    echo "Could not find Gemz.app inside the zip."
    exit 1
  fi
else
  # treat an .app path or name
  if [ -d "$SRC" ]; then
    APP_PATH="$SRC"
  else
    echo "App not found: $SRC"
    exit 1
  fi
fi

echo "Preparing to install: $APP_PATH"
if [ "$(id -u)" -ne 0 ]; then
  echo "This installer needs sudo to copy to /Applications."
  echo "You will be prompted for your password."
fi

DEST="/Applications/Gemz.app"

# Use ditto (preferred) to preserve metadata
echo "Copying to $DEST..."
sudo mkdir -p "$(dirname "$DEST")"
sudo /usr/bin/ditto -v "$APP_PATH" "$DEST"

# Create a lightweight CLI shim if an executable exists in the app bundle
# Adjust path to exectuable inside the app if necessary
BIN_SHIM="/usr/local/bin/gemz"
BUNDLE_EXEC="$DEST/Contents/MacOS/Gemz"
if [ -x "$BUNDLE_EXEC" ]; then
  echo "Installing CLI shim at $BIN_SHIM"
  sudo mkdir -p /usr/local/bin
  sudo tee "$BIN_SHIM" >/dev/null <<'EOF'
#!/usr/bin/env bash
exec "$BUNDLE_EXEC" "\$@"
EOF
  sudo chmod +x "$BIN_SHIM"
else
  echo "No executable found at $BUNDLE_EXEC; skipping CLI shim."
fi

echo "Installation complete."
echo "You can open the app from /Applications/Gemz.app or run 'gemz' if the shim was created."
