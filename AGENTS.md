# Agent Guidance for ai-mlx

This repository provides a simple wrapper to run mlx-lm servers locally.

## Commands

- `./install.sh` – creates a Python virtual environment with `mlx` and `mlx-lm`, verifies Metal availability (ARM64 only).
- `./start.sh <model> [port]` – downloads (if needed) and starts the mlx-lm server.
- `./stop.sh` – stops the running server.
- `./log.sh` – tails the server log.
- `./uninstall.sh` – stops server and removes the virtual environment.

## Environment & Paths

- Virtual environment: `~/.venv/mlx`
- PID file: `~/.local/run/mlx-server.pid`
- Log file: `~/.local/log/mlx-server.log`

## Constraints

- **ARM64 (Apple Silicon) required** for Metal acceleration. The install script will exit with an error otherwise.
- Uses `uv` for Python environment management. If not installed, the script will fail.
- No lint, test, or type‑check commands exist.
- No package manifests (no `pyproject.toml`, `requirements.txt`).

## Server Details

- The server is started with `python -m mlx_lm.server --model <model> --port <port>`.
- Model names follow Hugging Face notation (e.g., `mlx-community/Qwen2.5-Coder-7B-Instruct-4bit`).
- Endpoint: `http://localhost:<port>/v1`.

## What to Avoid

- Do not attempt to run `npm`/`yarn` commands – this is not a Node.js project.
- Do not create a `package.json` or `pyproject.toml` unless explicitly requested.
- Do not change the default location of the virtual environment or PID/log paths without checking with the user.
- Do not add linting or testing automation unless asked.

## Notes for OpenCode Agents

- There is no `README.md`; create a simple one if missing.
- The repository is essentially a collection of Bash scripts that orchestrate an mlx-lm server.
- If you need to modify the scripts, preserve the existing error‑handling and guard clauses.