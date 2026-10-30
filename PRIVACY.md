# Privacy policy - Playwright Extension (quiet)

Last updated: 2026-10-30

Playwright Extension (quiet) is a fork of Microsoft's Playwright Extension. It connects the
browser it is installed in to a Playwright MCP or Playwright CLI client running on the same
machine, over the Chrome DevTools Protocol.

- The extension collects no personal data and sends nothing to the developer or to any third
  party. It communicates only with processes on the local machine (127.0.0.1): the Playwright
  client's relay and, optionally, the local "broker" that asks it to open connect pages.
- The only data it stores is a random per-profile authentication token, kept in the extension's
  own storage in the browser profile, so that the local client can connect without a dialog.
- Pages the connected client automates are controlled by that client, which the user runs
  themselves; the extension does not read, log or transmit page content on its own.
- No analytics, no remote code, no accounts.

The "PWQ Publisher" Google Cloud OAuth client that publishes this extension to the Chrome Web
Store is used only by the developer's own CI to upload builds; it never touches end users.

Questions: open an issue at https://github.com/pmaxhogan/playwright-extension-quiet/issues
