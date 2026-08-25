ARG BUILD_FROM=ghcr.io/home-assistant/base-amd64:latest

# ============================================================================
# Stage 1: Build frontend
# ============================================================================
FROM node:22-alpine AS frontend-build

WORKDIR /build

RUN apk add --no-cache git

ARG SECURE_REPO_URL=https://github.com/securo-finance/securo.git
ARG SECURE_VERSION=main

RUN git clone --depth 1 --branch ${SECURE_VERSION} ${SECURE_REPO_URL} /src

WORKDIR /src/frontend

RUN npm ci --ignore-scripts \
    && npm run build

# ============================================================================
# Stage 2: Backend dependencies
# ============================================================================
FROM python:3.12-slim AS backend-deps

WORKDIR /build

COPY --from=frontend-build /src/backend/requirements*.txt ./

RUN pip install --no-cache-dir --prefix=/install -r requirements.txt

# ============================================================================
# Stage 3: Runtime
# ============================================================================
FROM ${BUILD_FROM}

RUN apk add --no-cache \
    python3 \
    py3-pip \
    py3-psycopg2 \
    postgresql16 \
    postgresql16-client \
    redis \
    nginx \
    curl \
    git \
    libpq \
    tzdata \
    && rm -rf /var/cache/apk/*

RUN ln -sf /usr/bin/python3 /usr/bin/python

COPY --from=backend-deps /install /usr/local

ARG SECURE_VERSION=main
ARG BUILD_ARCH=amd64

LABEL \
    io.hass.version="${SECURE_VERSION}" \
    io.hass.type="app" \
    io.hass.arch="${BUILD_ARCH}"

WORKDIR /app

# Clone the securo repo at build time
RUN git clone --depth 1 https://github.com/securo-finance/securo.git /src/securo \
    && cp -r /src/securo/backend/* /app/ \
    && rm -rf /src/securo

# Copy built frontend
COPY --from=frontend-build /src/frontend/dist /var/www/securo

# Copy addon config files
COPY nginx.conf /etc/nginx/nginx.conf
COPY run.sh /run.sh
RUN chmod a+x /run.sh

# Copy S6 service definitions
COPY s6-overlay/ /etc/s6-overlay/s6-rc.d/

# Persistent data directories
RUN mkdir -p /data/postgres /data/attachments /data/nginx /var/log/nginx

EXPOSE 80

CMD ["/run.sh"]
