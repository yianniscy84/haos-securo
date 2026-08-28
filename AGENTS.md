# AGENTS.md

## What This Is

A Home Assistant OS addon (addon) that bundles [securo-finance/securo](https://github.com/securo-finance/securo) as an all-in-one container: PostgreSQL, Redis, FastAPI backend, React frontend, Celery worker+beat, and an optional MCP server. It is NOT a standalone app — it runs inside HA OS using `bashio` and `s6-overlay`.

This repository contains two addons:
- **Securo** (production)
- **Securo Test** (testing/experiments)

Users add `https://github.com/yianniscy84/haos-securo` once in HAOS → both addons appear.

## Build & Run

```bash
# Local build — run from the securo/ addon directory
cd securo
docker build -t securo-addon .

# Quick smoke test
docker run -d --name securo-test -p 8080:80 -p 8765:8765 -v securo-data:/data securo-addon
# Open http://localhost:8080
```

Both production and test addons build from source locally via HAOS. No CI or pre-built images required.

**Important**: The Dockerfile lives at `securo/Dockerfile` and the build context is the `securo/` directory. All COPY paths are relative to `securo/` — do NOT prefix with `securo/` inside the Dockerfile.

## Repo Structure

```
haos_securo/                       # Single addon repository
├── README.md
├── repository.yaml                # HAOS discovers all addons from this
├── securo/                        # Production addon
│   ├── Dockerfile
│   ├── run.sh
│   ├── config.yaml                # slug: securo, ports: 8080, 8765
│   ├── nginx.conf
│   ├── backend/
│   ├── frontend/
│   ├── translations/
│   ├── CHANGELOG.md
│   ├── DOCS.md
│   ├── icon.png, logo.png
│   ├── bashio_stub.sh
│   └── with-contenv
└── securo-test/                   # Test addon
    ├── Dockerfile
    ├── run.sh
    ├── config.yaml                # slug: securo-test, ports: 81, 8766
    ├── nginx.conf
    ├── backend/
    ├── frontend/
    ├── translations/
    ├── CHANGELOG.md
    ├── DOCS.md
    ├── icon.png, logo.png
    ├── bashio_stub.sh
    └── with-contenv
```

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
- **Port 8080**: Exposed for non-ingress access (direct HTTP), including `/mcp` when agents are enabled.
- **Port 8765**: Built-in MCP JSON-RPC (JWT required) when agents are enabled.

## Adding Dependencies

Backend: edit `securo/backend/pyproject.toml`, run `uv lock` to update `uv.lock`, commit both.
Frontend: edit `securo/frontend/package.json`, run `npm install` in that directory, commit `package-lock.json`.

## Releasing

1. Bump `version` in `securo/config.yaml`
2. **Update `securo/CHANGELOG.md`** with a new section for the version
3. Commit + push
4. HAOS detects version change → rebuilds from source automatically

**IMPORTANT — ALWAYS update `securo/CHANGELOG.md` when bumping the version.** Add a new `## X.Y.Z` section describing what changed. If you bump the version without updating the changelog, the release is incomplete.

## Troubleshooting

- Build fails with `hash mismatch` in pip install → lockfile is stale, regenerate `uv.lock`
- Build fails with `onnxruntime` → musl issue. Either switch runtime to Debian (`python:3.12-slim`) or remove `fastembed` from pyproject.toml
- Container starts but backend errors → check `DATABASE_URL` format: `postgresql+asyncpg://postgres:<password>@localhost:5432/securo`
- `bashio` not found in logs → entry script shebang must be `#!/usr/bin/with-contenv bashio`
- Migration fails with `pgvector is not installed` or `pgcrypto is not available` → ensure `postgresql16-contrib` is installed and `pgvector` compiled successfully in the Dockerfile.
- Startup fails with Pydantic validation error (`ValidationError`) for boolean variables like `debug` → check if `/data/options.json` is missing or empty inside the container. `run.sh` will auto-generate a default one on startup if it is not present.
