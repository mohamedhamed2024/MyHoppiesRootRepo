# Quick MCP Setup - Run this script whenever you update .env file
# CUSTOMIZATION: Review and customize if needed for your environment

Write-Host "Setting up MCP..." -ForegroundColor Green

# Create .cursor folder
if (-not (Test-Path ".cursor")) {
    New-Item -ItemType Directory -Path ".cursor" | Out-Null
}

# Load .env and set variables
if (Test-Path ".env") {
    Get-Content ".env" | ForEach-Object {
        if ($_ -match '^\s*([^#][^=]+)=(.*)$') {
            $name = $matches[1].Trim()
            $value = $matches[2].Trim() -replace "^['`"]|['`"]$", ''
            [Environment]::SetEnvironmentVariable($name, $value, "User")
            Set-Item -Path "env:$name" -Value $value
        }
    }
    Write-Host "[OK] Environment variables loaded from .env" -ForegroundColor Green
} else {
    Write-Host "[WARNING] .env file not found - create it with your tokens" -ForegroundColor Yellow
}

# Copy config template to .cursor/mcp.json
# Cursor will resolve ${env:VAR_NAME} syntax at runtime
if (Test-Path "mcp-config.json") {
    Copy-Item "mcp-config.json" ".cursor/mcp.json" -Force
    Write-Host "[OK] Created .cursor/mcp.json (Cursor will resolve ${env:VAR} syntax at runtime)" -ForegroundColor Green
} else {
    Write-Host "[ERROR] mcp-config.json not found!" -ForegroundColor Red
    exit 1
}

Write-Host "[OK] Done! Restart Cursor IDE to apply changes." -ForegroundColor Green
