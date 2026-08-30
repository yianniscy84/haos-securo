# Home Assistant Add-on: OmniRoute Test

<p align="center">
  <img src="icon.png" alt="OmniRoute Test Logo" width="120">
</p>

<p align="center">
  <strong>Pre-release and experimental test build of OmniRoute for Home Assistant.</strong><br>
  Test new routing engines, experimental upstream builds, and provider integrations on an isolated port.
</p>

<p align="center">
  <img src="https://img.shields.io/badge/dynamic/yaml?label=Version&query=%24.version&url=https%3A%2F%2Fraw.githubusercontent.com%2Fyianniscy84%2Fhassio-addons%2Fmain%2Fomniroute-test%2Fconfig.yaml&color=orange&style=flat-square" alt="Add-on Version">
  <img src="https://img.shields.io/badge/dynamic/json?label=Upstream&query=%24.upstream_version&url=https%3A%2F%2Fraw.githubusercontent.com%2Fyianniscy84%2Fhassio-addons%2Fmain%2Fomniroute-test%2Fupdater.json&color=blue&style=flat-square" alt="Upstream Version">
  <img src="https://img.shields.io/badge/dynamic/json?label=Updated&query=%24.last_update&url=https%3A%2F%2Fraw.githubusercontent.com%2Fyianniscy84%2Fhassio-addons%2Fmain%2Fomniroute-test%2Fupdater.json&color=lightgrey&style=flat-square" alt="Last Update">
  <img src="https://img.shields.io/badge/Ingress-No-grey.svg?style=flat-square" alt="Ingress Disabled">
  <img src="https://img.shields.io/badge/Stage-Testing-orange.svg?style=flat-square" alt="Stage Testing">
</p>

<p align="center">
  <img src="https://img.shields.io/badge/aarch64-green.svg?style=flat-square&logo=arm" alt="aarch64">
  <img src="https://img.shields.io/badge/amd64-green.svg?style=flat-square&logo=amd" alt="amd64">
  <img src="https://img.shields.io/badge/armv7-green.svg?style=flat-square&logo=arm" alt="armv7">
</p>

---

> [!WARNING]
> **Pre-Release / Experimental Add-on**: This test build is designed for staging and experimenting with new upstream OmniRoute builds. For everyday home automation and production workflows, please install the stable [**OmniRoute**](../omniroute/) add-on.

---

## 🧪 Side-by-Side Execution & Port Isolation

OmniRoute Test runs on a dedicated port without Home Assistant Ingress to prevent conflicts with your production OmniRoute instance:

| Parameter | OmniRoute (Production) | OmniRoute Test (This Add-on) |
| :--- | :---: | :---: |
| **Direct Host Port** | `20128` | `20129` |
| **Ingress UI** | Enabled (Sidebar) | Disabled (Direct Port Only) |
| **API Endpoint** | `http://<ha-host>:20128/v1` | `http://<ha-host>:20129/v1` |
| **Data Directory** | `/data` (Isolated Volume) | `/data` (Isolated Volume) |

---

## 🌟 Key Features

- **Isolated AI Gateway**: Evaluate pre-release builds and new provider adapters without interrupting running LLM services.
- **Universal Provider Support**: 350+ AI providers (Claude, OpenAI, Gemini, DeepSeek, Kimi, Ollama, etc.).
- **19 Routing Strategies**: Priority failover, weighted distributions, and token optimization.
- **Prompt Compression**: Built-in RTK and Caveman token compression saving up to 95% of prompt tokens.

---

## 🚀 Installation & Quickstart

1. Add the repository to Home Assistant:
   ```text
   https://github.com/yianniscy84/hassio-addons
   ```
2. In the Add-on Store, find **OmniRoute Test** and click **Install**.
3. Start the add-on and access the dashboard directly at `http://<your-ha-host>:20129`.
4. Test API access with a direct request:

```bash
curl http://<your-ha-host>:20129/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{"model":"auto","messages":[{"role":"user","content":"Testing OmniRoute Test!"}]}'
```

---

## 🛠️ Support & Links

- **Stable Version**: [OmniRoute Add-on](../omniroute/)
- **Documentation**: [DOCS.md](DOCS.md)
- **Issues & Feedback**: [GitHub Issues](https://github.com/yianniscy84/hassio-addons/issues)
- **Upstream Project**: [diegosouzapw/OmniRoute](https://github.com/diegosouzapw/OmniRoute)
