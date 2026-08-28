# Upstream Tracker

This file tracks upstream versions for each addon.

## Version Matrix

### Securo (securo-finance/securo)

| Addon | Upstream Version | Addon Version | Last Synced |
|-------|-----------------|---------------|-------------|
| `securo/` (production) | v0.14.5 | 0.29.0 | 2026-08-28 |
| `securo-test/` (test) | v0.14.5 | 0.29.0 | 2026-08-28 |

The production and test addons track different upstream versions. Test gets updates first; production is synced after testing.

### OmniRoute (diegosouzapw/OmniRoute)

| Addon | Upstream Version | Addon Version | Last Synced |
|-------|-----------------|---------------|-------------|
| `omniroute/` (production) | v3.8.50 | 0.1.0 | 2026-08-28 |
| `omniroute-test/` (test) | release branch | 0.1.0 | 2026-08-28 |

The production addon pins a specific release tag. The test addon tracks the upstream `release` branch (pre-release).

## Upstream Repos

- https://github.com/securo-finance/securo
- https://github.com/diegosouzapw/OmniRoute

## Sync Notes

### Securo

- Backend and frontend code are copied from upstream, then HAOS-specific modifications are re-applied
- HAOS-modified files (do not overwrite on sync):
  - `*/backend/pyproject.toml` — fastembed excluded (musl incompatibility), ruff/ty pins
  - `*/frontend/src/lib/basename.ts` — ingress base path detection
  - `*/frontend/src/App.tsx` — `<BrowserRouter basename={basename}>`
  - `*/frontend/src/lib/api.ts` — basename in baseURL + login redirect
  - `*/frontend/vite.config.ts` — `base: './'` for relative asset paths
- `uv.lock` must be regenerated after syncing `pyproject.toml` (`uv lock`)
- `frontend/dist/` is NOT committed — built during `docker build`

### OmniRoute

- Source is cloned from upstream during `docker build` (not committed to this repo)
- Production addon clones a specific release tag (`release/v{VERSION}`)
- Test addon clones the `release` branch (latest pre-release)
- HAOS-specific files are maintained in this repo:
  - `*/run.sh` — entry script (bashio, Redis, secrets generation)
  - `*/config.yaml` — addon manifest (ports, options, schema)
  - `*/nginx.conf` — reverse proxy with SSE/WebSocket support
  - `*/Dockerfile` — multi-stage build from source + bundled Redis
