# ⚠️ Test Version

This is a pre-release test version of the VERT addon. For production use, install the stable **VERT** addon instead.

---

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

1. Open VERT Test from the **Home Assistant sidebar** (ingress) or on **port 3001**
2. Upload files and convert them — images, audio, and documents work immediately via WebAssembly
3. Video conversion uses the bundled vertd daemon (port 24153, internal)

## Accessing the App

After installation, VERT Test is available:

- In the **Home Assistant sidebar** (ingress)
- On **port 3001** of your Home Assistant host (direct access)

## Support

- [GitHub Repository](https://github.com/VERT-sh/VERT)
- [Documentation](https://github.com/VERT-sh/VERT/tree/main/docs)
