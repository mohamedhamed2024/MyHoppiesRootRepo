#!/usr/bin/env bash
# Run a shell command in each configured repository

set -euo pipefail

source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/lib/common.sh"

CONFIG_FILE="repos.json"
COMMAND=""
STOP_ON_ERROR=false
PARALLEL=false

usage() {
  cat <<'EOF'
Usage: ./scripts/run-command.sh --command "CMD" [options]

Options:
  --command CMD        Command to run in each repo (required)
  --stop-on-error      Stop if any repository fails
  --parallel           Run commands in parallel
  --config-file FILE   Config file (default: repos.json)
  -h, --help           Show this help
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --command) COMMAND="$2"; shift 2 ;;
    --stop-on-error) STOP_ON_ERROR=true; shift ;;
    --parallel) PARALLEL=true; shift ;;
    --config-file) CONFIG_FILE="$2"; shift 2 ;;
    -h|--help) usage; exit 0 ;;
    *) die "Unknown option: $1" ;;
  esac
done

[[ -n "$COMMAND" ]] || die "--command is required"

CONFIG_PATH="$(config_path_for "$CONFIG_FILE")"
[[ -f "$CONFIG_PATH" ]] || die "Configuration file not found: $CONFIG_PATH"

count="$(repo_count "$CONFIG_PATH")"
if [[ "$count" -eq 0 ]]; then
  warn "No repositories configured in $CONFIG_FILE"
  exit 0
fi

echo -e "${COLOR_CYAN}Running command across repositories...${COLOR_RESET}"
echo -e "${COLOR_YELLOW}Command: ${COMMAND}${COLOR_RESET}"
echo ""

success_count=0
skip_count=0
error_count=0

run_in_repo() {
  local repo_name="$1"
  local repo_path="$2"

  echo -e "${COLOR_YELLOW}Processing: ${repo_name}${COLOR_RESET}"
  echo "  Path: $repo_path"

  if [[ ! -d "$repo_path" ]]; then
    echo -e "  ${COLOR_RED}[ERROR] Directory does not exist. Skipping.${COLOR_RESET}"
    skip_count=$((skip_count + 1))
    echo ""
    return 0
  fi

  echo -e "  ${COLOR_GREEN}Executing...${COLOR_RESET}"
  if (cd "$repo_path" && eval "$COMMAND"); then
    echo -e "  ${COLOR_GREEN}[OK] Successfully executed in ${repo_name}${COLOR_RESET}"
    success_count=$((success_count + 1))
  else
    echo -e "  ${COLOR_RED}[ERROR] Failed in ${repo_name}${COLOR_RESET}"
    error_count=$((error_count + 1))
    if [[ "$STOP_ON_ERROR" == true ]]; then
      exit 1
    fi
  fi
  echo ""
}

if [[ "$PARALLEL" == true ]]; then
  pids=()
  job_names=()
  while IFS=$'\t' read -r repo_name _ repo_path_raw _; do
    repo_path="$(resolve_repo_path "$repo_path_raw")"
    echo -e "${COLOR_YELLOW}Processing: ${repo_name}${COLOR_RESET}"
    echo "  Path: $repo_path"
    if [[ ! -d "$repo_path" ]]; then
      echo -e "  ${COLOR_RED}[ERROR] Directory does not exist. Skipping.${COLOR_RESET}"
      skip_count=$((skip_count + 1))
      echo ""
      continue
    fi
    (
      cd "$repo_path"
      eval "$COMMAND"
    ) &
    pids+=("$!")
    job_names+=("$repo_name")
    echo -e "  ${COLOR_GREEN}Started job for ${repo_name}${COLOR_RESET}"
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

  if [[ ${#pids[@]} -gt 0 ]]; then
    echo -e "${COLOR_CYAN}Waiting for parallel jobs to complete...${COLOR_RESET}"
    for i in "${!pids[@]}"; do
      if wait "${pids[$i]}"; then
        echo -e "${COLOR_GREEN}  [OK] ${job_names[$i]}${COLOR_RESET}"
        success_count=$((success_count + 1))
      else
        echo -e "${COLOR_RED}  [ERROR] ${job_names[$i]}${COLOR_RESET}"
        error_count=$((error_count + 1))
        [[ "$STOP_ON_ERROR" == true ]] && exit 1
      fi
    done
  fi
else
  while IFS=$'\t' read -r repo_name _ repo_path_raw _; do
    run_in_repo "$repo_name" "$(resolve_repo_path "$repo_path_raw")"
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
fi

echo -e "${COLOR_CYAN}Summary:${COLOR_RESET}"
echo -e "  ${COLOR_GREEN}Successfully executed: ${success_count}${COLOR_RESET}"
echo -e "  ${COLOR_YELLOW}Skipped: ${skip_count}${COLOR_RESET}"
if [[ "$error_count" -gt 0 ]]; then
  echo -e "  ${COLOR_RED}Errors: ${error_count}${COLOR_RESET}"
  exit 1
fi
echo -e "  ${COLOR_GREEN}Errors: ${error_count}${COLOR_RESET}"
