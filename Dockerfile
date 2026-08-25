ARG BUILD_FROM=alpine:3.21

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
# Stage 2: Backend dependencies (Alpine for musl compatibility)
# ============================================================================
FROM python:3.12-alpine AS backend-deps

RUN apk add --no-cache \
    gcc \
    musl-dev \
    libpq-dev \
    postgresql15-dev

WORKDIR /build

COPY securo/backend/pyproject.toml securo/backend/uv.lock ./
RUN pip install --no-cache-dir uv \
    && uv export --frozen --no-emit-project -o /tmp/requirements.txt \
    && pip install --no-cache-dir -r /tmp/requirements.txt \
    && rm /tmp/requirements.txt

COPY securo/backend/ ./
RUN pip install --no-cache-dir --no-deps -e .

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
    libpq \
    tzdata \
    && rm -rf /var/cache/apk/*

RUN ln -sf /usr/bin/python3 /usr/bin/python

COPY --from=backend-deps /usr/local/lib/python3.12/site-packages /usr/local/lib/python3.12/site-packages
COPY --from=backend-deps /usr/local/bin /usr/local/bin

ARG BUILD_VERSION=0.26.0
ARG BUILD_ARCH=amd64

LABEL \
    io.hass.version="${BUILD_VERSION}" \
    io.hass.type="app" \
    io.hass.arch="${BUILD_ARCH}"

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
