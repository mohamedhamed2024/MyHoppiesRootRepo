# MCP Setup Script
# Sets up and validates MCP (Model Context Protocol) configuration

param(
    [switch]$CheckOnly,
    [string]$McpConfigPath = ".cursor/mcp.json"
)

$ErrorActionPreference = "Stop"

# Get the root directory (where the script is located)
$ScriptRoot = Split-Path -Parent $PSScriptRoot
$McpConfigFullPath = Join-Path $ScriptRoot $McpConfigPath

Write-Host "MCP Configuration Setup" -ForegroundColor Cyan
Write-Host "======================" -ForegroundColor Cyan
Write-Host ""

# Check if MCP config exists
if (-not (Test-Path $McpConfigFullPath)) {
    Write-Warning "MCP configuration file not found at: $McpConfigFullPath"
    Write-Host "Creating default MCP configuration..." -ForegroundColor Yellow
    
    # Create .cursor directory if it doesn't exist
    $cursorDir = Split-Path -Parent $McpConfigFullPath
    if (-not (Test-Path $cursorDir)) {
        New-Item -ItemType Directory -Path $cursorDir -Force | Out-Null
    }
    
    # Create default MCP configuration
    $defaultConfig = @{
        mcpServers = @{
            filesystem = @{
                command = "npx"
                args = @("-y", "@modelcontextprotocol/server-filesystem", $ScriptRoot)
            }
            github = @{
                command = "npx"
                args = @("-y", "@modelcontextprotocol/server-github")
                env = @{
                    GITHUB_PERSONAL_ACCESS_TOKEN = ""
                }
            }
        }
    } | ConvertTo-Json -Depth 10
    
    $defaultConfig | Set-Content -Path $McpConfigFullPath -Encoding UTF8
    Write-Host "[OK] Created default MCP configuration" -ForegroundColor Green
    Write-Host ""
}

# Read and validate MCP configuration
Write-Host "Reading MCP configuration..." -ForegroundColor Cyan
try {
    $mcpConfig = Get-Content $McpConfigFullPath | ConvertFrom-Json
    Write-Host "[OK] Configuration file is valid JSON" -ForegroundColor Green
} catch {
    Write-Error "Invalid JSON in MCP configuration file: $_"
    exit 1
}

# Check for required structure
if (-not $mcpConfig.mcpServers) {
    Write-Warning "MCP configuration missing 'mcpServers' section"
} else {
    Write-Host "[OK] Found $($mcpConfig.mcpServers.PSObject.Properties.Count) MCP server(s) configured" -ForegroundColor Green
    Write-Host ""
    
    # Validate each server
    foreach ($serverName in $mcpConfig.mcpServers.PSObject.Properties.Name) {
        $server = $mcpConfig.mcpServers.$serverName
        Write-Host "Server: $serverName" -ForegroundColor Yellow
        
        if (-not $server.command) {
            Write-Warning "  [WARNING] Missing 'command' property"
        } else {
            Write-Host "  Command: $($server.command)" -ForegroundColor Green
        }
        
        if ($server.args) {
            Write-Host "  Args: $($server.args -join ' ')" -ForegroundColor Cyan
        }
        
        # Check for environment variables
        if ($server.env) {
            Write-Host "  Environment variables:" -ForegroundColor Cyan
            foreach ($envVar in $server.env.PSObject.Properties.Name) {
                $envValue = $server.env.$envVar
                if ([string]::IsNullOrWhiteSpace($envValue)) {
                    Write-Host "    [WARNING] $envVar = (not set)" -ForegroundColor Yellow
                } else {
                    Write-Host "    [OK] $envVar = (set)" -ForegroundColor Green
                }
            }
        }
        
        Write-Host ""
    }
}

# Check for GitHub token if GitHub server is configured
if ($mcpConfig.mcpServers.github) {
    Write-Host "GitHub MCP Server Configuration" -ForegroundColor Cyan
    Write-Host "-------------------------------" -ForegroundColor Cyan
    
    $githubToken = $env:GITHUB_PERSONAL_ACCESS_TOKEN
    if ([string]::IsNullOrWhiteSpace($githubToken)) {
        Write-Warning "GITHUB_PERSONAL_ACCESS_TOKEN environment variable is not set"
        Write-Host ""
        Write-Host "To set up GitHub MCP server:" -ForegroundColor Yellow
        Write-Host "1. Create a GitHub Personal Access Token at: https://github.com/settings/tokens" -ForegroundColor White
        Write-Host "2. Set the environment variable:" -ForegroundColor White
        Write-Host "   [System.Environment]::SetEnvironmentVariable('GITHUB_PERSONAL_ACCESS_TOKEN', 'your-token-here', 'User')" -ForegroundColor Cyan
        Write-Host "3. Restart Cursor IDE" -ForegroundColor White
    } else {
        Write-Host "[OK] GITHUB_PERSONAL_ACCESS_TOKEN is set" -ForegroundColor Green
    }
    Write-Host ""
}

# Check if npx is available (required for MCP servers)
Write-Host "Checking prerequisites..." -ForegroundColor Cyan
try {
    $npxVersion = & npx --version 2>&1
    Write-Host "[OK] npx is available (version: $npxVersion)" -ForegroundColor Green
} catch {
    Write-Warning "npx is not available. MCP servers may not work properly."
    Write-Host "Install Node.js to get npx: https://nodejs.org/" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "MCP Configuration Location:" -ForegroundColor Cyan
Write-Host "  $McpConfigFullPath" -ForegroundColor White
Write-Host ""
Write-Host "Note: After configuring MCP servers, restart Cursor IDE for changes to take effect." -ForegroundColor Yellow

if ($CheckOnly) {
    Write-Host ""
    Write-Host "Check completed. No changes made." -ForegroundColor Green
}
