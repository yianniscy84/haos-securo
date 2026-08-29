# AGENTS.md

This repository contains **four Home Assistant OS addons** (no CI, no pre-built images — HAOS builds from source on version bump):

| Addon | Type | Upstream | Key Stack |
|-------|------|----------|-----------|
| `securo/` | Production | securo-finance/securo | Python/FastAPI, React, PostgreSQL 16, Redis, Celery, Alpine |
| `securo-test/` | Test | securo-finance/securo | Same as securo, ports 81/8766 |
| `omniroute/` | Production | diegosouzapw/OmniRoute | Node.js (upstream image), Redis, Nginx, Debian |
| `omniroute-test/` | Test | diegosouzapw/OmniRoute | Same as omniroute, port 20129 |

Users add `https://github.com/yianniscy84/hassio-addons` once → all four appear in HAOS.

## Build & Run (Local Smoke Test)

```bash
# Securo (from securo/ dir)
cd securo
docker build -t securo-addon .
docker run -d --name securo-test -p 8080:80 -p 8765:8765 -v securo-data:/data securo-addon
# http://localhost:8080

# OmniRoute (from omniroute/ dir)
cd omniroute
docker build -t omniroute-addon .
docker run -d --name omniroute-test -p 80:80 -p 20128:20128 -v omniroute-data:/data omniroute-addon
# http://localhost (ingress) or http://localhost:20128

```

**Dockerfile context is the addon directory** — COPY paths are relative to that dir (no `securo/` or `omniroute/` prefix).

## Repo Structure

```
hassio-addons/
├── README.md
├── repository.yaml          # HAOS discovers addons from this
├── AGENTS.md
├── securo/                  # Production: slug=securo, ports 8080/8765
│   ├── Dockerfile
│   ├── run.sh               # #!/usr/bin/with-contenv bashio
│   ├── config.yaml
│   ├── nginx.conf
│   ├── backend/             # Python: pyproject.toml, uv.lock, alembic
│   ├── frontend/            # React: package.json, vite
│   ├── translations/
│   ├── CHANGELOG.md
│   └── bashio_stub.sh, with-contenv
├── securo-test/             # Test: slug=securo-test, ports 81/8766
├── omniroute/               # Production: slug=omniroute, port 20128
│   ├── Dockerfile           # FROM diegosouzapw/omniroute:latest
│   ├── run.sh               # #!/usr/bin/with-contenv bashio
│   ├── config.yaml
│   ├── nginx.conf
│   ├── bashio_stub.sh, with-contenv
│   ├── CHANGELOG.md
│   └── updater.json
└── omniroute-test/          # Test: slug=omniroute-test, port 20129
```

## Key Quirks — Securo (Python/Alpine)

- **No `requirements.txt`** — deps via `uv export --frozen --no-emit-project` → `pip install`. Lockfile: `securo/backend/uv.lock`.
- **Alpine = musl** — Python packages need musllinux wheels. `onnxruntime` (from `fastembed`) has **no musl wheel** — blocker.
- **`run.sh` uses `bashio`** — reads `/data/options.json`. Don't replace with plain env reads.
- **Entrypoint**: `uvicorn app.main:app` (FastAPI at `securo/backend/app/main.py`).
- **Celery**: `celery -A app.worker worker/beat` — background processes, not s6 services.
- **AI agents (opt-in)**: `agents_enabled` → `AGENTS_ENABLED`. Starts MCP on 8765. JWT secret at `/data/mcp_jwt_secret`. Default embedding: `ollama`.
- **Database**: PostgreSQL 16 at `/data/postgres`. Migrations: `alembic upgrade head` on startup. Needs `pgcrypto` (postgresql16-contrib) and `pgvector` (built from source in Dockerfile).
- **Redis**: Celery broker + cache. No persistence (`appendonly no --save ""`).
- **Ingress**: Port 80, entry `/`. MCP clients use mapped port 80 `/mcp` or 8765, not ingress.

## Key Quirks — OmniRoute (Node.js/Debian)

- **Upstream image base**: `diegosouzapw/omniroute:latest` — no source build.
- **Runtime deps installed in Dockerfile**: `redis-server`, `nginx`, `curl`, `tzdata`, `python3`.
- **`run.sh` starts**: Redis → Nginx (port 80) → OmniRoute (`node dev/run-standalone.mjs` on 20128).
- **Secrets persisted** at `/data/jwt_secret`, `/data/api_key_secret` (generated on first run).
- **Default password**: `omniroute` if `initial_password` not set.
- **Env vars exported** in `run.sh` — `JWT_SECRET`, `API_KEY_SECRET`, `REDIS_URL`, etc.
- **No PostgreSQL/Celery** — simpler stack.

## Adding Dependencies

| Addon | Backend | Frontend |
|-------|---------|----------|
| Securo | Edit `securo/backend/pyproject.toml` → `uv lock` → commit both | Edit `securo/frontend/package.json` → `npm install` → commit `package-lock.json` |
| OmniRoute | N/A (upstream image) | N/A (upstream image) |

## Releasing (All Addons)

1. Bump `version` in `<addon>/config.yaml`
2. **Update `<addon>/CHANGELOG.md`** with `## X.Y.Z` section
3. Commit + push
4. HAOS detects version change → rebuilds from source automatically

**ALWAYS update CHANGELOG.md when bumping version.** Incomplete without it.

## Troubleshooting

| Issue | Cause | Fix |
|-------|-------|-----|
| `hash mismatch` in pip install | Stale `uv.lock` | Regenerate: `cd securo/backend && uv lock` |
| `onnxruntime` build fail | No musl wheel | Switch to Debian base or remove `fastembed` |
| Backend errors on start | Wrong `DATABASE_URL` | Format: `postgresql+asyncpg://postgres:<pw>@localhost:5432/securo` |
| `bashio` not found | Shebang wrong | Must be `#!/usr/bin/with-contenv bashio` |
| Migration fails: pgvector/pgcrypto | Missing in Dockerfile | Ensure `postgresql16-contrib` + pgvector compile |
| Pydantic ValidationError (bool) | Missing `/data/options.json` | `run.sh` auto-generates default; check volume mount |
| OmniRoute: Redis/Nginx fail | Port conflict or permission | Check `run.sh` order: Redis → Nginx → App |

## Updater

Each addon has `updater.json` with `upstream_version` and `last_update` for README badges. Update manually or via script when upstream releases.