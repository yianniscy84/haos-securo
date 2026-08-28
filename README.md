# Home Assistant Apps by yianniscy84

<p align="center">
  <img src="https://www.home-assistant.io/images/home-assistant-logo.svg" alt="Home Assistant" width="120">
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
  <a href="https://github.com/yianniscy84/hassio-addons/commits/master">
    <img src="https://img.shields.io/github/commit-activity/y/yianniscy84/hassio-addons?label=Activity" alt="Commit activity">
  </a>
</p>

---

## About

This repository provides additional **Home Assistant apps (add-ons)** that can be installed directly through Home Assistant.

The goal is simple:

> Provide useful, high-quality apps that extend what you can do with your Home Assistant installation.

All apps in this repository are maintained independently and may include both stable and experimental releases.

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

## Securo

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
- Optional MCP integration

**Upstream project:** [securo-finance/securo](https://github.com/securo-finance/securo)

### Add-on information

| | |
|---|---|
| **Version** | ![Version](https://img.shields.io/badge/dynamic/yaml?label=Version&query=%24.version&url=https%3A%2F%2Fraw.githubusercontent.com%2Fyianniscy84%2Fhassio-addons%2Fmaster%2Fsecuro%2Fconfig.yaml&color=brightgreen) |
| **Last updated** | ![Updated](https://img.shields.io/badge/dynamic/json?label=Updated&query=%24.last_update&url=https%3A%2F%2Fraw.githubusercontent.com%2Fyianniscy84%2Fhassio-addons%2Fmaster%2Fsecuro%2Fupdater.json&color=grey) |
| **Architecture** | ![aarch64](https://img.shields.io/badge/aarch64-green.svg?logo=arm) ![amd64](https://img.shields.io/badge/amd64-green.svg?logo=amd) ![armhf](https://img.shields.io/badge/armhf-green.svg?logo=arm) ![armv7](https://img.shields.io/badge/armv7-green.svg?logo=arm) ![i386](https://img.shields.io/badge/i386-green.svg?logo=intel) |
| **Ingress** | ![Ingress](https://img.shields.io/badge/Ingress-blueviolet.svg?logo=Ingress) |

---

## Securo Test

<p align="center">
  <img src="securo-test/icon.png" alt="Securo Test" width="100">
</p>

**Experimental/test release of Securo.**

This version is intended for testing newer or experimental changes before they are included in the stable Securo add-on.

It provides the same core functionality as Securo:

- Multi-account tracking
- Transaction management
- Transaction imports
- Bank synchronization
- Budgets
- Financial goals
- Reports and analytics
- Optional MCP integration

> **Warning:** This is a test version. It may contain experimental changes and should not be relied upon for critical data.

**Upstream project:** [securo-finance/securo](https://github.com/securo-finance/securo)

### Add-on information

| | |
|---|---|
| **Version** | ![Version](https://img.shields.io/badge/dynamic/yaml?label=Version&query=%24.version&url=https%3A%2F%2Fraw.githubusercontent.com%2Fyianniscy84%2Fhassio-addons%2Fmaster%2Fsecuro-test%2Fconfig.yaml&color=brightgreen) |
| **Last updated** | ![Updated](https://img.shields.io/badge/dynamic/json?label=Updated&query=%24.last_update&url=https%3A%2F%2Fraw.githubusercontent.com%2Fyianniscy84%2Fhassio-addons%2Fmaster%2Fsecuro-test%2Fupdater.json&color=grey) |
| **Architecture** | ![aarch64](https://img.shields.io/badge/aarch64-green.svg?logo=arm) ![amd64](https://img.shields.io/badge/amd64-green.svg?logo=amd) ![armhf](https://img.shields.io/badge/armhf-green.svg?logo=arm) ![armv7](https://img.shields.io/badge/armv7-green.svg?logo=arm) ![i386](https://img.shields.io/badge/i386-green.svg?logo=intel) |
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

<p align="center">
  Made for <a href="https://www.home-assistant.io/">Home Assistant</a>
</p>