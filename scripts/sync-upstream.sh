#!/usr/bin/env bash
# Refresh upstream/ from microsoft/playwright packages/extension (main). Prints "changed" or
# "unchanged"; exit 0 either way. Does not build or commit.
set -euo pipefail
cd "$(dirname "$0")/.."
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT
git clone -q --filter=blob:none --no-checkout --depth 1 https://github.com/microsoft/playwright "$tmp/pw"
git -C "$tmp/pw" sparse-checkout set packages/extension
git -C "$tmp/pw" checkout -q
sha="$(git -C "$tmp/pw" rev-parse HEAD)"
if [ "$sha" = "$(cat UPSTREAM_SHA 2>/dev/null)" ]; then echo "unchanged $sha"; exit 0; fi
rm -rf upstream && mkdir upstream && cp -R "$tmp/pw/packages/extension/." upstream/ && rm -rf upstream/node_modules upstream/dist
echo "$sha" >UPSTREAM_SHA
echo "changed $sha"
