# Scheduled Cursor Automations (Daily Work Loop)

Run **morning brief**, **EOD wrap**, and **weekly status** on a schedule using [Cursor Automations](https://cursor.com/docs/cloud-agent/automations) with **My Machines** so the **daily-work-loop-copilot** stdio MCP and local git work on your Mac.

## Prerequisites

1. **Cursor CLI** installed and signed in: `agent login`
2. **Plugins** (Customize):
   - **daily-work-loop-copilot** (local or marketplace)
   - **GitHub** (OAuth connected)
3. **Plugin Configure** (`INTEGRATION_STACK=github`, `GITHUB_OWNER`, `GITHUB_REPO` for primary app repo — e.g. `mohamedhamed2024` / `MyHoppies`)
4. **Node.js 18+** on the worker machine (for `daily-loop-tools` MCP)
5. **Dashboard** (if automations hide self-hosted runtime): enable **Allow Self-Hosted Machines** under Cloud Agents

## Keep a worker running

Automations that use stdio MCP must hit a machine where the plugin is installed:

```bash
./scripts/start-daily-loop-worker.sh
```

Default worker name: **`my-daily-loop`**. Override with `DAILY_LOOP_WORKER_NAME=other-name`.

The script registers the workspace root and `./repos/MyHoppies` (when present) as worker directories.

Verify: `agent worker debug`, then [cursor.com/agents](https://cursor.com/agents) → runtime → **my-daily-loop**.

## Create the three automations

Prefill JSON lives in [`prefill/`](./prefill/). Each file is meant for the Automations editor (Agents Window `/automate` flow or manual create).

### Option A — Agents Window (recommended)

1. Open **Agents Window** in Cursor.
2. Ask: *“Create a scheduled automation from `docs/automations/prefill/morning-start-day.json`”* (use `/automate` if available).
3. Approve the draft table, then open the Automations editor.
4. Repeat for `eod-wrap.json` and `weekly-status-report.json`.

### Option B — Automations UI

1. [cursor.com/automations](https://cursor.com/automations) → **New automation**
2. Match **name**, **cron**, **repository**, **MCP tools**, and **instructions** from the prefill file and the table below.
3. Set **Runtime** → **My Machines** → **my-daily-loop** (same name as your worker).

### What to set in the editor (all three)

| Setting | Value |
|--------|--------|
| Repository | `mohamedhamed2024/MyHoppiesRootRepo` |
| Branch | `main` |
| Runtime | **My Machines** → `my-daily-loop` |
| MCP tools | **daily-loop-tools**, **github** |
| Schedule | **You chose custom times** — set cron in the UI (examples below) |

**Cron examples** (adjust to your timezone; Automations uses a single cron expression):

| Automation | Suggested cron | Meaning |
|------------|----------------|---------|
| Morning brief | `0 9 * * 1-5` | Weekdays 09:00 |
| EOD wrap | `30 17 * * 1-5` | Weekdays 17:30 |
| Weekly status | `0 9 * * 5` | Fridays 09:00 |

### Safety (matches plugin policy)

- **EOD** prefills use **`--update-tickets draft` only** — no Jira/GitHub posts from the scheduler.
- Do **not** add write approval files for unattended runs unless you explicitly want automated posts.
- No auto-merge / auto-close.

## Prefill files

| File | Purpose |
|------|---------|
| [`prefill/morning-start-day.json`](./prefill/morning-start-day.json) | `/start-day` — blockers, top 3, first action |
| [`prefill/eod-wrap.json`](./prefill/eod-wrap.json) | `/eod-wrap` — shipped / in progress / drafts only |
| [`prefill/weekly-status-report.json`](./prefill/weekly-status-report.json) | `/daily-status-report` — 7-day team report; renders `docs/index.html`, commit + push `main` for GitHub Pages |

## Troubleshooting

| Symptom | Fix |
|---------|-----|
| MCP “Set up” in automation | Use dashboard plugin MCP names **`daily-loop-tools`** and **`github`**, not project `.cursor/mcp.json` only |
| Run uses cloud VM, git empty | Select **My Machines** runtime; keep `agent worker start` running |
| Trigger never fires | Worker offline; cron timezone; automation paused |
| GitHub data empty | Re-auth GitHub plugin; check `GITHUB_OWNER` / `GITHUB_REPO` in plugin Configure |

## Related

- Plugin overview: `~/.cursor/plugins/local/daily-work-loop-copilot/plugin/how-it-works.md`
- Write gate: `.cursor/daily-loop-write-approved` (manual approval only)
- Status HTML history: `docs/daily-report/index.html`, `.cursor/daily-report.json`
