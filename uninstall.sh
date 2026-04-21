#!/usr/bin/env bash
set -euo pipefail

VENV_DIR="${HOME}/.venv/mlx"
PID_FILE="${HOME}/.local/run/mlx-server.pid"

# Stop server if running
if [[ -f "${PID_FILE}" ]]; then
    PID=$(cat "${PID_FILE}")
    if kill -0 "${PID}" 2>/dev/null; then
        echo "Stopping running server (PID ${PID})..."
        kill "${PID}"
    fi
    rm -f "${PID_FILE}"
fi

if [[ ! -d "${VENV_DIR}" ]]; then
    echo "Nothing to remove — ${VENV_DIR} does not exist"
    exit 0
fi

echo "Removing ${VENV_DIR}..."
rm -rf "${VENV_DIR}"
echo "Done."
