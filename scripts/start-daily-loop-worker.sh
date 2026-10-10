#!/usr/bin/env bash
# Start a My Machines worker for daily-work-loop-copilot scheduled automations.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
NAME="${DAILY_LOOP_WORKER_NAME:-my-daily-loop}"

if ! command -v agent >/dev/null 2>&1; then
  echo "Cursor CLI not found. Install: curl https://cursor.com/install -fsS | bash" >&2
  exit 1
fi

WORKER_DIRS=("$REPO_ROOT")
MYHOPPIES="${REPO_ROOT}/repos/MyHoppies"
if [[ -d "$MYHOPPIES" ]]; then
  WORKER_DIRS+=("$MYHOPPIES")
fi

ARGS=(worker start --name "$NAME")
for dir in "${WORKER_DIRS[@]}"; do
  ARGS+=(--worker-dir "$dir")
done

echo "Starting My Machines worker: $NAME"
echo "Directories: ${WORKER_DIRS[*]}"
echo "Keep this process running while scheduled automations are enabled."
exec agent "${ARGS[@]}"
