#!/usr/bin/env bash
# Clone repositories listed in repos.json

set -euo pipefail

source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/lib/common.sh"

FORCE=false
CONFIG_FILE="repos.json"

usage() {
  cat <<'EOF'
Usage: ./scripts/clone-repos.sh [options]

Options:
  --force              Remove existing directories and re-clone
  --config-file FILE   Config file (default: repos.json)
  -h, --help           Show this help
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --force) FORCE=true; shift ;;
    --config-file) CONFIG_FILE="$2"; shift 2 ;;
    -h|--help) usage; exit 0 ;;
    *) die "Unknown option: $1" ;;
  esac
done

CONFIG_PATH="$(config_path_for "$CONFIG_FILE")"
[[ -f "$CONFIG_PATH" ]] || die "Configuration file not found: $CONFIG_PATH"

require_python
count="$(repo_count "$CONFIG_PATH")"
if [[ "$count" -eq 0 ]]; then
  warn "No repositories configured in $CONFIG_FILE"
  exit 0
fi

echo -e "${COLOR_CYAN}Cloning repositories from ${CONFIG_FILE}...${COLOR_RESET}"
echo ""

success_count=0
skip_count=0
error_count=0

while IFS=$'\t' read -r repo_name repo_url repo_path_raw branch; do
  repo_path="$(resolve_repo_path "$repo_path_raw")"

  echo -e "${COLOR_YELLOW}Processing: ${repo_name}${COLOR_RESET}"
  echo "  URL: $repo_url"
  echo "  Path: $repo_path"
  echo "  Branch: $branch"

  if [[ -e "$repo_path" ]]; then
    if [[ "$FORCE" == true ]]; then
      echo -e "  ${COLOR_YELLOW}Removing existing directory...${COLOR_RESET}"
      rm -rf "$repo_path"
    else
      echo -e "  ${COLOR_YELLOW}Directory already exists. Skipping. Use --force to overwrite.${COLOR_RESET}"
      skip_count=$((skip_count + 1))
      echo ""
      continue
    fi
  fi

  mkdir -p "$(dirname "$repo_path")"

  echo -e "  ${COLOR_GREEN}Cloning...${COLOR_RESET}"
  if git clone -b "$branch" --single-branch "$repo_url" "$repo_path"; then
    echo -e "  ${COLOR_GREEN}[OK] Successfully cloned ${repo_name}${COLOR_RESET}"
    success_count=$((success_count + 1))
  else
    echo -e "  ${COLOR_RED}[ERROR] Failed to clone ${repo_name}${COLOR_RESET}"
    error_count=$((error_count + 1))
  fi
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
echo -e "  ${COLOR_GREEN}Successfully cloned: ${success_count}${COLOR_RESET}"
echo -e "  ${COLOR_YELLOW}Skipped: ${skip_count}${COLOR_RESET}"
if [[ "$error_count" -gt 0 ]]; then
  echo -e "  ${COLOR_RED}Errors: ${error_count}${COLOR_RESET}"
  exit 1
fi
echo -e "  ${COLOR_GREEN}Errors: ${error_count}${COLOR_RESET}"
