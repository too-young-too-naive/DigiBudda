#!/usr/bin/env bash
#
# build.sh — Compile DigiBudda into a macOS .app bundle without Xcode.
#
# Usage:
#   ./build.sh              Build the app
#   ./build.sh run          Build and launch
#   ./build.sh install      Build and copy to /Applications
#   ./build.sh clean        Remove build artifacts
#
set -euo pipefail

APP_NAME="DigiBudda"
BUILD_DIR="build"
APP_BUNDLE="${BUILD_DIR}/${APP_NAME}.app"
CONTENTS="${APP_BUNDLE}/Contents"
MACOS_DIR="${CONTENTS}/MacOS"
RESOURCES="${CONTENTS}/Resources"
SRC_DIR="DigiBudda"
MIN_MACOS="14.0"

SDK=$(xcrun --show-sdk-path)
ARCH=$(uname -m)

# ──────────────────────────────────────────────
# Clean
# ──────────────────────────────────────────────
if [[ "${1:-}" == "clean" ]]; then
    rm -rf "$BUILD_DIR"
    echo "✓ Cleaned."
    exit 0
fi

echo "═══════════════════════════════════════════"
echo "  Building ${APP_NAME}.app"
echo "  SDK:  ${SDK}"
echo "  Arch: ${ARCH}"
echo "═══════════════════════════════════════════"

# ──────────────────────────────────────────────
# 1. Generate placeholder sound if missing
# ──────────────────────────────────────────────
SOUND_FILE="${SRC_DIR}/Resources/woodenfish.wav"
if [[ ! -f "${SOUND_FILE}" && ! -f "${SRC_DIR}/Resources/woodenfish.mp3" ]]; then
    echo "→ Generating placeholder wooden fish sound…"
    python3 scripts/generate_sound.py "${SOUND_FILE}"
fi

# ──────────────────────────────────────────────
# 2. Collect all Swift source files
# ──────────────────────────────────────────────
SWIFT_FILES=()
while IFS= read -r -d '' f; do
    SWIFT_FILES+=("$f")
done < <(find "${SRC_DIR}" -name '*.swift' -print0)

echo "→ Compiling ${#SWIFT_FILES[@]} Swift files…"

# ──────────────────────────────────────────────
# 3. Compile
# ──────────────────────────────────────────────
mkdir -p "${MACOS_DIR}" "${RESOURCES}"

swiftc \
    -target "${ARCH}-apple-macosx${MIN_MACOS}" \
    -sdk "${SDK}" \
    -swift-version 5 \
    -O \
    -framework AppKit \
    -framework SwiftUI \
    -framework AVFoundation \
    -framework Combine \
    -o "${MACOS_DIR}/${APP_NAME}" \
    "${SWIFT_FILES[@]}"

echo "✓ Compiled binary: ${MACOS_DIR}/${APP_NAME}"

# ──────────────────────────────────────────────
# 4. Assemble .app bundle
# ──────────────────────────────────────────────

# Info.plist with full metadata
cat > "${CONTENTS}/Info.plist" << 'PLIST'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN"
  "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleName</key>
    <string>DigiBudda</string>
    <key>CFBundleDisplayName</key>
    <string>DigiBudda</string>
    <key>CFBundleIdentifier</key>
    <string>com.digibudda.app</string>
    <key>CFBundleVersion</key>
    <string>1</string>
    <key>CFBundleShortVersionString</key>
    <string>1.0.0</string>
    <key>CFBundleExecutable</key>
    <string>DigiBudda</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>LSUIElement</key>
    <true/>
    <key>LSMinimumSystemVersion</key>
    <string>14.0</string>
    <key>CFBundleIconFile</key>
    <string>AppIcon</string>
    <key>NSHighResolutionCapable</key>
    <true/>
</dict>
</plist>
PLIST

# Copy sound file(s)
for ext in wav mp3 m4a aiff caf; do
    src="${SRC_DIR}/Resources/woodenfish.${ext}"
    [[ -f "$src" ]] && cp "$src" "${RESOURCES}/" && echo "✓ Bundled: woodenfish.${ext}"
done

# Copy app icon
if [[ -f "${SRC_DIR}/Resources/AppIcon.icns" ]]; then
    cp "${SRC_DIR}/Resources/AppIcon.icns" "${RESOURCES}/"
    echo "✓ Bundled: AppIcon.icns"
fi

# Copy menu bar icon (template image)
for f in menubar_icon.png menubar_icon@2x.png; do
    if [[ -f "${SRC_DIR}/Resources/${f}" ]]; then
        cp "${SRC_DIR}/Resources/${f}" "${RESOURCES}/"
    fi
done
echo "✓ Bundled: menu bar icon"

echo "✓ App bundle ready: ${APP_BUNDLE}"

# ──────────────────────────────────────────────
# 5. Post-build action
# ──────────────────────────────────────────────
case "${1:-}" in
    run)
        echo "→ Launching ${APP_NAME}…"
        open "${APP_BUNDLE}"
        ;;
    install)
        echo "→ Installing to /Applications…"
        rm -rf "/Applications/${APP_NAME}.app"
        cp -R "${APP_BUNDLE}" "/Applications/${APP_NAME}.app"
        echo "✓ Installed: /Applications/${APP_NAME}.app"
        echo "  Launch from Spotlight or: open /Applications/${APP_NAME}.app"
        ;;
    *)
        echo ""
        echo "Next steps:"
        echo "  ./build.sh run        Launch the app"
        echo "  ./build.sh install    Copy to /Applications"
        ;;
esac
