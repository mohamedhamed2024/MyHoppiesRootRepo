# Clone Repositories Script
# Clones all repositories listed in repos.json to their specified paths

param(
    [switch]$Force,
    [string]$ConfigFile = "repos.json"
)

$ErrorActionPreference = "Stop"

# Get the root directory (where the script is located)
$ScriptRoot = Split-Path -Parent $PSScriptRoot
$ConfigPath = Join-Path $ScriptRoot $ConfigFile

if (-not (Test-Path $ConfigPath)) {
    Write-Error "Configuration file not found: $ConfigPath"
    exit 1
}

# Read configuration
$config = Get-Content $ConfigPath | ConvertFrom-Json

if (-not $config.repos -or $config.repos.Count -eq 0) {
    Write-Warning "No repositories configured in $ConfigFile"
    exit 0
}

Write-Host "Cloning repositories from $ConfigFile..." -ForegroundColor Cyan
Write-Host ""

$successCount = 0
$skipCount = 0
$errorCount = 0

foreach ($repo in $config.repos) {
    $repoName = $repo.name
    $repoUrl = $repo.url
    $repoPath = $repo.path
    $branch = if ($repo.branch) { $repo.branch } else { "main" }
    
    # Resolve relative paths
    if (-not [System.IO.Path]::IsPathRooted($repoPath)) {
        # Remove leading .\ or ./ if present
        $repoPath = $repoPath -replace '^\.\\', '' -replace '^\./', ''
        $repoPath = Join-Path $ScriptRoot $repoPath
    }
    # Normalize the path (remove .\ and resolve to absolute)
    $repoPath = [System.IO.Path]::GetFullPath($repoPath)
    
    Write-Host "Processing: $repoName" -ForegroundColor Yellow
    Write-Host "  URL: $repoUrl"
    Write-Host "  Path: $repoPath"
    Write-Host "  Branch: $branch"
    
    # Check if directory already exists
    if (Test-Path $repoPath) {
        if ($Force) {
            Write-Host "  Removing existing directory..." -ForegroundColor Yellow
            Remove-Item -Path $repoPath -Recurse -Force
        } else {
            Write-Host "  Directory already exists. Skipping. Use -Force to overwrite." -ForegroundColor Yellow
            $skipCount++
            Write-Host ""
            continue
        }
    }
    
    # Create parent directory if it doesn't exist
    $parentDir = Split-Path -Parent $repoPath
    if (-not (Test-Path $parentDir)) {
        New-Item -ItemType Directory -Path $parentDir -Force | Out-Null
    }
    
    # Clone the repository
    try {
        Write-Host "  Cloning..." -ForegroundColor Green
        $cloneArgs = @("clone", "-b", $branch, "--single-branch", $repoUrl, $repoPath)
        $result = & git $cloneArgs 2>&1
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "  [OK] Successfully cloned $repoName" -ForegroundColor Green
            $successCount++
        } else {
            throw "Git clone failed with exit code $LASTEXITCODE"
        }
    } catch {
        Write-Host "  [ERROR] Failed to clone $repoName : $_" -ForegroundColor Red
        $errorCount++
    }
    
    Write-Host ""
}

Write-Host "Summary:" -ForegroundColor Cyan
Write-Host "  Successfully cloned: $successCount" -ForegroundColor Green
Write-Host "  Skipped: $skipCount" -ForegroundColor Yellow
$errorColor = if ($errorCount -gt 0) { "Red" } else { "Green" }
Write-Host "  Errors: $errorCount" -ForegroundColor $errorColor

if ($errorCount -gt 0) {
    exit 1
}
