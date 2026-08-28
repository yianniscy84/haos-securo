ARG BUILD_FROM=node:22-alpine

# ============================================================================
# Stage 1: Build OmniRoute (Next.js standalone)
# ============================================================================
FROM node:22-alpine AS builder

# Install build tools for native modules
RUN apk add --no-cache python3 make g++

WORKDIR /src

# Clone OmniRoute source
ARG OMNIROUTE_VERSION=3.8.50
RUN apk add --no-cache git \
    && git clone --depth 1 --branch release/v${OMNIROUTE_VERSION} \
       https://github.com/diegosouzapw/OmniRoute.git . \
    && rm -rf .git

# Install dependencies
RUN npm ci --legacy-peer-deps

# Build (Next.js standalone output)
ENV NEXT_TELEMETRY_DISABLED=1
RUN npm run build

# ============================================================================
# Stage 2: Runtime
# ============================================================================
FROM ${BUILD_FROM}

# Install runtime dependencies
RUN apk add --no-cache \
    bash \
    redis \
    curl \
    python3 \
    tzdata \
    su-exec

# Stubs for bashio + with-contenv (local / non-HA builds).
COPY bashio_stub.sh /usr/local/lib/bashio_stub.sh
COPY with-contenv   /usr/local/lib/with-contenv-stub
RUN if ! command -v with-contenv >/dev/null 2>&1; then \
      sed -i 's/\r//' /usr/local/lib/bashio_stub.sh /usr/local/lib/with-contenv-stub; \
      cp /usr/local/lib/with-contenv-stub /usr/bin/with-contenv; \
      chmod +x /usr/bin/with-contenv; \
    fi

ARG BUILD_VERSION=3.8.50
ARG BUILD_ARCH=amd64

LABEL \
    io.hass.version="${BUILD_VERSION}" \
    io.hass.type="app" \
    io.hass.arch="${BUILD_ARCH}"

# Copy standalone Next.js output from builder
COPY --from=builder /src/.next/standalone /app
COPY --from=builder /src/.next/static /app/.next/static
COPY --from=builder /src/public /app/public

# Copy addon config files
COPY nginx.conf /etc/nginx/nginx.conf
COPY run.sh /run.sh
RUN sed -i 's/\r//' /run.sh && chmod a+x /run.sh

# Persistent data directory
RUN mkdir -p /data /var/log/nginx /run/nginx /run/redis \
    && echo '{}' > /data/options.json

EXPOSE 20128

CMD ["/run.sh"]
