#!/usr/bin/env bash
# Pull latest changes for all configured repositories

set -euo pipefail

source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/lib/common.sh"

CONFIG_FILE="repos.json"

usage() {
  cat <<'EOF'
Usage: ./scripts/sync-repos.sh [options]

Options:
  --config-file FILE   Config file (default: repos.json)
  -h, --help           Show this help
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --config-file) CONFIG_FILE="$2"; shift 2 ;;
    -h|--help) usage; exit 0 ;;
    *) die "Unknown option: $1" ;;
  esac
done

CONFIG_PATH="$(config_path_for "$CONFIG_FILE")"
[[ -f "$CONFIG_PATH" ]] || die "Configuration file not found: $CONFIG_PATH"

count="$(repo_count "$CONFIG_PATH")"
if [[ "$count" -eq 0 ]]; then
  warn "No repositories configured in $CONFIG_FILE"
  exit 0
fi

echo -e "${COLOR_CYAN}Syncing repositories from ${CONFIG_FILE}...${COLOR_RESET}"
echo ""

success_count=0
skip_count=0
error_count=0

while IFS=$'\t' read -r repo_name _ repo_path_raw _; do
  repo_path="$(resolve_repo_path "$repo_path_raw")"

  echo -e "${COLOR_YELLOW}Processing: ${repo_name}${COLOR_RESET}"
  echo "  Path: $repo_path"

  if [[ ! -d "$repo_path" ]]; then
    echo -e "  ${COLOR_RED}[ERROR] Directory does not exist. Run ./scripts/clone-repos.sh first.${COLOR_RESET}"
    error_count=$((error_count + 1))
    echo ""
    continue
  fi

  if [[ ! -d "$repo_path/.git" ]]; then
    echo -e "  ${COLOR_YELLOW}[SKIP] Not a git repository. Skipping.${COLOR_RESET}"
    skip_count=$((skip_count + 1))
    echo ""
    continue
  fi

  (
    cd "$repo_path"
    current_branch="$(git rev-parse --abbrev-ref HEAD)"
    echo "  Branch: $current_branch"

    if [[ -n "$(git status --porcelain)" ]]; then
      echo -e "  ${COLOR_YELLOW}[WARNING] Uncommitted changes detected${COLOR_RESET}"
    fi

    echo -e "  ${COLOR_GREEN}Fetching latest changes...${COLOR_RESET}"
    if ! git fetch origin; then
      echo -e "  ${COLOR_RED}[ERROR] Failed to sync ${repo_name}: git fetch failed${COLOR_RESET}"
      exit 1
    fi

    echo -e "  ${COLOR_GREEN}Pulling changes...${COLOR_RESET}"
    if git pull origin "$current_branch"; then
      echo -e "  ${COLOR_GREEN}[OK] Successfully synced ${repo_name}${COLOR_RESET}"
      exit 0
    fi
    echo -e "  ${COLOR_RED}[ERROR] Failed to sync ${repo_name}: git pull failed${COLOR_RESET}"
    exit 1
  ) && success_count=$((success_count + 1)) || error_count=$((error_count + 1))

  echo ""
done < <(python3 - "$CONFIG_PATH" <<'PY'
import json, sys
with open(sys.argv[1], encoding="utf-8") as f:
    for repo in json.load(f).get("repos") or []:
        print(
            repo.get("name", ""),
            repo.get("url", ""),
            repo.get("path", ""),
            repo.get("branch") or "main",
            sep="\t",
        )
PY
)

echo -e "${COLOR_CYAN}Summary:${COLOR_RESET}"
echo -e "  ${COLOR_GREEN}Successfully synced: ${success_count}${COLOR_RESET}"
echo -e "  ${COLOR_YELLOW}Skipped: ${skip_count}${COLOR_RESET}"
if [[ "$error_count" -gt 0 ]]; then
  echo -e "  ${COLOR_RED}Errors: ${error_count}${COLOR_RESET}"
  exit 1
fi
echo -e "  ${COLOR_GREEN}Errors: ${error_count}${COLOR_RESET}"
