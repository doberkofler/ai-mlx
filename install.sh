#!/usr/bin/env bash
set -euo pipefail

# Target venv — change if needed
VENV_DIR="${HOME}/.venv/mlx"

echo "Creating venv at ${VENV_DIR}..."
uv venv "${VENV_DIR}" --python python3

echo "Installing mlx + mlx-lm..."
uv pip install --python "${VENV_DIR}/bin/python" mlx mlx-lm

echo "Verifying Metal availability..."
"${VENV_DIR}/bin/python" -c "
import mlx.core as mx, platform, sys
print(f'  arch    : {platform.machine()}')
print(f'  metal   : {mx.metal.is_available()}')
if platform.machine() != 'arm64':
    print('WARN: not arm64 — Metal will not be available')
    sys.exit(1)
if not mx.metal.is_available():
    print('WARN: Metal unavailable — check Rosetta or Python build')
    sys.exit(1)
"

echo "Done. Activate with: source ${VENV_DIR}/bin/activate"
