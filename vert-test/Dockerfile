# ============================================================================
# Stage 1: Build VERT frontend (SvelteKit static site)
# ============================================================================
FROM oven/bun AS frontend

WORKDIR /app

# Build args — baked into the static JS at build time.
# Customised for self-hosted / HA usage.
ARG PUB_ENV=production
ARG PUB_HOSTNAME=localhost
ARG PUB_PLAUSIBLE_URL=
ARG PUB_VERTD_URL=http://127.0.0.1:24153
ARG PUB_DISABLE_ALL_EXTERNAL_REQUESTS=true
ARG PUB_DISABLE_FAILURE_BLOCKS=true
ARG PUB_DONATION_URL=
ARG PUB_STRIPE_KEY=

ENV PUB_ENV=${PUB_ENV}
ENV PUB_HOSTNAME=${PUB_HOSTNAME}
ENV PUB_PLAUSIBLE_URL=${PUB_PLAUSIBLE_URL}
ENV PUB_VERTD_URL=${PUB_VERTD_URL}
ENV PUB_DISABLE_ALL_EXTERNAL_REQUESTS=${PUB_DISABLE_ALL_EXTERNAL_REQUESTS}
ENV PUB_DISABLE_FAILURE_BLOCKS=${PUB_DISABLE_FAILURE_BLOCKS}
ENV PUB_DONATION_URL=${PUB_DONATION_URL}
ENV PUB_STRIPE_KEY=${PUB_STRIPE_KEY}

RUN apt-get update && \
    apt-get install -y --no-install-recommends git && \
    rm -rf /var/lib/apt/lists/*

RUN git clone --depth 1 https://github.com/VERT-sh/VERT.git /app
WORKDIR /app
RUN bun install
RUN bun run build

# ============================================================================
# Stage 2: Build vertd daemon (Rust + FFmpeg wrapper)
# ============================================================================
FROM rust:1.86-bookworm AS vertd-builder

WORKDIR /build

RUN apt-get update && \
    apt-get install -y --no-install-recommends pkg-config libclang-dev && \
    rm -rf /var/lib/apt/lists/*

RUN git clone --depth 1 https://github.com/VERT-sh/vertd.git /build/vertd-src
WORKDIR /build/vertd-src
RUN cargo build --release

# ============================================================================
# Stage 3: Runtime
# ============================================================================
FROM debian:bookworm-slim

ARG BUILD_VERSION=0.1.1
ARG BUILD_ARCH=amd64

LABEL \
    io.hass.version="${BUILD_VERSION}" \
    io.hass.type="app" \
    io.hass.arch="${BUILD_ARCH}"

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        bash \
        nginx \
        curl \
        ffmpeg \
        ca-certificates \
        libgcc-s1 \
        tzdata \
    && rm -rf /var/lib/apt/lists/*

# Stubs for bashio + with-contenv (local / non-HA builds).
COPY bashio_stub.sh /usr/local/lib/bashio_stub.sh
COPY with-contenv   /usr/local/lib/with-contenv-stub
RUN sed -i 's/\r//' /usr/local/lib/bashio_stub.sh /usr/local/lib/with-contenv-stub \
    && cp /usr/local/lib/with-contenv-stub /usr/bin/with-contenv \
    && chmod +x /usr/bin/with-contenv

# Copy addon config files
COPY nginx.conf /etc/nginx/nginx.conf
COPY run.sh /run.sh
RUN sed -i 's/\r//' /run.sh && chmod a+x /run.sh

# Copy VERT static files from the frontend build stage
COPY --from=frontend /app/build /usr/share/nginx/html

# Copy vertd binary from the build stage
COPY --from=vertd-builder /build/vertd-src/target/release/vertd /usr/local/bin/vertd
RUN chmod +x /usr/local/bin/vertd

# Persistent data directory
RUN mkdir -p /data /var/log/nginx /run/nginx \
    && echo '{}' > /data/options.json

EXPOSE 80 3000

CMD ["/run.sh"]
