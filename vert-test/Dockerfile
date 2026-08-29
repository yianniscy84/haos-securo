# ============================================================================
# Stage 1: Build VERT frontend (SvelteKit static site)
# ============================================================================
FROM oven/bun AS frontend

WORKDIR /app

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
# Stage 2: Download pre-built vertd daemon
# ============================================================================
FROM debian:bookworm-slim AS vertd-downloader

ARG TARGETARCH

RUN apt-get update && \
    apt-get install -y --no-install-recommends curl ca-certificates && \
    rm -rf /var/lib/apt/lists/*

RUN if [ "$TARGETARCH" = "amd64" ]; then \
        VERTD_ARCH="x86_64"; \
    elif [ "$TARGETARCH" = "arm64" ]; then \
        VERTD_ARCH="aarch64"; \
    else \
        echo "Unsupported architecture: $TARGETARCH" && exit 1; \
    fi && \
    curl -fsSL -o /usr/local/bin/vertd \
        "https://github.com/VERT-sh/vertd/releases/download/nightly-8abb761889d3138f5b91401a533bc7e7211a99ff/vertd-linux-${VERTD_ARCH}" && \
    chmod +x /usr/local/bin/vertd

# ============================================================================
# Stage 3: Runtime
# ============================================================================
FROM debian:bookworm-slim

ARG BUILD_VERSION=0.1.5
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

COPY bashio_stub.sh /usr/local/lib/bashio_stub.sh
COPY with-contenv   /usr/local/lib/with-contenv-stub
RUN sed -i 's/\r//' /usr/local/lib/bashio_stub.sh /usr/local/lib/with-contenv-stub \
    && cp /usr/local/lib/with-contenv-stub /usr/bin/with-contenv \
    && chmod +x /usr/bin/with-contenv

COPY nginx.conf /etc/nginx/nginx.conf
COPY run.sh /run.sh
RUN sed -i 's/\r//' /run.sh && chmod a+x /run.sh

COPY --from=frontend /app/build /usr/share/nginx/html
COPY --from=vertd-downloader /usr/local/bin/vertd /usr/local/bin/vertd

RUN mkdir -p /data /var/log/nginx /run/nginx \
    && echo '{}' > /data/options.json

EXPOSE 80 3000

CMD ["/run.sh"]
