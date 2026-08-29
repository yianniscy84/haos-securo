# Home Assistant Apps by yianniscy84

<p align="center">
  <img src="https://camo.githubusercontent.com/3cfef02c675957130352d76646819bbada6eac32a573ca17e5d4c0edc56b0554/68747470733a2f2f7777772e6f70656e686f6d65666f756e646174696f6e2e6f72672f6261646765732f686f6d652d617373697374616e742e706e67" alt="Home Assistant" width="120">
</p>

<p align="center">
  <strong>Additional Home Assistant apps for your smart home</strong><br>
  Carefully packaged and maintained Home Assistant add-ons.
</p>

<p align="center">
  <a href="https://github.com/yianniscy84/hassio-addons">
    <img src="https://img.shields.io/github/last-commit/yianniscy84/hassio-addons?label=Last%20update" alt="Last update">
  </a>
  <a href="https://github.com/yianniscy84/hassio-addons/stargazers">
    <img src="https://img.shields.io/github/stars/yianniscy84/hassio-addons?style=flat" alt="GitHub stars">
  </a>
  <a href="https://github.com/yianniscy84/hassio-addons/commits/main">
    <img src="https://img.shields.io/github/commit-activity/y/yianniscy84/hassio-addons?label=Activity" alt="Commit activity">
  </a>
</p>

<p align="center">
  <script type="text/javascript" src="https://cdnjs.buymeacoffee.com/1.0.0/button.prod.min.js" data-name="bmc-button" data-slug="yianniscy84" data-color="#FFDD00" data-emoji=""  data-font="Inter" data-text="Buy me a coffee" data-outline-color="#000000" data-font-color="#000000" data-coffee-color="#ffffff" ></script>
</p>

---

## About

This repository provides additional **Home Assistant apps (add-ons)** that can be installed directly through Home Assistant.

The goal is simple:

> Provide useful, high-quality apps that extend what you can do with your Home Assistant installation.

All apps in this repository are maintained independently and may include both stable and experimental releases.

### Contributing

Contributions are welcome! If you'd like to help improve these apps, feel free to [open an issue](https://github.com/yianniscy84/hassio-addons/issues) or submit a pull request.

If you find these apps useful, consider supporting the project — pick whatever fits you:

