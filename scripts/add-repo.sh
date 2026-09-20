#!/usr/bin/env bash
# Add a repository entry to repos.json

set -euo pipefail

source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/lib/common.sh"

NAME=""
URL=""
PATH_ARG=""
BRANCH="main"
CONFIG_FILE="repos.json"

usage() {
  cat <<'EOF'
Usage: ./scripts/add-repo.sh --name NAME --url URL [options]

Options:
  --name NAME          Repository name (required)
  --url URL            Git remote URL (required)
  --path PATH          Local path (default: ./repos/NAME)
  --branch BRANCH      Default branch (default: main)
  --config-file FILE   Config file (default: repos.json)
  -h, --help           Show this help
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --name) NAME="$2"; shift 2 ;;
    --url) URL="$2"; shift 2 ;;
    --path) PATH_ARG="$2"; shift 2 ;;
    --branch) BRANCH="$2"; shift 2 ;;
    --config-file) CONFIG_FILE="$2"; shift 2 ;;
    -h|--help) usage; exit 0 ;;
    *) die "Unknown option: $1" ;;
  esac
done

[[ -n "$NAME" ]] || die "--name is required"
[[ -n "$URL" ]] || die "--url is required"

if [[ -z "$PATH_ARG" ]]; then
  PATH_ARG="./repos/${NAME}"
fi

CONFIG_PATH="$(config_path_for "$CONFIG_FILE")"

python3 - "$CONFIG_PATH" "$NAME" "$URL" "$PATH_ARG" "$BRANCH" <<'PY'
import json
import sys
from pathlib import Path

config_path, name, url, path, branch = sys.argv[1:6]
config_file = Path(config_path)
if config_file.exists():
    with config_file.open(encoding="utf-8") as f:
        data = json.load(f)
else:
    data = {"repos": []}

repos = data.get("repos") or []
existing = [r for r in repos if r.get("name") == name or r.get("url") == url]
if existing:
    print(f"Warning: Repository with name '{name}' or URL '{url}' already exists.", file=sys.stderr)
    response = input("Do you want to update it? (y/N): ").strip()
    if response.lower() != "y":
        print("Aborted.")
        sys.exit(0)
    repos = [r for r in repos if r.get("name") != name and r.get("url") != url]

repos.append({"name": name, "url": url, "path": path, "branch": branch})
data["repos"] = repos
config_file.parent.mkdir(parents=True, exist_ok=True)
with config_file.open("w", encoding="utf-8") as f:
    json.dump(data, f, indent=2)
    f.write("\n")
PY

echo -e "${COLOR_GREEN}[OK] Successfully added repository:${COLOR_RESET}"
echo "  Name: $NAME"
echo "  URL: $URL"
echo "  Path: $PATH_ARG"
echo "  Branch: $BRANCH"
echo ""
echo -e "${COLOR_CYAN}Configuration saved to: ${CONFIG_PATH}${COLOR_RESET}"
echo ""
echo -e "${COLOR_YELLOW}To clone this repository, run:${COLOR_RESET}"
echo -e "  ${COLOR_WHITE}./scripts/clone-repos.sh${COLOR_RESET}"
