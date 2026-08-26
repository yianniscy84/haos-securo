# Changelog

## 0.26.10

- Fix OIDC login redirect to use basename for ingress compatibility
- Fix agents SSE fetch URL to use absolute path with basename
- Fix chatUrl helper to include basename prefix

## 0.26.9

- Fix axios baseURL to use absolute path with basename for reliable ingress API routing

## 0.26.8

- Fix account detail page crash when `account.type` is empty string

## 0.26.7

- Fix account detail page crash when projected transactions data is not an array

## 0.26.6

- Fix HA ingress path detection to match `/api/hassio_ingress/<token>` pattern
- Fix account detail page crash when `account.type` is undefined

## 0.26.4

- Fix 401 redirect loop under ingress (was redirecting to `/login` without prefix)
- Fix hardcoded absolute paths in OIDC callback, login handler, agents link, and SSE client
- Extract shared basename utility for consistent ingress path detection

## 0.26.3

- Detect Home Assistant ingress base path dynamically for React Router
- Fix hardcoded absolute API path in agents stream
- Fix favicon paths in index.html

## 0.26.1

- Enable image-based auto-updates via GHCR

## 0.26.0

- Initial HA addon release
- All-in-one: PostgreSQL, Redis, backend, frontend, Celery
- Ingress support
- Bank sync via Pluggy, Enable Banking, SimpleFIN
- OIDC support
