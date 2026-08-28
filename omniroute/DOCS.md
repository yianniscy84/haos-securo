OmniRoute is a free, open-source AI gateway that routes LLM requests through one OpenAI-compatible endpoint. It supports 350+ providers (90+ free), 1200+ models, and works with Claude Code, Codex, Cursor, OpenCode, Cline, Copilot, and any OpenAI-compatible tool.

## Features

- **350+ providers** — Claude, GPT, Gemini, DeepSeek, Kimi, and hundreds more
- **1200+ models** — including free tiers (~1.5B tokens/month)
- **Auto-fallback routing** — seamless failover across providers and models
- **19 routing strategies** — priority, weighted, round-robin, cost-optimized, auto, and more
- **Dashboard UI** — full management interface for providers, keys, and routing
- **OpenAI-compatible API** — drop-in replacement for any tool that supports OpenAI
- **MCP & A2A** — agent protocol support for AI tool chains
- **Compression** — RTK + Caveman compression saves 15–95% tokens

## Configuration

### Addon Options

| Option | Description | Default |
|---|---|---|
| `initial_password` | Admin password for the dashboard. Change after first login. | `omniroute` |
| `require_api_key` | Require API key for all /v1/* proxy requests. | `false` |
| `auth_cookie_secure` | Set Secure flag on cookies (enable behind HTTPS). | `false` |

### After Installation

1. Open OmniRoute from the Home Assistant sidebar (or on port 20128)
2. Log in with the password you set in addon options (default: `omniroute`)
3. Go to **Dashboard → Providers** to add provider API keys
4. Point your tools at `http://<ha-host>:20128/v1`

### Zero-Config Start

OmniRoute works immediately with free providers — no API keys required:

```bash
curl http://localhost:20128/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{"model":"auto","messages":[{"role":"user","content":"Hello!"}]}'
```

## Connecting Your Tools

### Claude Code
```bash
omniroute setup-claude
```

### Codex CLI
```bash
omniroute setup-codex
```

### Any OpenAI-compatible tool
Set the base URL to `http://<ha-host>:20128/v1` — no special setup needed.

## Accessing the App

After installation, OmniRoute is available:

- In the **Home Assistant sidebar** (ingress — dashboard UI)
- On **port 20128** of your Home Assistant host (dashboard + API)

## Data Persistence

All configuration, API keys, and database are stored in `/data` (persistent HAOS volume). Back up this directory to preserve your settings.

## Support

- [GitHub Repository](https://github.com/diegosouzapw/OmniRoute)
- [Documentation](https://github.com/diegosouzapw/OmniRoute/wiki)
- [Discord Community](https://discord.gg/omniroute)
- [Telegram](https://t.me/omniroute)
