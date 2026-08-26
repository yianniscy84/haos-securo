# AGENTS.md

## What This Is

A Home Assistant OS addon (addon) that bundles [securo-finance/securo](https://github.com/securo-finance/securo) as an all-in-one container: PostgreSQL, Redis, FastAPI backend, React frontend, Celery worker+beat, and an optional MCP server. It is NOT a standalone app — it runs inside HA OS using `bashio` and `s6-overlay`.

## Build & Run

```bash
# Local build — run from the securo/ addon directory
cd securo
docker build -t securo-addon .

# Quick smoke test
docker run -d --name securo-test -p 8080:80 -p 8765:8765 -v securo-data:/data securo-addon
# Open http://localhost:8080
```

CI builds happen on tag push → GHCR. Local builds default to `alpine:3.21` via `BUILD_FROM` arg. CI overrides with `ghcr.io/home-assistant/${{ matrix.arch }}-base:latest`.

**Important**: The Dockerfile lives at `securo/Dockerfile` and the build context is the `securo/` directory. All COPY paths are relative to `securo/` — do NOT prefix with `securo/`.

## Repo Structure

- `Dockerfile` — Multi-stage: node frontend → python Alpine backend-deps → Alpine runtime
- `run.sh` — Entry script (`#!/usr/bin/with-contenv bashio`). Reads HA options, starts all services, handles shutdown
- `config.yaml` — HA addon manifest (options schema, ports, ingress, arch support). Has `image:` field for GHCR-based auto-updates
- `nginx.conf` — Reverse proxy: serves frontend static files, proxies `/api/` and `/ws/` to localhost:8000, proxies `/mcp` to localhost:8765
- `securo/backend/` — Bundled Python source (FastAPI, SQLAlchemy, Celery). Use `pyproject.toml` + `uv.lock` for deps
- `securo/frontend/` — Bundled React/Vite source. Built in Docker stage 1
- `.github/workflows/build.yaml` — CI: multi-arch build (amd64 + aarch64) → GHCR

## Key Quirks

- **No `requirements.txt`**. Backend deps use `uv export --frozen --no-emit-project` then `pip install`. If you need to debug deps, the lockfile is `securo/backend/uv.lock`.
- **Alpine runtime = musl**. Python packages must have musllinux wheels. `onnxruntime` (from `fastembed`) is the known blocker — has no musl wheel.
- **`run.sh` uses `bashio`** (HA's bash library). All `bashio::config` calls read from `/data/options.json`. Don't replace with plain env reads.
- **Entry point**: `uvicorn app.main:app` (FastAPI). App module is at `securo/backend/app/main.py`.
- **Celery**: `celery -A app.worker worker/beat`. Worker and beat run as background processes, not s6 services.
- **AI agents / MCP (opt-in)**: `agents_enabled` in addon options maps to `AGENTS_ENABLED`. When true, `run.sh` starts `uvicorn mcp_server.main:app` on port 8765 and the backend mounts `/api/agents`. JWT secret is persisted at `/data/mcp_jwt_secret` if not set. Do not add `fastembed` on Alpine (no musl `onnxruntime` wheel); default embedding provider is `ollama`.
- **Database**: PostgreSQL 16, data persisted to `/data/postgres`. Migrations via `alembic upgrade head` on startup. Requires `pgcrypto` (provided by the `postgresql16-contrib` package) and `pgvector` (built from source in the Dockerfile runtime stage) to complete migrations.
- **Redis**: Used for Celery broker + cache. No persistence (`appendonly no --save ""`).
- **Ingress**: Addon appears in HA sidebar. Ingress port is 80, entry path is `/`. MCP clients must use mapped port 80 `/mcp` or port 8765, not ingress.
- **Port 80**: Exposed for non-ingress access (direct HTTP), including `/mcp` when agents are enabled.
- **Port 8765**: Built-in MCP JSON-RPC (JWT required) when agents are enabled.

## Adding Dependencies

Backend: edit `securo/backend/pyproject.toml`, run `uv lock` to update `uv.lock`, commit both.
Frontend: edit `securo/frontend/package.json`, run `npm install` in that directory, commit `package-lock.json`.

## CI

Tag push triggers `.github/workflows/build.yaml`. Push a tag to release:
```bash
git tag 0.26.1 && git push origin 0.26.1
```

**Image-based addon**: `config.yaml` has `image: ghcr.io/yianniscy84/haos-securo`. HAOS pulls pre-built images from GHCR instead of building locally. To release:
1. Bump `version` in `securo/config.yaml`
2. **Update `securo/CHANGELOG.md`** with a new section for the version
3. Commit + push a tag matching the version
4. CI builds multi-arch images → GHCR
5. HAOS detects version change → pulls new image

**IMPORTANT**: Always update `securo/CHANGELOG.md` when bumping the version. Add a new `## X.Y.Z` section describing what changed.

## Troubleshooting

- Build fails with `hash mismatch` in pip install → lockfile is stale, regenerate `uv.lock`
- Build fails with `onnxruntime` → musl issue. Either switch runtime to Debian (`python:3.12-slim`) or remove `fastembed` from pyproject.toml
- Container starts but backend errors → check `DATABASE_URL` format: `postgresql+asyncpg://postgres:<password>@localhost:5432/securo`
- `bashio` not found in logs → entry script shebang must be `#!/usr/bin/with-contenv bashio`
- Migration fails with `pgvector is not installed` or `pgcrypto is not available` → ensure `postgresql16-contrib` is installed and `pgvector` compiled successfully in the Dockerfile.
- Startup fails with Pydantic validation error (`ValidationError`) for boolean variables like `debug` → check if `/data/options.json` is missing or empty inside the container. `run.sh` will auto-generate a default one on startup if it is not present.
