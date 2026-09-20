#!/usr/bin/env bash
# Shared helpers for repo management scripts (macOS / Linux bash)

set -euo pipefail

SCRIPT_LIB_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPTS_DIR="$(cd "${SCRIPT_LIB_DIR}/.." && pwd)"
REPO_ROOT="$(cd "${SCRIPTS_DIR}/.." && pwd)"

if [[ -t 1 ]]; then
  COLOR_CYAN='\033[0;36m'
  COLOR_YELLOW='\033[1;33m'
  COLOR_GREEN='\033[0;32m'
  COLOR_RED='\033[0;31m'
  COLOR_WHITE='\033[1;37m'
  COLOR_RESET='\033[0m'
else
  COLOR_CYAN=''
  COLOR_YELLOW=''
  COLOR_GREEN=''
  COLOR_RED=''
  COLOR_WHITE=''
  COLOR_RESET=''
fi

die() {
  echo -e "${COLOR_RED}Error: $*${COLOR_RESET}" >&2
  exit 1
}

warn() {
  echo -e "${COLOR_YELLOW}Warning: $*${COLOR_RESET}" >&2
}

require_python() {
  if ! command -v python3 >/dev/null 2>&1; then
    die "python3 is required to read repos.json"
  fi
}

config_path_for() {
  local config_file="${1:-repos.json}"
  if [[ "$config_file" == /* ]]; then
    echo "$config_file"
  else
    echo "${REPO_ROOT}/${config_file}"
  fi
}

load_env_file() {
  local env_file="$1"
  [[ -f "$env_file" ]] || return 1
  while IFS= read -r line || [[ -n "$line" ]]; do
    line="${line#"${line%%[![:space:]]*}"}"
    [[ -z "$line" || "$line" == \#* ]] && continue
    if [[ "$line" =~ ^([^=]+)=(.*)$ ]]; then
      local name="${BASH_REMATCH[1]}"
      local value="${BASH_REMATCH[2]}"
      name="$(echo "$name" | sed 's/[[:space:]]*$//')"
      value="$(echo "$value" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')"
      value="${value%\"}"
      value="${value#\"}"
      value="${value%\'}"
      value="${value#\'}"
      export "$name=$value"
    fi
  done < "$env_file"
}

# Resolve repo path relative to REPO_ROOT (matches PowerShell scripts)
resolve_repo_path() {
  local repo_path="$1"
  if [[ "$repo_path" == /* ]]; then
    echo "$(cd "$repo_path" 2>/dev/null && pwd || echo "$repo_path")"
    return
  fi
  repo_path="${repo_path#./}"
  repo_path="${repo_path#.\\}"
  echo "$(cd "${REPO_ROOT}/${repo_path}" 2>/dev/null && pwd || echo "${REPO_ROOT}/${repo_path}")"
}

repo_count() {
  local config_path="$1"
  require_python
  python3 - "$config_path" <<'PY'
import json, sys
with open(sys.argv[1], encoding="utf-8") as f:
    data = json.load(f)
print(len(data.get("repos") or []))
PY
}
