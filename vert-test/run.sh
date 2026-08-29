#!/usr/bin/with-contenv bashio

# ============================================================================
# VERT Home Assistant Addon — Entry Script
# ============================================================================

CONFIG_PATH=/data/options.json

# Create default options.json if not present (e.g. on first run with mounted volume)
if [ ! -f "${CONFIG_PATH}" ]; then
    echo '{"vertd_enabled":true,"vertd_port":24153}' > "${CONFIG_PATH}"
fi

# --------------------------------------------------------------------------
# Read options from config
# --------------------------------------------------------------------------
VERTD_ENABLED=$(bashio::config 'vertd_enabled')
VERTD_PORT=$(bashio::config 'vertd_port')

# --------------------------------------------------------------------------
# Start Nginx
# --------------------------------------------------------------------------
bashio::log.info "Starting Nginx..."
mkdir -p /run/nginx
nginx
bashio::log.info "Nginx started (ingress on :80, direct on :3000)."

# --------------------------------------------------------------------------
# Start vertd (optional video conversion daemon)
# --------------------------------------------------------------------------
if [ "${VERTD_ENABLED}" = "true" ]; then
    bashio::log.info "Starting vertd on port ${VERTD_PORT}..."
    vertd --port "${VERTD_PORT}" &
    VERTD_PID=$!
    sleep 2

    # Verify vertd is running
    if kill -0 "${VERTD_PID}" 2>/dev/null; then
        bashio::log.info "vertd is ready on port ${VERTD_PORT}."
    else
        bashio::log.error "vertd failed to start! Video conversion will not work."
        bashio::log.error "Check logs for details. Continuing without vertd..."
        VERTD_ENABLED=false
    fi
else
    bashio::log.warn "vertd is disabled. Video conversion will not be available."
    bashio::log.warn "You can connect to an external vertd instance via VERT settings."
fi

# --------------------------------------------------------------------------
# Keep the container alive — forward signals to child processes
# --------------------------------------------------------------------------
cleanup() {
    bashio::log.info "Shutting down..."
    if [ "${VERTD_ENABLED}" = "true" ] && [ -n "${VERTD_PID}" ]; then
        kill "${VERTD_PID}" 2>/dev/null
        wait "${VERTD_PID}" 2>/dev/null
    fi
    nginx -s stop 2>/dev/null
    exit 0
}

trap cleanup SIGTERM SIGINT

# Wait indefinitely (PID 1) — nginx is the main service.
# vertd runs as a background process.
wait
