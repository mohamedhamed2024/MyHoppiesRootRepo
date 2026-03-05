# Run Command Script
# Executes a command across all configured repositories

param(
    [Parameter(Mandatory=$true)]
    [string]$Command,
    
    [string]$ConfigFile = "repos.json",
    [switch]$StopOnError,
    [switch]$Parallel
)

$ErrorActionPreference = if ($StopOnError) { "Stop" } else { "Continue" }

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

Write-Host "Running command across repositories..." -ForegroundColor Cyan
Write-Host "Command: $Command" -ForegroundColor Yellow
Write-Host ""

$successCount = 0
$skipCount = 0
$errorCount = 0

$jobs = @()

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
        Write-Host "  [ERROR] Directory does not exist. Skipping." -ForegroundColor Red
        $skipCount++
        Write-Host ""
        continue
    }
    
    # Execute command
    $scriptBlock = {
        param($Path, $Cmd, $Name)
        Push-Location $Path
        try {
            $output = Invoke-Expression $Cmd 2>&1
            return @{
                Success = $true
                Output = $output
                Name = $Name
            }
        } catch {
            return @{
                Success = $false
                Output = $_.Exception.Message
                Name = $Name
            }
        } finally {
            Pop-Location
        }
    }
    
    if ($Parallel) {
        $job = Start-Job -ScriptBlock $scriptBlock -ArgumentList $repoPath, $Command, $repoName
        $jobs += $job
        Write-Host "  Started job for $repoName" -ForegroundColor Green
    } else {
        try {
            Push-Location $repoPath
            Write-Host "  Executing..." -ForegroundColor Green
            Invoke-Expression $Command
            if ($LASTEXITCODE -eq 0 -or $LASTEXITCODE -eq $null) {
                Write-Host "  [OK] Successfully executed in $repoName" -ForegroundColor Green
                $successCount++
            } else {
                throw "Command exited with code $LASTEXITCODE"
            }
        } catch {
            Write-Host "  [ERROR] Failed in $repoName : $_" -ForegroundColor Red
            $errorCount++
            if ($StopOnError) {
                Pop-Location
                exit 1
            }
        } finally {
            Pop-Location
        }
    }
    
    Write-Host ""
}

# Wait for parallel jobs
if ($Parallel -and $jobs.Count -gt 0) {
    Write-Host "Waiting for parallel jobs to complete..." -ForegroundColor Cyan
    $jobs | Wait-Job | Out-Null
    
    foreach ($job in $jobs) {
        $result = Receive-Job -Job $job
        Write-Host "Result for $($result.Name):" -ForegroundColor Yellow
        if ($result.Success) {
            Write-Host $result.Output
            Write-Host "  [OK] Success" -ForegroundColor Green
            $successCount++
        } else {
            Write-Host $result.Output
            Write-Host "  [ERROR] Failed" -ForegroundColor Red
            $errorCount++
        }
        Remove-Job -Job $job
        Write-Host ""
    }
}

Write-Host "Summary:" -ForegroundColor Cyan
Write-Host "  Successfully executed: $successCount" -ForegroundColor Green
Write-Host "  Skipped: $skipCount" -ForegroundColor Yellow
$errorColor = if ($errorCount -gt 0) { "Red" } else { "Green" }
Write-Host "  Errors: $errorCount" -ForegroundColor $errorColor

if ($errorCount -gt 0) {
    exit 1
}
