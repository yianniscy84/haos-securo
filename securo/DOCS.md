Securo is a self-hosted personal finance manager that gives you full visibility into your accounts, spending, and habits — without surrendering your data to third parties.

## Features

- Multi-account management with running balances
- Transaction management with search, filters, and CSV export
- File import (OFX, QIF, CAMT, CSV)
- Auto-categorization rules engine
- Recurring transactions and budgets
- Goals and savings targets with progress tracking
- Asset management with valuation tracking
- Reports: Net Worth and Income vs Expenses
- Bank sync via Pluggy, Enable Banking, or SimpleFIN
- Multi-currency support with automatic FX conversion
- Two-factor authentication (TOTP) and passkeys
- OIDC login support (Authentik, Pocket ID, etc.)
- Multi-user support with admin panel
- Optional AI agents and MCP (Claude Desktop, Cursor, n8n, Home Assistant MCP client)

## Configuration

### Required

| Option | Description |
|---|---|
| `secret_key` | Secret key for session signing. Leave empty to auto-generate. |

### Bank Sync (Optional)

Configure one or more providers to enable automatic bank synchronization:

#### Pluggy (Brazilian banks)
- `pluggy_client_id` — Your Pluggy Client ID
- `pluggy_client_secret` — Your Pluggy Client Secret

#### Enable Banking (European banks, PSD2)
- `enable_banking_app_id` — Your Enable Banking Application ID

#### SimpleFIN (US and international)
- `simplefin_enabled` — Set to `true` to enable SimpleFIN
- `simplefin_api_url` — Defaults to sandbox; use `bridge.simplefin.org` for production

### OIDC (Optional)

Delegate login to an external OIDC provider:

| Option | Description |
|---|---|
| `oidc_enabled` | Enable OIDC login |
| `oidc_provider_name` | Display name for the provider |
| `oidc_discovery_url` | `.well-known/openid-configuration` URL |
| `oidc_client_id` | OIDC client ID |
| `oidc_client_secret` | OIDC client secret |

### AI agents and MCP (Optional)

Off by default. Set `agents_enabled` to `true` to start the built-in MCP server and mount the Agents UI (token minting lives under **Agents → Connections → External MCP access**).

| Option | Description |
|---|---|
| `agents_enabled` | Enable agents + MCP |
| `agents_mcp_jwt_secret` | MCP token signing secret. Leave empty to auto-generate and persist |
| `agents_external_mcp_url` | Public MCP URL shown in the UI. If empty, derived from `frontend_url` as `{frontend_url}/mcp` |
| `agents_extra_mcp_servers` | Extra MCP servers: `URL[|name],...` |
| `agents_embedding_provider` | `ollama`, `openai`, or `openai_compatible` (not `native`) |

MCP clients (Claude Desktop, Cursor, n8n, Home Assistant’s MCP integration) must use a **mapped host port**, not the Home Assistant sidebar ingress URL:

- `http://<ha-host>:8765/mcp`
- or `http://<ha-host>:<mapped-port-80>/mcp`

Mint a JWT in the Securo UI, then send it as `Authorization: Bearer <token>`. Ingress is for the web UI only.

Knowledge-base RAG cannot use the default native/fastembed embedder on this Alpine image (`onnxruntime` has no musl wheel). Point `agents_embedding_provider` at Ollama or OpenAI if you need embeddings.

## Accessing the App

After installation, Securo is available:
- In the **Home Assistant sidebar** (if ingress is enabled)
- On **port 80** of your Home Assistant host

Create your first account by opening the app and registering.

## Support

- [Documentation](https://docs.usesecuro.com/)
- [GitHub Issues](https://github.com/securo-finance/securo/issues)
- [Discord](https://discord.gg/rUqTKtQ9S4)
