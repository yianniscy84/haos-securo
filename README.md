# Securo — Home Assistant Addon

Self-hosted personal finance manager for Home Assistant. All-in-one: PostgreSQL, Redis, FastAPI backend, React frontend, Celery worker+beat.

![Securo](securo/icon.png)

## Features

- Multi-account tracking with running balances
- Transaction management with search, filters, and CSV export
- File import: OFX, QIF, CAMT, CSV
- Auto-categorization rules engine
- Recurring transactions and budgets
- Goals and savings targets with progress tracking
- Asset management with valuation tracking
- Reports: Net Worth, Income vs Expenses
- Bank sync via Pluggy, Enable Banking, or SimpleFIN
- Multi-currency support with automatic FX conversion
- 2FA (TOTP), passkeys, and OIDC login
- Multi-user support with admin panel
- Optional AI agents and MCP (opt-in via `agents_enabled`)

## Installation

### Add-on Store (recommended)

1. Open **Settings → Add-ons → Add-on Store**
2. Click the three dots (⋮) → **Repositories**
3. Add `https://github.com/yianniscy84/haos-securo`
4. Find **Securo** and install it
5. Configure the options and start the addon

HAOS pulls pre-built images from GHCR — no local build required.

## Configuration

| Option | Description | Default |
|---|---|---|
| `secret_key` | Session signing key. Leave empty to auto-generate. | `""` |
| `frontend_url` | Public URL of the app | `""` |
| `debug` | Enable debug logging | `false` |
| `db_password` | PostgreSQL password | `postgres` |

### Bank Sync

| Option | Description |
|---|---|
| `pluggy_client_id` | Pluggy Client ID |
| `pluggy_client_secret` | Pluggy Client Secret |
| `enable_banking_app_id` | Enable Banking Application ID |
| `simplefin_enabled` | Enable SimpleFIN (`true`/`false`) |

### OIDC

| Option | Description |
|---|---|
| `oidc_enabled` | Enable OIDC login |
| `oidc_provider_name` | Display name |
| `oidc_discovery_url` | `.well-known/openid-configuration` URL |
| `oidc_client_id` | OIDC client ID |
| `oidc_client_secret` | OIDC client secret |

### AI agents and MCP

Off by default. Enable `agents_enabled` to start the MCP server and Agents UI.

| Option | Description | Default |
|---|---|---|
| `agents_enabled` | Enable AI agents and the built-in MCP server | `false` |
| `agents_mcp_jwt_secret` | MCP JWT secret (auto-generated if empty) | `""` |
| `agents_external_mcp_url` | Public MCP URL shown in the UI | `""` |
| `agents_extra_mcp_servers` | Extra MCP servers `URL[|name],...` | `""` |
| `agents_embedding_provider` | Embeddings: `ollama`, `openai`, or `openai_compatible` | `ollama` |

Point Claude Desktop, Cursor, n8n, or Home Assistant’s MCP client at `http://<ha-host>:8765/mcp` or `http://<ha-host>:<port-80>/mcp` with a Bearer token minted in **Agents → Connections**. Do not use the HA ingress URL. Native/fastembed embeddings are not available on Alpine.

## Accessing the App

After installation, Securo is available:

- **Home Assistant sidebar** — Ingress enabled by default (web UI only; not for MCP clients)
- **Port 80** — Direct HTTP access on your HA host (`/mcp` when agents are enabled)
- **Port 8765** — Built-in MCP JSON-RPC endpoint when agents are enabled

## Architecture

```
┌─────────────────────────────────────┐
│         Home Assistant OS            │
│                                      │
│  ┌──────────────────────────────┐   │
│  │      Securo Addon            │   │
│  │                              │   │
│  │  Nginx :80                   │   │
│  │    ├── / → React SPA         │   │
│  │    ├── /api/ → Uvicorn :8000 │   │
│  │    ├── /ws/  → Uvicorn :8000 │   │
│  │    └── /mcp  → MCP :8765     │   │
│  │                              │   │
│  │  PostgreSQL :5432            │   │
│  │  Redis :6379                 │   │
│  │  Celery worker + beat        │   │
│  │  MCP server :8765 (opt-in)   │   │
│  └──────────────────────────────┘   │
└─────────────────────────────────────┘
```

## Development

```bash
# Build locally — run from the securo/ addon directory
cd securo
docker build -t securo-addon .

# Run
docker run -d --name securo-test \
  -p 8080:80 \
  -p 8765:8765 \
  -v securo-data:/data \
  securo-addon

# Open http://localhost:8080
```

### Update Securo source

```bash
# Update bundled backend
rm -rf securo/backend
cp -r /path/to/securo/backend securo/backend

# Update bundled frontend
rm -rf securo/frontend
cp -r /path/to/securo/frontend securo/frontend

# Rebuild
docker build -t securo-addon .
```

## Release

```bash
# 1. Bump version in securo/config.yaml
# 2. Commit
git add securo/config.yaml && git commit -m "release: 0.27.0"
# 3. Tag + push
git tag 0.27.0 && git push origin main --tags
```

CI builds multi-arch images (amd64 + aarch64) → GHCR. HAOS detects the version change and pulls the new image automatically.

## Links

- [Securo upstream](https://github.com/securo-finance/securo)
- [Documentation](https://docs.usesecuro.com/)
- [Discord](https://discord.gg/rUqTKtQ9S4)
- [HA Addon Docs](https://developers.home-assistant.io/docs/apps/)
