# Upstream Tracker

This file tracks the upstream `securo-finance/securo` version the HAOS addon is based on.

| Field | Value |
|-------|-------|
| Upstream repo | https://github.com/securo-finance/securo |
| Upstream version | v0.14.5 |
| Last synced | 2026-08-28 |
| Addon version | 0.29.0 |

## Sync Notes

- Backend and frontend code are copied from upstream, then HAOS-specific modifications are re-applied
- HAOS-modified files (do not overwrite on sync):
  - `securo-test/backend/pyproject.toml` — fastembed excluded (musl incompatibility), ruff/ty pins
  - `securo-test/frontend/src/lib/basename.ts` — ingress base path detection
  - `securo-test/frontend/src/App.tsx` — `<BrowserRouter basename={basename}>`
  - `securo-test/frontend/src/lib/api.ts` — basename in baseURL + login redirect
  - `securo-test/frontend/vite.config.ts` — `base: './'` for relative asset paths
- `uv.lock` must be regenerated after syncing `pyproject.toml` (`uv lock`)
- `frontend/dist/` is NOT committed — built during `docker build`
