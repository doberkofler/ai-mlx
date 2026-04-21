#!/usr/bin/env bash
set -euo pipefail

PID_FILE="${HOME}/.local/run/mlx-server.pid"

if [[ ! -f "${PID_FILE}" ]]; then
    echo "No PID file found — server may not be running"
    exit 0
fi

PID=$(cat "${PID_FILE}")

if kill -0 "${PID}" 2>/dev/null; then
    echo "Stopping server (PID ${PID})..."
    kill "${PID}"

    # Wait up to 5s for clean exit
    for i in {1..10}; do
        if ! kill -0 "${PID}" 2>/dev/null; then
            break
        fi
        sleep 0.5
    done

    # Force kill if still alive
    if kill -0 "${PID}" 2>/dev/null; then
        echo "Process did not exit cleanly — sending SIGKILL"
        kill -9 "${PID}"
    fi

    echo "Stopped."
else
    echo "PID ${PID} not running — stale PID file removed"
fi

rm -f "${PID_FILE}"
