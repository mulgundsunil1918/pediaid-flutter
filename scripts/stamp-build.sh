#!/usr/bin/env bash
# Stamps build/web with a build id so the app can detect its own staleness.
#
# Run after `flutter build web`. Writes version.json and substitutes the
# __BUILD_ID__ placeholder in index.html with the same value, so the running
# page can compare what it IS against what is deployed.
set -euo pipefail
DIR="${1:-build/web}"
BUILD_ID="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
printf '{"buildId":"%s"}' "$BUILD_ID" > "$DIR/version.json"
# macOS and GNU sed differ on -i; write through a temp file instead.
sed "s/__BUILD_ID__/$BUILD_ID/g" "$DIR/index.html" > "$DIR/index.html.tmp"
mv "$DIR/index.html.tmp" "$DIR/index.html"
echo "stamped $DIR with buildId=$BUILD_ID"
