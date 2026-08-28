# ⚠️ Test Version

This is a pre-release test version of the OmniRoute addon. It tracks the upstream `main` branch and may contain experimental features or bugs. For production use, install the stable **OmniRoute** addon instead.

---

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

1. Open OmniRoute from the Home Assistant sidebar (or on port 20129)
2. Log in with the password you set in addon options (default: `omniroute`)
3. Go to **Dashboard → Providers** to add provider API keys
4. Point your tools at `http://<ha-host>:20129/v1`

### Zero-Config Start

OmniRoute works immediately with free providers — no API keys required:

```bash
curl http://localhost:20129/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{"model":"auto","messages":[{"role":"user","content":"Hello!"}]}'
```

## Accessing the App

After installation, OmniRoute Test is available:

- In the **Home Assistant sidebar** (ingress — dashboard UI)
- On **port 20129** of your Home Assistant host (dashboard + API)

## Support

- [GitHub Repository](https://github.com/diegosouzapw/OmniRoute)
- [Documentation](https://github.com/diegosouzapw/OmniRoute/wiki)
- [Discord Community](https://discord.gg/omniroute)