| Method | Description | Link |
|--------|-------------|------|
| ⭐ Star the repo | Free — genuinely helps visibility | [![Star](https://img.shields.io/github/stars/yianniscy84/hassio-addons?style=social)](https://github.com/yianniscy84/hassio-addons/stargazers) |
| ☕ Buy Me a Coffee | Quick one-off tip, no signup for the donor | [![Buy Me A Coffee](https://img.shields.io/badge/Donate-Buy%20Me%20a%20Coffee-FFDD00?style=flat&logo=buy-me-a-coffee&logoColor=white)](https://www.buymeacoffee.com/yianniscy84) |
| 🍵 Ko-fi | Quick one-off tip, no signup for the donor | [![Ko-fi](https://img.shields.io/badge/Donate-Ko--fi-FF5E5B?style=flat&logo=kofi&logoColor=white)](https://ko-fi.com/yianniscy84) |
| 🅿️ PayPal | Quick one-off tip | [![PayPal](https://img.shields.io/badge/Donate-PayPal-00457C?style=flat&logo=paypal&logoColor=white)](https://www.paypal.me/ioannisioannou) |

---

## Installation

### One-click installation

The easiest way to add this repository is to use the button below:

<p align="center">
  <a href="https://my.home-assistant.io/redirect/supervisor_add_addon_repository/?repository_url=https://github.com/yianniscy84/hassio-addons">
    <img src="https://img.shields.io/badge/Add%20Repository-Home%20Assistant-41BDF5?style=for-the-badge&logo=home-assistant&logoColor=white" alt="Add repository to Home Assistant">
  </a>
</p>

### Manual installation

In Home Assistant:

1. Open **Settings → Apps → App Store**.
2. Select the **⋮** menu in the top-right corner.
3. Select **Repositories**.
4. Add the following repository:

```text
https://github.com/yianniscy84/hassio-addons
```

5. Select **Add**.
6. The apps from this repository will now appear in the App Store.

For more information, see the official [Home Assistant documentation](https://www.home-assistant.io/common-tasks/os/#installing-third-party-add-ons).

---

# Available Apps

## [Securo](securo/)

<p align="center">
  <img src="securo/icon.png" alt="Securo" width="100">
</p>

**Self-hosted personal finance management for Home Assistant.**

Securo provides a complete personal finance experience with support for:

- Multi-account tracking
- Transaction management
- Transaction imports
- Bank synchronization
- Budgets
- Financial goals
- Reports and analytics
- Optional MCP integration (WIP, untested)

**Upstream project:** [securo-finance/securo](https://github.com/securo-finance/securo)

🧪 **Test version:** [Securo Test](securo-test/)

### Add-on information

| Property | Value |
|----------|--------|
| **Version** | ![Version](https://img.shields.io/badge/dynamic/yaml?label=Version&query=%24.version&url=https%3A%2F%2Fraw.githubusercontent.com%2Fyianniscy84%2Fhassio-addons%2Fmain%2Fsecuro%2Fconfig.yaml&color=brightgreen) |
| **Upstream version** | ![Upstream](https://img.shields.io/badge/dynamic/json?label=Upstream%20version&query=%24.upstream_version&url=https%3A%2F%2Fraw.githubusercontent.com%2Fyianniscy84%2Fhassio-addons%2Fmain%2Fsecuro%2Fupdater.json&color=blue) |
| **Last updated** | ![Updated](https://img.shields.io/badge/dynamic/json?label=Updated&query=%24.last_update&url=https%3A%2F%2Fraw.githubusercontent.com%2Fyianniscy84%2Fhassio-addons%2Fmain%2Fsecuro%2Fupdater.json&color=grey) |
| **Architecture** | ![aarch64](https://img.shields.io/badge/aarch64-green.svg?logo=arm) ![amd64](https://img.shields.io/badge/amd64-green.svg?logo=amd) ![armhf](https://img.shields.io/badge/armhf-green.svg?logo=arm) ![armv7](https://img.shields.io/badge/armv7-green.svg?logo=arm) ![i386](https://img.shields.io/badge/i386-green.svg?logo=intel) |
| **Ingress** | ![Ingress](https://img.shields.io/badge/Ingress-blueviolet.svg?logo=Ingress) |

---

## [OmniRoute](omniroute/)

<p align="center">
  <img src="omniroute/icon.png" alt="OmniRoute" width="100">
</p>

**Free AI gateway: one endpoint, 350+ providers, 1200+ models for Home Assistant.**

OmniRoute is an open-source AI gateway that routes LLM requests through one OpenAI-compatible endpoint. It supports 350+ providers (90+ free tiers), 1200+ models, and works with Claude Code, Codex, Cursor, OpenCode, Cline, Copilot, and any OpenAI-compatible tool.

- Auto-fallback routing across providers
- 19 routing strategies (priority, weighted, cost-optimized, auto, etc.)
- Full dashboard UI for managing providers and keys
- OpenAI-compatible API (`/v1/chat/completions`)
- MCP & A2A agent protocol support
- RTK + Caveman compression (15–95% token savings)
- Zero-config start with free providers

**Upstream project:** [diegosouzapw/OmniRoute](https://github.com/diegosouzapw/OmniRoute)

🧪 **Test version:** [OmniRoute Test](omniroute-test/)

### Add-on information

| Property | Value |
|----------|--------|
| **Version** | ![Version](https://img.shields.io/badge/dynamic/yaml?label=Version&query=%24.version&url=https%3A%2F%2Fraw.githubusercontent.com%2Fyianniscy84%2Fhassio-addons%2Fmain%2Fomniroute%2Fconfig.yaml&color=brightgreen) |
| **Upstream version** | ![Upstream](https://img.shields.io/badge/dynamic/json?label=Upstream%20version&query=%24.upstream_version&url=https%3A%2F%2Fraw.githubusercontent.com%2Fyianniscy84%2Fhassio-addons%2Fmain%2Fomniroute%2Fupdater.json&color=blue) |
| **Last updated** | ![Updated](https://img.shields.io/badge/dynamic/json?label=Updated&query=%24.last_update&url=https%3A%2F%2Fraw.githubusercontent.com%2Fyianniscy84%2Fhassio-addons%2Fmain%2Fomniroute%2Fupdater.json&color=grey) |
| **Architecture** | ![aarch64](https://img.shields.io/badge/aarch64-green.svg?logo=arm) ![amd64](https://img.shields.io/badge/amd64-green.svg?logo=amd) ![armv7](https://img.shields.io/badge/armv7-green.svg?logo=arm) |
| **Ingress** | ![Ingress](https://img.shields.io/badge/Ingress-blueviolet.svg?logo=Ingress) |

---

## Support

Need help or found a problem?

### Community

For questions, discussions, and general help, visit the [Home Assistant Community Forum](https://community.home-assistant.io/t/securo).

### Issues

Found a bug or have a feature request?

Please [open an issue](https://github.com/yianniscy84/hassio-addons/issues) with as much information as possible.

When reporting an issue, please include:

- Home Assistant version
- Add-on name
- Add-on version
- Home Assistant architecture
- Relevant logs
- Steps to reproduce the problem

---

## Disclaimer

These apps are provided as-is. Always keep appropriate backups of important data before installing or upgrading add-ons, especially experimental versions.

---