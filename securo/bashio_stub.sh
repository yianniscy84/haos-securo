#!/bin/sh
# Minimal bashio stub for local (non-HA) builds.
# Translates bashio::config calls to reads from /data/options.json.
# Only supports the subset used in run.sh.

_value() {
    python3 -c "
import json, sys
with open('/data/options.json') as f:
    data = json.load(f)
val = data.get('$1', '$2')
if isinstance(val, bool):
    print('true' if val else 'false')
elif val is None:
    print('$2')
else:
    print(val)
" 2>/dev/null || echo "$2"
}

_log() {
    echo "[securo] $*"
}

bashio() {
    case "$1" in
        config)
            _value "$2"
            ;;
        log.info)
            shift
            _log "$*"
            ;;
        log.error)
            shift
            _log "ERROR: $*" >&2
            ;;
        *)
            echo "[bashio-stub] unsupported: $*" >&2
            return 1
            ;;
    esac
}
