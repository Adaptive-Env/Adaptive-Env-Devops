#!/usr/bin/env bash
set -euo pipefail

if docker compose version >/dev/null 2>&1; then
  DC=(docker compose)
elif command -v docker-compose >/dev/null 2>&1; then
  DC=(docker-compose)
else
  echo "There is no Docker Compose." >&2; exit 1
fi

cd "$(dirname "$0")"

RESET=0
if [[ "${1:-}" == "reset" ]]; then
  RESET=1
fi

echo "Stopping & removing stack..."
if [[ "$RESET" -eq 1 ]]; then
  "${DC[@]}" down -v --remove-orphans
else
  "${DC[@]}" down --remove-orphans
fi

echo "Pulling latest images..."
"${DC[@]}" pull

echo "Starting stack..."
"${DC[@]}" up -d --remove-orphans

echo "Status:"
"${DC[@]}" ps

echo "Done."
