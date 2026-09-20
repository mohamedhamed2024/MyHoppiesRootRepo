# MyHoppiesRootRepo

My Hoppies Root Repo to manage multiple repositories from a single workspace.

## Overview

This repository provides a Cursor workspace configuration and PowerShell scripts to manage multiple Git repositories from a single root workspace. It includes tools for cloning, syncing, and managing repositories, as well as MCP (Model Context Protocol) configuration for enhanced IDE capabilities.

## Features

- **Multi-repo workspace**: Manage multiple repositories from a single Cursor workspace
- **Clone repositories**: Automatically clone all configured repositories (main branch)
- **Sync repositories**: Pull latest changes from all repositories
- **Repository status**: Check the status of all repositories at once
- **Run commands**: Execute commands across all repositories
- **MCP integration**: Configure MCP servers for enhanced IDE features

## Quick Start

### 1. Configure Repositories

Edit `repos.json` to add your repositories:

```json
{
	"repos": [
		{
			"name": "my-project",
			"url": "https://github.com/username/my-project.git",
			"path": "./repos/my-project",
			"branch": "main"
		}
	]
}
```

Or use the helper script:

```powershell
.\scripts\add-repo.ps1 -Name "my-project" -Url "https://github.com/username/my-project.git"
```

### 2. Clone Repositories

Clone all configured repositories:

```powershell
.\scripts\clone-repos.ps1
```

To force re-clone existing repositories:

```powershell
.\scripts\clone-repos.ps1 -Force
```

### 3. Open Workspace

Open the workspace file in Cursor:

```powershell
cursor MyHoppiesRootRepo.code-workspace
```

Or simply open the folder in Cursor - it will detect the workspace file.

## Scripts

All scripts are located in the `scripts/` directory.

**macOS / Linux (Terminal):** use the `.sh` scripts (requires `bash` and `python3`):

```bash
chmod +x scripts/*.sh   # once, if needed
./scripts/clone-repos.sh
./scripts/sync-repos.sh
./scripts/repo-status.sh
./scripts/run-command.sh --command "git status"
./scripts/add-repo.sh --name "my-project" --url "https://github.com/username/my-project.git"
./scripts/setup-mcp.sh
```

**Windows (PowerShell):** use the `.ps1` scripts below.

### `clone-repos.ps1` / `clone-repos.sh`

Clones all repositories listed in `repos.json` to their specified paths.

**Usage:**
```powershell
.\scripts\clone-repos.ps1
.\scripts\clone-repos.ps1 -Force  # Force re-clone existing repos
.\scripts\clone-repos.ps1 -ConfigFile "custom-repos.json"
```

### `sync-repos.ps1` / `sync-repos.sh`

Pulls latest changes from all configured repositories.

**Usage:**
```powershell
.\scripts\sync-repos.ps1
.\scripts\sync-repos.ps1 -ConfigFile "custom-repos.json"
```

### `repo-status.ps1` / `repo-status.sh`

Shows git status for all configured repositories.

**Usage:**
```powershell
.\scripts\repo-status.ps1
.\scripts\repo-status.ps1 -Detailed  # Show detailed change information
```

### `run-command.ps1` / `run-command.sh`

Executes a command across all repositories.

**Usage:**
```powershell
.\scripts\run-command.ps1 -Command "git status"
.\scripts\run-command.ps1 -Command "npm install" -StopOnError
.\scripts\run-command.ps1 -Command "git log --oneline -5" -Parallel
```

**Parameters:**
- `-Command`: The command to execute (required)
- `-StopOnError`: Stop execution if any repository fails
- `-Parallel`: Run commands in parallel (PowerShell jobs)

### `add-repo.ps1` / `add-repo.sh`

Adds a new repository to the `repos.json` configuration.

**Usage:**
```powershell
.\scripts\add-repo.ps1 -Name "my-project" -Url "https://github.com/username/my-project.git"
.\scripts\add-repo.ps1 -Name "my-project" -Url "https://github.com/username/my-project.git" -Path "./repos/my-project" -Branch "main"
```

**Parameters:**
- `-Name`: Repository name (required)
- `-Url`: Git repository URL (required)
- `-Path`: Local path (default: `./repos/{name}`)
- `-Branch`: Branch to clone (default: `main`)

### `setup-mcp.ps1` / `setup-mcp.sh`

Sets up and validates MCP (Model Context Protocol) configuration.

**Usage:**
```powershell
.\scripts\setup-mcp.ps1
.\scripts\setup-mcp.ps1 -CheckOnly  # Only validate, don't create
```

## MCP Configuration

MCP (Model Context Protocol) servers are configured in `.cursor/mcp.json`. The default configuration includes:

- **Filesystem MCP Server**: Provides file system access
- **GitHub MCP Server**: Provides GitHub API access

### Setting up GitHub MCP Server

1. Create a GitHub Personal Access Token:
   - Go to https://github.com/settings/tokens
   - Generate a new token with appropriate permissions

2. Set the environment variable:
   ```powershell
   [System.Environment]::SetEnvironmentVariable('GITHUB_PERSONAL_ACCESS_TOKEN', 'your-token-here', 'User')
   ```

3. Restart Cursor IDE

4. Validate the setup:
   ```powershell
   .\scripts\setup-mcp.ps1
   ```

## Repository Configuration Format

The `repos.json` file uses the following format:

```json
{
	"repos": [
		{
			"name": "repository-name",
			"url": "https://github.com/username/repo.git",
			"path": "./repos/repository-name",
			"branch": "main"
		}
	]
}
```

**Fields:**
- `name`: Friendly name for the repository
- `url`: Git repository URL (supports HTTPS, SSH, etc.)
- `path`: Local path relative to the root directory
- `branch`: Branch to clone (default: `main`)

## Workspace Configuration

The workspace file (`MyHoppiesRootRepo.code-workspace`) can be customized to:

- Add additional folders (repositories)
- Configure workspace-specific settings
- Install recommended extensions

To add repositories to the workspace, edit the `folders` array in the workspace file, or let the scripts manage it automatically.

## Requirements

- **PowerShell**: Windows PowerShell 5.1+ or PowerShell Core 7+
- **Git**: Git must be installed and available in PATH
- **Node.js** (for MCP servers): Required if using MCP servers that use `npx`
- **Cursor IDE**: For the workspace configuration

## Troubleshooting

### Scripts fail with "git not found"

Ensure Git is installed and available in your PATH:
```powershell
git --version
```

### MCP servers not working

1. Ensure Node.js is installed:
   ```powershell
   node --version
   npx --version
   ```

2. Run the MCP setup script:
   ```powershell
   .\scripts\setup-mcp.ps1
   ```

3. Restart Cursor IDE after configuration changes

### Repository clone fails

- Check that the repository URL is correct and accessible
- Verify you have the necessary permissions
- Ensure the target directory doesn't exist (or use `-Force` flag)

### Execution Policy Errors

If you encounter PowerShell execution policy errors:

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

## License

This repository is provided as-is for managing your multi-repo workspace.
