#!/usr/bin/env bash
set -euo pipefail

VENV_DIR="${HOME}/.venv/mlx"
PID_FILE="${HOME}/.local/run/mlx-server.pid"
LOG_FILE="${HOME}/.local/log/mlx-server.log"

# ── Args ──────────────────────────────────────────────
# Usage: ./start.sh <model> [port]
# Example: ./start.sh mlx-community/Qwen2.5-Coder-7B-Instruct-4bit 8080

if [[ $# -lt 1 ]]; then
    echo "Usage: $0 <model> [port]"
    echo "Example: $0 mlx-community/Qwen2.5-Coder-7B-Instruct-4bit 8080"
    exit 1
fi

MODEL="${1}"
PORT="${2:-8080}"

# ── Guard: already running ─────────────────────────────
if [[ -f "${PID_FILE}" ]]; then
    PID=$(cat "${PID_FILE}")
    if kill -0 "${PID}" 2>/dev/null; then
        echo "Server already running (PID ${PID}). Stop it first with stop.sh"
        exit 1
    else
        # Stale PID file
        rm -f "${PID_FILE}"
    fi
fi

# ── Ensure dirs exist ──────────────────────────────────
mkdir -p "$(dirname "${PID_FILE}")" "$(dirname "${LOG_FILE}")"

# ── Pre-download model ─────────────────────────────────
echo "Fetching model (no-op if already cached)..."
"${VENV_DIR}/bin/python" -c "
from mlx_lm import load
load('${MODEL}')
print('Model ready.')
"

# ── Launch ────────────────────────────────────────────
echo "Starting mlx-lm server..."
echo "  model : ${MODEL}"
echo "  port  : ${PORT}"
echo "  log   : ${LOG_FILE}"

#set -x
"${VENV_DIR}/bin/python" -m mlx_lm.server \
    --model "${MODEL}" \
    --port "${PORT}" \
    --max-tokens 32767 \
    --chat-template-args '{"enable_thinking": false}' \
    >> "${LOG_FILE}" 2>&1 &
#set +x

echo $! > "${PID_FILE}"
echo "Server started (PID $(cat "${PID_FILE}"))"
echo "Endpoint: http://localhost:${PORT}/v1"
