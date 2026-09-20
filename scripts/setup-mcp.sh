#!/usr/bin/env bash
# Quick MCP setup — run after updating .env

set -euo pipefail

source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/lib/common.sh"

cd "$REPO_ROOT"

echo -e "${COLOR_GREEN}Setting up MCP...${COLOR_RESET}"

mkdir -p .cursor

ENV_FILE="${REPO_ROOT}/.env"
if [[ -f "$ENV_FILE" ]]; then
  load_env_file "$ENV_FILE"
  echo -e "${COLOR_GREEN}[OK] Environment variables loaded from .env (current shell session)${COLOR_RESET}"
  echo -e "${COLOR_YELLOW}Note: Restart Cursor after setting tokens. On macOS, launch Cursor from a terminal${COLOR_RESET}"
  echo -e "${COLOR_YELLOW}      (or add exports to ~/.zshrc) so MCP can read \${env:VAR} values.${COLOR_RESET}"
else
  echo -e "${COLOR_YELLOW}[WARNING] .env file not found - create it with your tokens${COLOR_RESET}"
fi

if [[ -f "${REPO_ROOT}/mcp-config.json" ]]; then
  cp "${REPO_ROOT}/mcp-config.json" "${REPO_ROOT}/.cursor/mcp.json"
  echo -e "${COLOR_GREEN}[OK] Created .cursor/mcp.json (Cursor resolves \${env:VAR} at runtime)${COLOR_RESET}"
else
  echo -e "${COLOR_RED}[ERROR] mcp-config.json not found!${COLOR_RESET}"
  exit 1
fi

echo -e "${COLOR_GREEN}[OK] Done! Restart Cursor IDE to apply changes.${COLOR_RESET}"
