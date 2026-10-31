# Chrome Web Store listing (unlisted)

Drafted 2026-10-30 for the developer console item under pmaxhogan's account (item id djphaomahfdjobipmjingddpnnihknnk, uploaded as version 0.4.0.2, status Draft). Visibility:
Unlisted. Everything below is pasted into the console by hand or by an agent; keep it in sync
with the manifest.

## Store listing

- Title (from manifest): Playwright Extension (quiet)
- Summary (from manifest description, max 132 chars):
  Fork of the Playwright Extension that never steals keyboard focus: connect pages and new tabs open in unfocused windows.
- Category: Developer Tools
- Language: English (United States)
- Detailed description:

  A fork of Microsoft's Playwright Extension (Apache-2.0) for people who run AI agents against
  their own logged-in Chrome while they keep typing in other apps.

  The stock extension focuses its window every time a client connects and lands new tabs in the
  window you are using, which activates Chrome and steals keystrokes. This fork:
  - never calls chrome.windows.update({focused: true}) on connect;
  - opens new client tabs in the client's own window instead of your current one;
  - creates each client's tab group in that window;
  - opens connect pages in an unfocused window when asked to by a local broker on
    127.0.0.1:47117 (optional; without it the extension behaves like upstream minus the focus
    calls). The broker is a small open-source script in pmaxhogan/claude-shortcuts (pw/broker.mjs).

  Works with Playwright MCP and the Playwright CLI in --extension mode exactly like the original.
  Source, patches and the upstream sync: https://github.com/pmaxhogan/playwright-extension-quiet

- Icon: upstream icons/icon-128.png (unchanged)
- Note: the first tab in each agent window is an unpinned page bundled in the extension (title.html), titled with the agent name and showing the Claude Code icon (no network).
- The store zip is built WITHOUT the manifest key (the store rejects it); the store assigns its own id on first upload, so the store install has a different id from the unpacked dev install (jiobfmhnaneikbfofhbdkklfgennkcmn).
- Screenshots: at least one 1280x800 screenshot is required; capture the status page
  (chrome-extension://jiobfmhnaneikbfofhbdkklfgennkcmn/status.html) at 1280x800.
- Official URL / homepage: https://github.com/pmaxhogan/playwright-extension-quiet
- Support URL: https://github.com/pmaxhogan/playwright-extension-quiet/issues

## Privacy practices

- Single purpose: Connect the browser to a local Playwright MCP/CLI client without focusing windows.
- Permission justifications:
  - debugger: attaches the Chrome DevTools Protocol to the tabs the client controls (core function, same as upstream).
  - tabs, tabGroups: create and group the client's tabs in its own window.
  - activeTab: upstream requirement for the connect flow.
  - alarms: periodically reconnect the service worker to the local broker.
  - storage: store the per-profile auth token so the broker can route a connect to the right profile.
  - host permissions <all_urls>: the client may navigate to any site the user chooses (same as upstream).
- Remote code: No. Data use: no data collected or transmitted; the extension only talks to
  127.0.0.1 (the MCP relay and the broker). Certify compliance with the developer program policies.

## Distribution

- Visibility: Unlisted
- Regions: all
- Pricing: free
