# OmniRoute

<p align="center">
  <img src="icon.png" alt="OmniRoute" width="100">
</p>

Free AI gateway for Home Assistant — one endpoint, 350+ providers, 1200+ models.

## About

OmniRoute is a free, open-source AI gateway that routes LLM requests through one OpenAI-compatible endpoint. It supports:

- **350+ providers** — Claude, GPT, Gemini, DeepSeek, Kimi, and hundreds more
- **1200+ models** — including free tiers
- **Auto-fallback routing** — seamless failover across providers and models
- **19 routing strategies** — priority, weighted, round-robin, cost-optimized, auto, and more
- **Dashboard UI** — full management interface for providers, keys, and routing
- **OpenAI-compatible API** — drop-in replacement for any tool that supports OpenAI
- **MCP & A2A** — agent protocol support for AI tool chains
- **Compression** — RTK + Caveman compression saves 15–95% tokens

**Upstream project:** [diegosouzapw/OmniRoute](https://github.com/diegosouzapw/OmniRoute)

## Add-on information

| Property | Value |
|----------|--------|
| **Version** | ![Version](https://img.shields.io/badge/dynamic/yaml?label=Version&query=%24.version&url=https%3A%2F%2Fraw.githubusercontent.com%2Fyianniscy84%2Fhassio-addons%2Fmaster%2Fomniroute%2Fconfig.yaml&color=brightgreen) |
| **Upstream version** | ![Upstream](https://img.shields.io/badge/dynamic/json?label=Upstream%20version&query=%24.upstream_version&url=https%3A%2F%2Fraw.githubusercontent.com%2Fyianniscy84%2Fhassio-addons%2Fmaster%2Fomniroute%2Fupdater.json&color=blue) |
| **Last updated** | ![Updated](https://img.shields.io/badge/dynamic/json?label=Updated&query=%24.last_update&url=https%3A%2F%2Fraw.githubusercontent.com%2Fyianniscy84%2Fhassio-addons%2Fmaster%2Fomniroute%2Fupdater.json&color=grey) |
| **Architecture** | ![aarch64](https://img.shields.io/badge/aarch64-green.svg?logo=arm) ![amd64](https://img.shields.io/badge/amd64-green.svg?logo=amd) ![armv7](https://img.shields.io/badge/armv7-green.svg?logo=arm) |
| **Ingress** | ![Ingress](https://img.shields.io/badge/Ingress-blueviolet.svg?logo=Ingress) |

## Installation

1. Open **Settings → Apps → App Store**.
2. Select the **⋮** menu in the top-right corner.
3. Select **Repositories**.
4. Add the following repository:

```text
https://github.com/yianniscy84/hassio-addons
```

5. Select **Add**.
6. Find **OmniRoute** in the App Store and install it.

For more information, see the official [Home Assistant documentation](https://www.home-assistant.io/common-tasks/os/#installing-third-party-add-ons).

## Support

Need help or found a problem?

- **Discord:** [OmniRoute Community](https://discord.gg/omniroute)
- **GitHub:** [diegosouzapw/OmniRoute](https://github.com/diegosouzapw/OmniRoute)
- Found a bug or have a feature request? Please [open an issue](https://github.com/yianniscy84/hassio-addons/issues).

## Disclaimer

This app is provided as-is. Always keep appropriate backups of important data before installing or upgrading add-ons.
