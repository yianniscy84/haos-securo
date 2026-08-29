# Changelog

## 0.1.3

- Speed up build: use pre-built vertd binary instead of compiling from source

## 0.1.2

- Fix double period in addon description
- Add webui field for HAOS sidebar link

## 0.1.1

- Fix Dockerfile: clone VERT source from GitHub during build

## 0.1.0

- Initial release of VERT addon
- SvelteKit static frontend with WebAssembly-based file conversion
- Bundled vertd daemon for server-side video conversion (FFmpeg wrapper)
- Ingress support (HA sidebar access)
- Configurable vertd (enable/disable, custom port)
- Privacy-first: external requests disabled, no analytics
