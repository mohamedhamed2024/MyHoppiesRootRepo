# Add Repository Script
# Adds a new repository to the repos.json configuration

param(
    [Parameter(Mandatory=$true)]
    [string]$Name,
    
    [Parameter(Mandatory=$true)]
    [string]$Url,
    
    [string]$Path = "",
    [string]$Branch = "main",
    [string]$ConfigFile = "repos.json"
)

$ErrorActionPreference = "Stop"

# Get the root directory (where the script is located)
$ScriptRoot = Split-Path -Parent $PSScriptRoot
$ConfigPath = Join-Path $ScriptRoot $ConfigFile

# Read existing configuration or create new
if (Test-Path $ConfigPath) {
    $config = Get-Content $ConfigPath | ConvertFrom-Json
} else {
    $config = @{
        repos = @()
    } | ConvertTo-Json | ConvertFrom-Json
}

# Generate default path if not provided
if ([string]::IsNullOrWhiteSpace($Path)) {
    $Path = "./repos/$Name"
}

# Check if repository already exists
$existingRepo = $config.repos | Where-Object { $_.name -eq $Name -or $_.url -eq $Url }
if ($existingRepo) {
    Write-Warning "Repository with name '$Name' or URL '$Url' already exists."
    $response = Read-Host "Do you want to update it? (y/N)"
    if ($response -ne "y" -and $response -ne "Y") {
        Write-Host "Aborted."
        exit 0
    }
    # Remove existing entry
    $config.repos = $config.repos | Where-Object { $_.name -ne $Name -and $_.url -ne $Url }
}

# Add new repository
$newRepo = @{
    name = $Name
    url = $Url
    path = $Path
    branch = $Branch
}

$config.repos += $newRepo

# Save configuration
$json = $config | ConvertTo-Json -Depth 10
$json | Set-Content -Path $ConfigPath -Encoding UTF8

Write-Host "[OK] Successfully added repository:" -ForegroundColor Green
Write-Host "  Name: $Name"
Write-Host "  URL: $Url"
Write-Host "  Path: $Path"
Write-Host "  Branch: $Branch"
Write-Host ""
Write-Host "Configuration saved to: $ConfigPath" -ForegroundColor Cyan
Write-Host ""
Write-Host "To clone this repository, run:" -ForegroundColor Yellow
Write-Host "  .\scripts\clone-repos.ps1" -ForegroundColor White
