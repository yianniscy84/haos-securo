# Home Assistant Add-on: Securo Test

<p align="center">
  <img src="icon.png" alt="Securo Test Logo" width="120">
</p>

<p align="center">
  <strong>Pre-release and experimental test build of Securo for Home Assistant.</strong><br>
  Designed for staging updates, trying out new features, and validating migrations without risking production data.
</p>

<p align="center">
  <img src="https://img.shields.io/badge/dynamic/yaml?label=Version&query=%24.version&url=https%3A%2F%2Fraw.githubusercontent.com%2Fyianniscy84%2Fhassio-addons%2Fmain%2Fsecuro-test%2Fconfig.yaml&color=orange&style=flat-square" alt="Add-on Version">
  <img src="https://img.shields.io/badge/dynamic/json?label=Upstream&query=%24.upstream_version&url=https%3A%2F%2Fraw.githubusercontent.com%2Fyianniscy84%2Fhassio-addons%2Fmain%2Fsecuro-test%2Fupdater.json&color=blue&style=flat-square" alt="Upstream Version">
  <img src="https://img.shields.io/badge/dynamic/json?label=Updated&query=%24.last_update&url=https%3A%2F%2Fraw.githubusercontent.com%2Fyianniscy84%2Fhassio-addons%2Fmain%2Fsecuro-test%2Fupdater.json&color=lightgrey&style=flat-square" alt="Last Update">
  <img src="https://img.shields.io/badge/Ingress-Supported-blueviolet.svg?style=flat-square" alt="Ingress Supported">
  <img src="https://img.shields.io/badge/Stage-Testing-orange.svg?style=flat-square" alt="Stage Testing">
</p>

<p align="center">
  <img src="https://img.shields.io/badge/aarch64-green.svg?style=flat-square&logo=arm" alt="aarch64">
  <img src="https://img.shields.io/badge/amd64-green.svg?style=flat-square&logo=amd" alt="amd64">
  <img src="https://img.shields.io/badge/armhf-green.svg?style=flat-square&logo=arm" alt="armhf">
  <img src="https://img.shields.io/badge/armv7-green.svg?style=flat-square&logo=arm" alt="armv7">
  <img src="https://img.shields.io/badge/i386-green.svg?style=flat-square&logo=intel" alt="i386">
</p>

---

> [!WARNING]
> **Pre-Release / Experimental Add-on**: This add-on is intended for development and pre-release testing. While fully functional, it may contain unreleased changes. For your primary personal finance data, please install the stable [**Securo**](../securo/) add-on.

---

## 🧪 Side-by-Side Execution & Network Ports

Securo Test is configured to run alongside the stable Securo instance without port or database conflicts:

| Service | Securo (Production) | Securo Test (This Add-on) |
| :--- | :---: | :---: |
| **Web UI (Direct)** | `8080` | `81` / `8081` |
| **MCP Server (Direct)** | `8765` | `8766` |
| **Ingress** | Enabled | Enabled |
| **Data Directory** | `/data` (Isolated Volume) | `/data` (Isolated Volume) |

---

## 🌟 Key Features

- **Isolated Testing Ground**: Safely test new upstream database migrations, bank synchronization connections, and OIDC setups.
- **Full Securo Feature Set**: Multi-account tracking, transaction imports (OFX, QIF, CAMT, CSV), budgeting, reports, and AI Agent / MCP integrations.
- **Independent Database**: Embedded PostgreSQL 16 container with `pgvector` and `pgcrypto` running on a separate storage volume.

---

## 🚀 Installation & Setup

1. Add the repository to Home Assistant:
   ```text
   https://github.com/yianniscy84/hassio-addons
   ```
2. In the Add-on Store, find **Securo Test** and click **Install**.
3. Access the UI via the **Home Assistant sidebar** or directly at `http://<your-ha-host>:81`.

---

## 🛠️ Support & Links

- **Stable Version**: [Securo Add-on](../securo/)
- **Documentation**: [DOCS.md](DOCS.md)
- **Issues & Feedback**: [GitHub Issues](https://github.com/yianniscy84/hassio-addons/issues)
- **Upstream Project**: [securo-finance/securo](https://github.com/securo-finance/securo)
