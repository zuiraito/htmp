#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"

echo "[INFO] Working directory: $SCRIPT_DIR"

./convert.sh
python3 mapper.py

# open heatmap (use xdg-open for portability)
if command -v xdg-open >/dev/null 2>&1; then
    xdg-open heatmap.html &
else
    firefox heatmap.html &
fi

