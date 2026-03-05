# Sync Repositories Script
# Pulls latest changes from all configured repositories

param(
    [string]$ConfigFile = "repos.json"
)

$ErrorActionPreference = "Continue"

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

Write-Host "Syncing repositories from $ConfigFile..." -ForegroundColor Cyan
Write-Host ""

$successCount = 0
$skipCount = 0
$errorCount = 0

foreach ($repo in $config.repos) {
    $repoName = $repo.name
    $repoPath = $repo.path
    
    # Resolve relative paths
    if (-not [System.IO.Path]::IsPathRooted($repoPath)) {
        # Remove leading .\ or ./ if present
        $repoPath = $repoPath -replace '^\.\\', '' -replace '^\./', ''
        $repoPath = Join-Path $ScriptRoot $repoPath
    }
    # Normalize the path (remove .\ and resolve to absolute)
    $repoPath = [System.IO.Path]::GetFullPath($repoPath)
    
    Write-Host "Processing: $repoName" -ForegroundColor Yellow
    Write-Host "  Path: $repoPath"
    
    # Check if directory exists
    if (-not (Test-Path $repoPath)) {
        Write-Host "  [ERROR] Directory does not exist. Run clone-repos.ps1 first." -ForegroundColor Red
        $errorCount++
        Write-Host ""
        continue
    }
    
    # Check if it's a git repository
    $gitDir = Join-Path $repoPath ".git"
    if (-not (Test-Path $gitDir)) {
        Write-Host "  [SKIP] Not a git repository. Skipping." -ForegroundColor Yellow
        $skipCount++
        Write-Host ""
        continue
    }
    
    # Get current branch
    Push-Location $repoPath
    try {
        $currentBranch = & git rev-parse --abbrev-ref HEAD 2>&1
        Write-Host "  Branch: $currentBranch"
        
        # Check for uncommitted changes
        $status = & git status --porcelain 2>&1
        if ($status) {
            Write-Host "  [WARNING] Uncommitted changes detected" -ForegroundColor Yellow
        }
        
        # Fetch latest changes
        Write-Host "  Fetching latest changes..." -ForegroundColor Green
        $fetchResult = & git fetch origin 2>&1
        if ($LASTEXITCODE -ne 0) {
            throw "Git fetch failed"
        }
        
        # Pull latest changes
        Write-Host "  Pulling changes..." -ForegroundColor Green
        $pullResult = & git pull origin $currentBranch 2>&1
        if ($LASTEXITCODE -eq 0) {
            Write-Host "  [OK] Successfully synced $repoName" -ForegroundColor Green
            $successCount++
        } else {
            throw "Git pull failed"
        }
    } catch {
        Write-Host "  [ERROR] Failed to sync $repoName : $_" -ForegroundColor Red
        $errorCount++
    } finally {
        Pop-Location
    }
    
    Write-Host ""
}

Write-Host "Summary:" -ForegroundColor Cyan
Write-Host "  Successfully synced: $successCount" -ForegroundColor Green
Write-Host "  Skipped: $skipCount" -ForegroundColor Yellow
$errorColor = if ($errorCount -gt 0) { "Red" } else { "Green" }
Write-Host "  Errors: $errorCount" -ForegroundColor $errorColor

if ($errorCount -gt 0) {
    exit 1
}
