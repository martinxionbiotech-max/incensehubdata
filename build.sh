#!/usr/bin/env bash
set -euo pipefail
python3 -m pip install --target .deps -r requirements.txt
PYTHONPATH="$PWD/.deps" python3 -m mkdocs build
