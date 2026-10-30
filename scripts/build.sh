#!/usr/bin/env bash
# Build the quiet fork: copy upstream/, apply patches/, stamp the manifest, vite build into dist/,
# zip for the Chrome Web Store. Idempotent; run from anywhere.
#   scripts/build.sh            # dist/ + playwright-extension-quiet-<version>.zip
#   VERSION_SUFFIX=3 scripts/build.sh   # manifest version <upstream>.3 (default: from VERSION_SUFFIX file)
set -euo pipefail
cd "$(dirname "$0")/.."
suffix="${VERSION_SUFFIX:-$(cat VERSION_SUFFIX 2>/dev/null || echo 1)}"
rm -rf build dist
cp -R upstream build
for p in patches/*.patch; do
  echo "applying $p"
  patch -p1 -d build --no-backup-if-mismatch <"$p"
done
node - "$suffix" <<'JS'
const fs = require("fs");
const suffix = process.argv[2];
const m = JSON.parse(fs.readFileSync("build/manifest.json", "utf8"));
const upstreamVersion = m.version;
m.name = "Playwright Extension (quiet)";
m.version = `${upstreamVersion}.${suffix}`;
m.version_name = `${upstreamVersion}-quiet.${suffix}`;
m.description = "Fork of the Playwright Extension that never steals keyboard focus: connect pages and new tabs open in unfocused windows through a local broker. " + m.description;
m.permissions = [...new Set([...(m.permissions || []), "alarms", "storage"])];
m.action.default_title = m.name;
// Stable extension id for unpacked and Web Store installs: the public key of key.pem
// (pmaxhogan's, kept out of the repo). The Web Store honours a manifest key on upload.
m.key = fs.readFileSync("pubkey.b64", "utf8").trim();
fs.writeFileSync("build/manifest.json", JSON.stringify(m, null, 2) + "\n");
const pkg = JSON.parse(fs.readFileSync("package.json", "utf8"));
const bp = JSON.parse(fs.readFileSync("build/package.json", "utf8"));
bp.devDependencies = pkg.devDependencies;
bp.scripts = { build: "vite build" };
fs.writeFileSync("build/package.json", JSON.stringify(bp, null, 2) + "\n");
console.log(`manifest ${m.version} (${m.version_name})`);
JS
ln -sfn ../node_modules build/node_modules
(cd build && npx tsc -p tsconfig.json && npx tsc -p tsconfig.ui.json && npx vite build >/dev/null)
mv build/dist dist
version="$(node -p 'require("./dist/manifest.json").version')"
rm -f playwright-extension-quiet-*.zip
(cd dist && zip -qr "../playwright-extension-quiet-$version.zip" .)
echo "built dist/ and playwright-extension-quiet-$version.zip"
