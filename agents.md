# AGENTS

Instructions for AI agents working in **MyHoppiesRootRepo** — a **multi-repo workspace shell**, not a single application repository.

## Workspace model

| Layer | Role |
|-------|------|
| **Root** (`MyHoppiesRootRepo`) | Registry (`repos.json`), clone/sync scripts (`scripts/`), Cursor workspace (`.cursor/`, `*.code-workspace`), MCP config, workspace agent skills (`.agent/`), this file |
| **Child repos** (`repos/<name>/`) | Product code, app tests, app docs, and **per-repo** agent instructions when present |

Canonical child list: **`repos.json`**. If the user names a product without a path, resolve it from that file (default local path `./repos/<name>`).

**Bootstrap:** clone or update children before product work:

```bash
./scripts/clone-repos.sh    # first time
./scripts/sync-repos.sh     # pull latest
./scripts/repo-status.sh    # health check
```

Add a new remote: `./scripts/add-repo.sh` (or `add-repo.ps1` on Windows), then clone.

## Where to edit (agent routing)

Before changing files, classify the task:

| Kind of work | Location | Git target |
|--------------|----------|------------|
| Features, fixes, refactors, app config, product tests | `repos/<repo-name>/...` only | **Child repo** remote (not root) |
| Skills, Cursor rules, MCP, workspace scripts, `repos.json` | Root: `.agent/`, `agents.md`, `.cursor/`, `scripts/`, `mcp-config.json` | **Root** repo |
| Workspace docs / automations (when asked) | Root: `docs/`, `reports/` | **Root** repo |

**Do not** create `src/`, `app/`, `package.json`, or similar product layouts at the workspace root.

Enforced in Cursor: `.cursor/rules/work-under-repos.mdc`.

### Child repo context

When doing product work:

1. Treat **`repos/<name>/`** as the project root (paths, imports, tests, PRs).
2. If the child has **`AGENTS.md`** or **`agents.md`**, follow it for repo-specific conventions; it overrides generic root guidance for that repo.
3. Prefer skills under the child (e.g. `.cursor/skills/`) when they exist; otherwise use workspace skills under **`.agent/skills/`**.

### Registered repositories (current)

| Name | Path | Notes |
|------|------|--------|
| MyHoppies | `./repos/MyHoppies` | Primary product repo for this workspace |

Update this table when `repos.json` changes, or derive the list from `repos.json` at runtime.

---

<skills_system priority="1">

## Available Skills

Workspace skills live under **`.agent/skills/<skill-name>/`**. Load with OpenSkills (see below).

**Scope:**

- **Workspace-general** — use for any repo under `repos/` when relevant.
- **ChartSwap** — use only when working in ChartSwap-related code **cloned under `repos/`** (e.g. `repos/Chartswap-Frontend/...`). Not for MyHoppies unless that code is present.

<!-- SKILLS_TABLE_START -->
<usage>
When users ask you to perform tasks, check if any of the available skills below can help complete the task more effectively. Skills provide specialized capabilities and domain knowledge.

How to use skills:
- Invoke: `npx openskills read <skill-name>` (run in your shell)
  - For multiple: `npx openskills read skill-one,skill-two`
- The skill content will load with detailed instructions on how to complete the task
- Base directory provided in output for resolving bundled resources (references/, scripts/, assets/)

Usage notes:
- Only use skills listed in <available_skills> below
- Do not invoke a skill that is already loaded in your context
- Each skill invocation is stateless
- Run openskills from the workspace root so `.agent/skills/` resolves correctly
</usage>

<available_skills>

<skill>
<name>frontend-design</name>
<description>Create distinctive, production-grade frontend interfaces with high design quality. Use when the user asks to build web components, pages, artifacts, posters, or applications (websites, landing pages, dashboards, React components, HTML/CSS layouts, or styling/beautifying any web UI). Workspace-general; implement UI under the appropriate child repo in repos/.</description>
<location>workspace</location>
</skill>

<skill>
<name>ui-styling</name>
<description>UI and styling conventions for the Ontellus ChartSwap Next.js frontend. Use when creating or modifying UI in ChartSwap portal code under repos/ (Tailwind, global SCSS, design tokens, react-select, react-datepicker, rc-tooltip, react-toastify). ChartSwap scope only.</description>
<location>workspace</location>
</skill>

<skill>
<name>mcp-builder</name>
<description>Guide for creating high-quality MCP (Model Context Protocol) servers that enable LLMs to interact with external services through well-designed tools. Use when building MCP servers in Python (FastMCP) or Node/TypeScript (MCP SDK). Workspace-general; server code may live in a child repo if it ships as product.</description>
<location>workspace</location>
</skill>

<skill>
<name>nextjs-code-standards</name>
<description>Next.js and React code standards for the ChartSwap new portal. Use when writing or reviewing ChartSwap frontend code under repos/, Zustand state, Salesforce or .NET API clients, integrations, and unit tests. ChartSwap scope only.</description>
<location>workspace</location>
</skill>

<skill>
<name>skill-creator</name>
<description>Guide for creating effective skills. Use when users want to create or update a skill. New workspace skills go under .agent/skills/; product-specific skills may go in a child repo .cursor/skills/ when they ship with that product.</description>
<location>workspace</location>
</skill>

<skill>
<name>product-owner</name>
<description>Act as Product Owner: backlog refinement, user stories, acceptance criteria, prioritization (MoSCoW/RICE), scope and stakeholders. Workspace-general.</description>
<location>workspace</location>
</skill>

<skill>
<name>scrum-master</name>
<description>Act as Scrum Master: ceremonies, sprint planning, impediments, process improvement. Workspace-general.</description>
<location>workspace</location>
</skill>

<skill>
<name>tester</name>
<description>QA test planning (strategy, scenarios, test cases, regression) and Playwright Test automation in JS/TS. Use for what to test and/or Playwright specs against a running app. Run tests from the relevant child repo under repos/. For Jest/RTL in ChartSwap, see nextjs-code-standards.</description>
<location>workspace</location>
</skill>

<skill>
<name>pr-review</name>
<description>Review code and pull requests for correctness, quality, security, performance, and team standards. Use for PR review, file review, or implementation feedback. Open the PR in the child repo; apply ChartSwap-specific checks only when the change is under ChartSwap paths in repos/.</description>
<location>workspace</location>
</skill>

</available_skills>
<!-- SKILLS_TABLE_END -->

</skills_system>
