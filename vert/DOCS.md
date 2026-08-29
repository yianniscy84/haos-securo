# VERT

VERT is an open-source file converter that uses WebAssembly to convert files directly on your device — no cloud required. For video conversion, it includes the **vertd** daemon (FFmpeg wrapper) for server-side processing.

## Features

- **250+ file formats** — images, audio, documents, and video
- **Client-side conversion** — images, audio, and documents convert via WebAssembly in your browser
- **Video conversion** — powered by vertd (bundled FFmpeg wrapper) for fast, server-side video processing
- **No file size limits** — convert anything, locally
- **Privacy-first** — no external requests, no analytics, fully local
- **Conversion settings** — fine-tune output quality, format, and options

## Configuration

### Addon Options

| Option | Description | Default |
|--------|-------------|---------|
| `vertd_enabled` | Start the vertd video conversion daemon | `true` |
| `vertd_port` | Internal port for vertd (not exposed to host) | `24153` |

### After Installation

1. Open VERT from the **Home Assistant sidebar** (ingress) or on **port 3000**
2. Upload files and convert them — images, audio, and documents work immediately via WebAssembly
3. Video conversion uses the bundled vertd daemon (port 24153, internal)

### Connecting to an External vertd

If you prefer to run vertd separately (e.g., on a machine with GPU acceleration):

1. Disable `vertd_enabled` in addon options
2. In VERT's settings page, set the **Instance URL** to your external vertd address (e.g., `http://192.168.1.100:24153`)

## Accessing the App

After installation, VERT is available:

- In the **Home Assistant sidebar** (ingress)
- On **port 3000** of your Home Assistant host (direct access)

## Architecture

The addon bundles three components:

| Component | Purpose |
|-----------|---------|
| **VERT frontend** | SvelteKit static site (WebAssembly-based conversion) |
| **Nginx** | Serves the frontend on ports 80 (ingress) and 3000 (direct) |
| **vertd** | Rust daemon wrapping FFmpeg for server-side video conversion |

## Support

- [GitHub Repository](https://github.com/VERT-sh/VERT)
- [Documentation](https://github.com/VERT-sh/VERT/tree/main/docs)
- [License](https://github.com/VERT-sh/VERT/blob/main/LICENSE) — AGPL-3.0
