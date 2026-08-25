# AGENTS.md

## What This Is

A Home Assistant OS addon (addon) that bundles [securo-finance/securo](https://github.com/securo-finance/securo) as an all-in-one container: PostgreSQL, Redis, FastAPI backend, React frontend, Celery worker+beat. It is NOT a standalone app — it runs inside HA OS using `bashio` and `s6-overlay`.

## Build & Run

```bash
# Local build (Alpine base — no HA base image needed)
docker build -t securo-addon .

# Quick smoke test
docker run -d --name securo-test -p 8080:80 -v securo-data:/data securo-addon
# Open http://localhost:8080
```

CI builds happen on tag push → GHCR. Local builds default to `alpine:3.21` via `BUILD_FROM` arg. CI overrides with `ghcr.io/home-assistant/${{ matrix.arch }}-base:latest`.

## Repo Structure

- `Dockerfile` — Multi-stage: node frontend → python Alpine backend-deps → Alpine runtime
- `run.sh` — Entry script (`#!/usr/bin/with-contenv bashio`). Reads HA options, starts all services, handles shutdown
- `config.yaml` — HA addon manifest (options schema, ports, ingress, arch support)
- `nginx.conf` — Reverse proxy: serves frontend static files, proxies `/api/` and `/ws/` to localhost:8000
- `securo/backend/` — Bundled Python source (FastAPI, SQLAlchemy, Celery). Use `pyproject.toml` + `uv.lock` for deps
- `securo/frontend/` — Bundled React/Vite source. Built in Docker stage 1
- `.github/workflows/build.yaml` — CI: multi-arch build (amd64 + aarch64) → GHCR

## Key Quirks

- **No `requirements.txt`**. Backend deps use `uv export --frozen --no-emit-project` then `pip install`. If you need to debug deps, the lockfile is `securo/backend/uv.lock`.
- **Alpine runtime = musl**. Python packages must have musllinux wheels. `onnxruntime` (from `fastembed`) is the known blocker — has no musl wheel.
- **`run.sh` uses `bashio`** (HA's bash library). All `bashio::config` calls read from `/data/options.json`. Don't replace with plain env reads.
- **Entry point**: `uvicorn app.main:app` (FastAPI). App module is at `securo/backend/app/main.py`.
- **Celery**: `celery -A app.worker worker/beat`. Worker and beat run as background processes, not s6 services.
- **AI agents disabled**: `AGENTS_ENABLED=false` in run.sh. Don't re-enable without user asking.
- **Database**: PostgreSQL 16, data persisted to `/data/postgres`. Migrations via `alembic upgrade head` on startup. Requires `pgcrypto` (provided by the `postgresql16-contrib` package) and `pgvector` (built from source in the Dockerfile runtime stage) to complete migrations.
- **Redis**: Used for Celery broker + cache. No persistence (`appendonly no --save ""`).
- **Ingress**: Addon appears in HA sidebar. Ingress port is 80, entry path is `/`.
- **Port 80**: Exposed for non-ingress access (direct HTTP).

## Adding Dependencies

Backend: edit `securo/backend/pyproject.toml`, run `uv lock` to update `uv.lock`, commit both.
Frontend: edit `securo/frontend/package.json`, run `npm install` in that directory, commit `package-lock.json`.

## CI

Tag push triggers `.github/workflows/build.yaml`. Push a tag to release:
```bash
git tag 0.26.1 && git push origin 0.26.1
```

## Troubleshooting

- Build fails with `hash mismatch` in pip install → lockfile is stale, regenerate `uv.lock`
- Build fails with `onnxruntime` → musl issue. Either switch runtime to Debian (`python:3.12-slim`) or remove `fastembed` from pyproject.toml
- Container starts but backend errors → check `DATABASE_URL` format: `postgresql+asyncpg://postgres:<password>@localhost:5432/securo`
- `bashio` not found in logs → entry script shebang must be `#!/usr/bin/with-contenv bashio`
- Migration fails with `pgvector is not installed` or `pgcrypto is not available` → ensure `postgresql16-contrib` is installed and `pgvector` compiled successfully in the Dockerfile.
- Startup fails with Pydantic validation error (`ValidationError`) for boolean variables like `debug` → check if `/data/options.json` is missing or empty inside the container. `run.sh` will auto-generate a default one on startup if it is not present.
