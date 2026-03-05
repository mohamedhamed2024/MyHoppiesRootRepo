# Repository Status Script
# Shows git status for all configured repositories

param(
    [string]$ConfigFile = "repos.json",
    [switch]$Detailed
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

Write-Host "Repository Status Report" -ForegroundColor Cyan
Write-Host "=======================" -ForegroundColor Cyan
Write-Host ""

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
    
    Write-Host "$repoName" -ForegroundColor Yellow
    Write-Host "  Path: $repoPath"
    
    # Check if directory exists
    if (-not (Test-Path $repoPath)) {
        Write-Host "  Status: [ERROR] Directory does not exist" -ForegroundColor Red
        Write-Host ""
        continue
    }
    
    # Check if it's a git repository
    $gitDir = Join-Path $repoPath ".git"
    if (-not (Test-Path $gitDir)) {
        Write-Host "  Status: [SKIP] Not a git repository" -ForegroundColor Yellow
        Write-Host ""
        continue
    }
    
    Push-Location $repoPath
    try {
        # Get current branch
        $currentBranch = & git rev-parse --abbrev-ref HEAD 2>&1
        Write-Host "  Branch: $currentBranch" -ForegroundColor Cyan
        
        # Get commit hash
        $commitHash = & git rev-parse --short HEAD 2>&1
        Write-Host "  Commit: $commitHash"
        
        # Get remote URL
        $remoteUrl = & git config --get remote.origin.url 2>&1
        if ($remoteUrl) {
            Write-Host "  Remote: $remoteUrl"
        }
        
        # Check for uncommitted changes
        $status = & git status --porcelain 2>&1
        if ($status) {
            $changedFiles = ($status | Measure-Object -Line).Lines
            Write-Host "  Status: [WARNING] $changedFiles file(s) with uncommitted changes" -ForegroundColor Yellow
            
            if ($Detailed) {
                Write-Host "  Changes:" -ForegroundColor Yellow
                $status | ForEach-Object {
                    Write-Host "    $_"
                }
            }
        } else {
            Write-Host "  Status: [OK] Clean (no uncommitted changes)" -ForegroundColor Green
        }
        
        # Check if branch is ahead/behind remote
        & git fetch origin --quiet 2>&1 | Out-Null
        $ahead = & git rev-list --count HEAD..origin/$currentBranch 2>&1
        $behind = & git rev-list --count origin/$currentBranch..HEAD 2>&1
        
        if ($ahead -gt 0) {
            Write-Host "  [WARNING] Branch is $ahead commit(s) behind remote" -ForegroundColor Yellow
        }
        if ($behind -gt 0) {
            Write-Host "  [WARNING] Branch is $behind commit(s) ahead of remote" -ForegroundColor Yellow
        }
        if ($ahead -eq 0 -and $behind -eq 0) {
            Write-Host "  [OK] Branch is up to date with remote" -ForegroundColor Green
        }
        
    } catch {
        Write-Host "  [ERROR] Error getting status: $_" -ForegroundColor Red
    } finally {
        Pop-Location
    }
    
    Write-Host ""
}
