# Changelog

## 0.1.7

- Fix WASM MIME type: add globally in http block

## 0.1.6

- Fix WASM MIME type: use types block instead of add_header

## 0.1.5

- Fix nginx: run in foreground so container stays alive for ingress

## 0.1.4

- Fix Dockerfile: remove stale Rust build stage, use pre-built vertd

## 0.1.3

- Speed up build: use pre-built vertd binary instead of compiling from source

## 0.1.2

- Fix double period in addon description
- Add webui field for HAOS sidebar link

## 0.1.1

- Fix Dockerfile: clone VERT source from GitHub during build

## 0.1.0

- Initial release of VERT Test addon
- Same as VERT production addon (test variant)
- Direct access on port 3001
