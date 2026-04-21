# ai-mlx

Simple wrapper to run an [mlx-lm](https://github.com/ml-explore/mlx-examples/tree/main/lm) server locally.

## Quick Start

```bash
# 1. Install dependencies (requires ARM64 macOS and `uv`)
./install.sh

# 2. Start a model (downloads automatically)
./start.sh mlx-community/Qwen2.5-Coder-7B-Instruct-4bit 8080

# 3. Use the OpenAI‑compatible endpoint
curl http://localhost:8080/v1/completions \
  -H "Content-Type: application/json" \
  -d '{"model": "mlx-community/Qwen2.5-Coder-7B-Instruct-4bit", "prompt": "def hello():"}'

# 4. Stop the server
./stop.sh
```

## Commands

| Script | Purpose |
|--------|---------|
| `./install.sh` | Creates Python virtual environment (`~/.venv/mlx`) with `mlx` and `mlx‑lm`. Verifies Metal availability (ARM64 only). |
| `./start.sh <model> [port]` | Downloads the model (if not cached) and launches the mlx‑lm server. |
| `./stop.sh` | Stops the running server and removes the PID file. |
| `./log.sh` | Tails the server log (`~/.local/log/mlx‑server.log`). |
| `./uninstall.sh` | Stops the server and deletes the virtual environment. |

## Server Details

- **Endpoint**: `http://localhost:<port>/v1`
- **API**: Compatible with OpenAI’s Completions and Chat Completions.
- **Models**: Any Hugging Face model that mlx‑lm supports (e.g., `mlx‑community/…`, `mlx‑community/LLaMA‑3.2‑1B‑Instruct‑4bit`, etc.).
- **Logs**: Written to `~/.local/log/mlx‑server.log`; use `./log.sh` to follow.

## Requirements

- Apple Silicon (ARM64) macOS (Metal acceleration).
- [`uv`](https://github.com/astral-sh/uv) installed (`brew install uv` or `pipx install uv`).
- Sufficient disk space for model weights (several GB).

## Notes

- The virtual environment is isolated and does not interfere with your global Python.
- The server runs in the background; PID stored in `~/.local/run/mlx‑server.pid`.
- If you change the model, stop the server first.
- No linting, testing, or type‑checking automation is present.

## Example with curl

```bash
# Chat completion
curl http://localhost:8080/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "model": "mlx-community/Qwen2.5-Coder-7B-Instruct-4bit",
    "messages": [{"role": "user", "content": "Write a Python function to compute factorial."}]
  }'
```