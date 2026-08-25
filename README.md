# Securo — Home Assistant Addon

Self-hosted personal finance manager for Home Assistant. All-in-one: PostgreSQL, Redis, FastAPI backend, React frontend, Celery worker+beat.

![Securo](icon.png)

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

## Installation

### HACS (recommended)

1. Add this repository as a custom addon repository in Home Assistant
2. Navigate to **Settings → Add-ons → Add-on Store**
3. Find **Securo** and install it
4. Configure the options and start the addon

### Manual

```bash
cd /addons
git clone https://github.com/yianniscy84/haos-securo.git securo
```

Then restart Home Assistant.

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

## Accessing the App

After installation, Securo is available:

- **Home Assistant sidebar** — Ingress enabled by default
- **Port 80** — Direct HTTP access on your HA host

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
│  │    └── /ws/  → Uvicorn :8000 │   │
│  │                              │   │
│  │  PostgreSQL :5432            │   │
│  │  Redis :6379                 │   │
│  │  Celery worker + beat        │   │
│  └──────────────────────────────┘   │
└─────────────────────────────────────┘
```

## Development

```bash
# Build locally
docker build -t securo-addon .

# Run
docker run -d --name securo-test \
  -p 8080:80 \
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

CI builds multi-arch images (amd64 + aarch64) on tag push → GHCR.

```bash
git tag 0.26.1
git push origin 0.26.1
```

## Links

- [Securo upstream](https://github.com/securo-finance/securo)
- [Documentation](https://docs.usesecuro.com/)
- [Discord](https://discord.gg/rUqTKtQ9S4)
- [HA Addon Docs](https://developers.home-assistant.io/docs/apps/)
