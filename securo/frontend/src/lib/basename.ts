// Detect Home Assistant ingress base path (e.g. /2afa7cbc_securo).
// Falls back to empty string for direct access (no prefix).
export const basename =
  window.location.pathname.match(/\/[a-f0-9]+_[a-z][a-z0-9-]*/)?.[0] ?? ''
