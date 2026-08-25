ARG BUILD_FROM=python:3.12-alpine

# ============================================================================
# Stage 1: Build frontend
# ============================================================================
FROM node:22-alpine AS frontend-build

WORKDIR /src/frontend

COPY securo/frontend/package*.json ./
RUN npm ci --ignore-scripts

COPY securo/frontend/ ./
RUN npm run build

# ============================================================================
# Stage 2: Backend dependencies
# ============================================================================
FROM python:3.12-alpine AS backend-deps

RUN apk add --no-cache \
    gcc \
    musl-dev \
    libpq-dev \
    postgresql-dev

WORKDIR /build

COPY securo/backend/pyproject.toml securo/backend/uv.lock ./
RUN pip install --no-cache-dir uv \
    && uv export --frozen --no-emit-project --no-hashes -o /tmp/requirements.txt \
    && pip install --no-cache-dir -r /tmp/requirements.txt \
    && rm /tmp/requirements.txt

COPY securo/backend/ ./
RUN pip install --no-cache-dir --no-deps .

# ============================================================================
# Stage 3: Runtime
# ============================================================================
FROM ${BUILD_FROM}

# Install OS-level deps only (Python already provided by python:3.12-alpine base,
# or by the HA base image in CI). Do NOT add py3-pip / py3-psycopg2 via apk —
# they conflict with pip-installed packages from the build stage.
RUN apk add --no-cache \
    postgresql16 \
    postgresql16-client \
    redis \
    nginx \
    curl \
    libpq \
    tzdata \
    && rm -rf /var/cache/apk/*

ARG BUILD_VERSION=0.26.0
ARG BUILD_ARCH=amd64

LABEL \
    io.hass.version="${BUILD_VERSION}" \
    io.hass.type="app" \
    io.hass.arch="${BUILD_ARCH}"

# Copy pip packages and console scripts from the build stage.
# python:3.12-alpine and the HA base images both place site-packages under
# /usr/local/lib/python3.12/, so this copy is safe for both local and CI builds.
COPY --from=backend-deps /usr/local/lib/python3.12/site-packages /usr/local/lib/python3.12/site-packages
COPY --from=backend-deps /usr/local/bin /usr/local/bin

WORKDIR /app

# Copy backend source
COPY securo/backend/ /app/

# Copy built frontend
COPY --from=frontend-build /src/frontend/dist /var/www/securo

# Copy addon config files
COPY nginx.conf /etc/nginx/nginx.conf
COPY run.sh /run.sh
RUN chmod a+x /run.sh

# Persistent data directories
RUN mkdir -p /data/postgres /data/attachments /data/nginx /var/log/nginx

EXPOSE 80

CMD ["/run.sh"]
