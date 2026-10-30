# playwright-extension-quiet

A fork of Microsoft's Playwright Chrome extension (Apache-2.0) that never steals keyboard focus.
Stock Playwright MCP extension mode raises Chrome and focuses the connect page every time an
agent attaches, which interrupts whatever you are typing. This fork removes that.

## What the fork changes

1. No `chrome.windows.update({ focused: true })` on connect. Attaching never raises a window.
2. `chrome.tabs.create` is aimed at the client's own window, and tab groups are created in
   that window, so one agent's tabs do not land in another agent's (or your) window.
3. A local broker client opens connect pages in unfocused windows. The broker lives in
   `pmaxhogan/claude-shortcuts` at `pw/broker.mjs`.

The changes are one unified diff, `patches/0001-quiet.patch`. Everything else is a verbatim
copy of upstream.

## Layout

- `upstream/`: verbatim copy of `packages/extension` from microsoft/playwright at the sha in `UPSTREAM_SHA`.
- `patches/`: this fork's changes, applied with `patch -p1` onto a copy in `build/`.
- `scripts/sync-upstream.sh`: refreshes `upstream/` and `UPSTREAM_SHA`, prints `changed <sha>` or `unchanged <sha>`.
- `scripts/build.sh`: copy, patch, stamp manifest, `tsc` + `vite`, write `dist/` and the zip.
- `VERSION_SUFFIX`: manifest version is `<upstream version>.<suffix>`.
- `pubkey.b64`: public half of the signing key, set as the manifest `key`.

## Build

```sh
npm ci && scripts/build.sh
```

Output: `dist/` and `playwright-extension-quiet-<version>.zip`. Needs Node 22+.

## Load unpacked

1. Open `chrome://extensions` and turn on Developer mode.
2. Click Load unpacked and pick the `dist/` directory.

The extension id is stable: `jiobfmhnaneikbfofhbdkklfgennkcmn`. It is derived from the manifest
`key` (`pubkey.b64`), so unpacked and Web Store installs get the same id. The private key
(`key.pem`) is kept out of the repo and is gitignored.

## Automation

- `ci.yml`: every push and PR runs `npm run check-ascii`, builds, and uploads the zip. No secrets needed.
- `sync-upstream.yml`: daily at 06:00 UTC (and manually). If upstream moved, it builds. On success
  it bumps `VERSION_SUFFIX` (reset to 1 when the upstream version changed, else +1, because the
  Web Store needs a strictly higher version per upload), commits `chore: sync upstream to <sha>`
  to main, and calls `publish.yml`. On a build failure (patch conflict or compile error) it opens
  or updates one issue titled "Upstream sync failed: patches no longer apply" and the run goes red.
- `publish.yml`: runs on pushes to main that touch `upstream/`, `patches/`, `scripts/`,
  `VERSION_SUFFIX` or `package.json`, on manual dispatch, and when called by the sync workflow.
  It builds, uploads to the Chrome Web Store with `chrome-webstore-upload-cli`, and creates a
  GitHub release `v<manifest version>` with the zip. If tag `v<version>` already exists it does
  nothing. If the secrets below are empty it skips the upload with a notice, so the repo works
  before the store listing exists (the GitHub release is still created).
- Dependabot: weekly npm and Actions updates, minor and patch grouped, auto-merged on green CI
  via `gh pr merge --auto --squash`.

Pushes made with `GITHUB_TOKEN` do not trigger other workflows, which is why the sync workflow
calls the publish workflow directly instead of relying on the push trigger.

## Secrets

Set in the repo's Actions secrets:

| Secret | What |
| --- | --- |
| `CWS_EXTENSION_ID` | Item id of the Web Store listing (from the developer dashboard URL) |
| `CWS_CLIENT_ID` | OAuth client id (Google Cloud, Desktop app type) |
| `CWS_CLIENT_SECRET` | OAuth client secret |
| `CWS_REFRESH_TOKEN` | Refresh token from the one-time consent flow |

To get them: create a Google Cloud project, enable the Chrome Web Store API, configure the OAuth
consent screen, create a Desktop OAuth client, then run the one-time consent flow to exchange the
code for a refresh token. Follow the step-by-step guide in the
[chrome-webstore-upload-cli README](https://github.com/fregante/chrome-webstore-upload-cli) and
[chrome-webstore-upload keys](https://github.com/fregante/chrome-webstore-upload/blob/main/How%20to%20generate%20Google%20API%20keys.md).
The first upload must be done by hand in the developer dashboard to create the listing.

## Attribution and license

Apache-2.0, see `LICENSE`. `upstream/` is Microsoft's code, copied verbatim; see `NOTICE`.
This project is not affiliated with or endorsed by Microsoft.
