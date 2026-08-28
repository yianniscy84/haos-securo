#!/usr/bin/with-contenv bashio

# ============================================================================
# OmniRoute Test Home Assistant Addon — Entry Script
# ============================================================================

CONFIG_PATH=/data/options.json
APP_DIR="/app"

# Create default options.json if not present (e.g. on first run with mounted volume)
if [ ! -f "${CONFIG_PATH}" ]; then
    echo '{"initial_password":"","require_api_key":false,"auth_cookie_secure":false}' > "${CONFIG_PATH}"
fi

# --------------------------------------------------------------------------
# Read options from config
# --------------------------------------------------------------------------
INITIAL_PASSWORD=$(bashio::config 'initial_password')
REQUIRE_API_KEY=$(bashio::config 'require_api_key')
AUTH_COOKIE_SECURE=$(bashio::config 'auth_cookie_secure')

# Generate secrets if not already persisted
JWT_SECRET_FILE="/data/jwt_secret"
API_KEY_SECRET_FILE="/data/api_key_secret"

if [ -f "${JWT_SECRET_FILE}" ]; then
    JWT_SECRET=$(cat "${JWT_SECRET_FILE}")
else
    JWT_SECRET=$(openssl rand -base64 48)
    echo -n "${JWT_SECRET}" > "${JWT_SECRET_FILE}"
    chmod 600 "${JWT_SECRET_FILE}"
fi

if [ -f "${API_KEY_SECRET_FILE}" ]; then
    API_KEY_SECRET=$(cat "${API_KEY_SECRET_FILE}")
else
    API_KEY_SECRET=$(openssl rand -hex 32)
    echo -n "${API_KEY_SECRET}" > "${API_KEY_SECRET_FILE}"
    chmod 600 "${API_KEY_SECRET_FILE}"
fi

# Use a default password if none set
if [ -z "${INITIAL_PASSWORD}" ]; then
    INITIAL_PASSWORD="omniroute"
fi

# --------------------------------------------------------------------------
# Export environment variables
# --------------------------------------------------------------------------
export JWT_SECRET
export API_KEY_SECRET
export INITIAL_PASSWORD

# Storage
export DATA_DIR="/data"
export STORAGE_ENCRYPTION_KEY=""

# Network
export PORT=20128
export HOSTNAME="0.0.0.0"
export NODE_ENV=production

# Security
export REQUIRE_API_KEY="${REQUIRE_API_KEY}"
export AUTH_COOKIE_SECURE="${AUTH_COOKIE_SECURE}"
export ALLOW_API_KEY_REVEAL=false
export CORS_ORIGIN="*"

# Memory
export OMNIROUTE_MEMORY_MB=1024
export NODE_OPTIONS="--max-old-space-size=1024"

# Redis
export REDIS_URL="redis://127.0.0.1:6379"

# --------------------------------------------------------------------------
# Start Redis
# --------------------------------------------------------------------------
bashio::log.info "Starting Redis..."
redis-server --daemonize yes --dir /tmp --appendonly no --save "" --port 6379 --bind 127.0.0.1
sleep 1

# Verify Redis is running
if redis-cli ping 2>/dev/null | grep -q PONG; then
    bashio::log.info "Redis is ready."
else
    bashio::log.error "Redis failed to start!"
    exit 1
fi

# --------------------------------------------------------------------------
# Start OmniRoute
# --------------------------------------------------------------------------
bashio::log.info "Starting OmniRoute (TEST)..."
cd "${APP_DIR}"
exec node dev/run-standalone.mjs

# Note: exec replaces the shell process, so no cleanup needed.
# OmniRoute handles SIGTERM/SIGINT gracefully via SHUTDOWN_TIMEOUT_MS.
