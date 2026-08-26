// Detect Home Assistant ingress base path (e.g. /api/hassio_ingress/<token>).
// Falls back to empty string for direct access (no prefix).
export const basename =
  window.location.pathname.match(/\/api\/hassio_ingress\/[A-Za-z0-9_-]+/)?.[0] ?? ''
