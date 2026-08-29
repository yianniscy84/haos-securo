#!/usr/bin/with-contenv bashio

# ============================================================================
# VERT Home Assistant Addon — Entry Script
# ============================================================================

CONFIG_PATH=/data/options.json

if [ ! -f "${CONFIG_PATH}" ]; then
    echo '{"vertd_enabled":true,"vertd_port":24153}' > "${CONFIG_PATH}"
fi

VERTD_ENABLED=$(bashio::config 'vertd_enabled')
VERTD_PORT=$(bashio::config 'vertd_port')

# --------------------------------------------------------------------------
# Start vertd (optional video conversion daemon)
# --------------------------------------------------------------------------
if [ "${VERTD_ENABLED}" = "true" ]; then
    bashio::log.info "Starting vertd on port ${VERTD_PORT}..."
    vertd --port "${VERTD_PORT}" &
    VERTD_PID=$!
    sleep 2

    if kill -0 "${VERTD_PID}" 2>/dev/null; then
        bashio::log.info "vertd is ready on port ${VERTD_PORT}."
    else
        bashio::log.error "vertd failed to start! Continuing without video conversion."
        VERTD_ENABLED=false
    fi
else
    bashio::log.warn "vertd is disabled. Video conversion will not be available."
fi

# --------------------------------------------------------------------------
# Start Nginx (foreground — keeps the container alive)
# --------------------------------------------------------------------------
bashio::log.info "Starting Nginx..."
mkdir -p /run/nginx
exec nginx -g 'daemon off;'
