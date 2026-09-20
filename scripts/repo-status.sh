#!/usr/bin/env bash
# Git status report for all configured repositories

set -euo pipefail

source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/lib/common.sh"

CONFIG_FILE="repos.json"
DETAILED=false

usage() {
  cat <<'EOF'
Usage: ./scripts/repo-status.sh [options]

Options:
  --detailed           Show per-file change list
  --config-file FILE   Config file (default: repos.json)
  -h, --help           Show this help
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --detailed) DETAILED=true; shift ;;
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

echo -e "${COLOR_CYAN}Repository Status Report${COLOR_RESET}"
echo -e "${COLOR_CYAN}=======================${COLOR_RESET}"
echo ""

while IFS=$'\t' read -r repo_name _ repo_path_raw _; do
  repo_path="$(resolve_repo_path "$repo_path_raw")"

  echo -e "${COLOR_YELLOW}${repo_name}${COLOR_RESET}"
  echo "  Path: $repo_path"

  if [[ ! -d "$repo_path" ]]; then
    echo -e "  Status: ${COLOR_RED}[ERROR] Directory does not exist${COLOR_RESET}"
    echo ""
    continue
  fi

  if [[ ! -d "$repo_path/.git" ]]; then
    echo -e "  Status: ${COLOR_YELLOW}[SKIP] Not a git repository${COLOR_RESET}"
    echo ""
    continue
  fi

  (
    cd "$repo_path"
    current_branch="$(git rev-parse --abbrev-ref HEAD)"
    commit_hash="$(git rev-parse --short HEAD)"
    remote_url="$(git config --get remote.origin.url || true)"

    echo -e "  Branch: ${COLOR_CYAN}${current_branch}${COLOR_RESET}"
    echo "  Commit: $commit_hash"
    [[ -n "$remote_url" ]] && echo "  Remote: $remote_url"

    status="$(git status --porcelain)"
    if [[ -n "$status" ]]; then
      changed_files="$(printf '%s\n' "$status" | sed '/^$/d' | wc -l | tr -d ' ')"
      echo -e "  Status: ${COLOR_YELLOW}[WARNING] ${changed_files} file(s) with uncommitted changes${COLOR_RESET}"
      if [[ "$DETAILED" == true ]]; then
        echo -e "  Changes: ${COLOR_YELLOW}"
        while IFS= read -r line; do
          [[ -n "$line" ]] && echo "    $line"
        done <<< "$status"
        echo -e "${COLOR_RESET}"
      fi
    else
      echo -e "  Status: ${COLOR_GREEN}[OK] Clean (no uncommitted changes)${COLOR_RESET}"
    fi

    git fetch origin --quiet 2>/dev/null || true
    if git rev-parse --verify "origin/${current_branch}" >/dev/null 2>&1; then
      behind="$(git rev-list --count "HEAD..origin/${current_branch}" 2>/dev/null || echo 0)"
      ahead="$(git rev-list --count "origin/${current_branch}..HEAD" 2>/dev/null || echo 0)"
      if [[ "$behind" -gt 0 ]]; then
        echo -e "  ${COLOR_YELLOW}[WARNING] Branch is ${behind} commit(s) behind remote${COLOR_RESET}"
      fi
      if [[ "$ahead" -gt 0 ]]; then
        echo -e "  ${COLOR_YELLOW}[WARNING] Branch is ${ahead} commit(s) ahead of remote${COLOR_RESET}"
      fi
      if [[ "$behind" -eq 0 && "$ahead" -eq 0 ]]; then
        echo -e "  ${COLOR_GREEN}[OK] Branch is up to date with remote${COLOR_RESET}"
      fi
    fi
  ) || echo -e "  ${COLOR_RED}[ERROR] Error getting status${COLOR_RESET}"

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
