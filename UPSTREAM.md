# Upstream Tracker

This file tracks the upstream `securo-finance/securo` version each addon is based on.

## Version Matrix

| Addon | Upstream Version | Addon Version | Last Synced |
|-------|-----------------|---------------|-------------|
| `securo/` (production) | v0.14.5 | 0.29.0 | 2026-08-28 |
| `securo-test/` (test) | v0.14.5 | 0.29.0 | 2026-08-28 |

The production and test addons track different upstream versions. Test gets updates first; production is synced after testing.

## Upstream Repo

https://github.com/securo-finance/securo

## Sync Notes

- Backend and frontend code are copied from upstream, then HAOS-specific modifications are re-applied
- HAOS-modified files (do not overwrite on sync):
  - `*/backend/pyproject.toml` — fastembed excluded (musl incompatibility), ruff/ty pins
  - `*/frontend/src/lib/basename.ts` — ingress base path detection
  - `*/frontend/src/App.tsx` — `<BrowserRouter basename={basename}>`
  - `*/frontend/src/lib/api.ts` — basename in baseURL + login redirect
  - `*/frontend/vite.config.ts` — `base: './'` for relative asset paths
- `uv.lock` must be regenerated after syncing `pyproject.toml` (`uv lock`)
- `frontend/dist/` is NOT committed — built during `docker build`
