# PR Review Skill

## Overview

The **pr-review** skill is an agent skill for use with AI coding assistants (e.g. Cursor, VS Code with Copilot, or similar). It systematically reviews code and pull requests for correctness, code quality, security, performance, and adherence to Chartswap standards. It provides structured feedback with clear severity levels and actionable recommendations.

Works for:
- **Pull Request reviews** — Full PR analysis with context
- **Code reviews** — Individual file or snippet reviews
- **Implementation feedback** — Reviewing code before or after implementation

**IMPORTANT**: This is the primary skill for code and PR reviews. Use this skill for all review-related tasks.

---

## Key Benefits

| Benefit | Description |
|---------|-------------|
| **Structured Feedback** | Findings organized by severity (Critical / High / Medium / Low) |
| **Chartswap Standards** | Verifies adherence to project patterns and best practices |
| **Comprehensive Coverage** | Correctness, quality, security, performance, architecture, testing |
| **Actionable Suggestions** | Each finding includes recommendations and code examples when helpful |
| **Flexible Scope** | Full PR review, code snippet review, or focused areas (e.g. security only) |
| **Safe Operations** | Never modifies code, commits, or branches; read-only analysis |

---

## Prerequisites

### Required
- **An environment that supports agent skills** (e.g. Cursor, VS Code with GitHub Copilot, or similar)
- **Git** (for PR review: branch comparison, diff, commit history)

### Enabling agent skills
If your environment uses settings for agent skills, ensure they are enabled (e.g. in VS Code with Copilot: `chat.agent.enabled`, `chat.useAgentSkills`).

### For PR review (Azure DevOps)
- **Azure CLI** (`az`) if reviewing PRs by ID from Azure DevOps
- **Azure DevOps extension**: `az extension add --name azure-devops`

### For PR review (GitHub)
- **GitHub CLI** (`gh`) if reviewing PRs by number from GitHub

---

## Skill Location

```
chartswap.root.repo/
└── .agent/
    └── skills/
        └── pr-review/
            ├── SKILL.md
            └── README.md
```

---

## Workflow Steps

```
┌─────────────────────────────────────────────────────────────────────┐
│                        PR Review Flow                                │
└─────────────────────────────────────────────────────────────────────┘

┌──────────────┐    ┌──────────────┐    ┌──────────────┐
│   Step 0     │    │   Step 1     │    │   Step 2     │
│   Verify &   │───▶│   Analyze    │───▶│   Review     │
│   Gather     │    │   Changes    │    │   Checklist  │
└──────────────┘    └──────────────┘    └──────────────┘
                                               │
       ┌───────────────────────────────────────┘
       ▼
┌──────────────┐    ┌──────────────┐    ┌──────────────┐
│   Step 3     │    │   Step 4     │    │   Step 5     │
│   Categorize │───▶│   Generate   │───▶│   Report     │
│   Findings   │    │   Feedback   │    │   Results    │
└──────────────┘    └──────────────┘    └──────────────┘
```

### Step Details

| Step | Name | Description |
|------|------|-------------|
| 0 | Verify & Gather | Determine review type (PR vs snippet), base branch, fetch changes |
| 1 | Analyze Changes | List files changed, diff, commit context; understand scope |
| 2 | Review Checklist | Check correctness, quality, security, performance, Chartswap patterns |
| 3 | Categorize Findings | Assign severity, location, suggestion, and context per issue |
| 4 | Generate Feedback | Summary, detailed findings, positives, recommendations |
| 5 | Report Results | Verdict, counts, key concerns, highlights, metadata |

---

## Input Parameters

| Parameter | Description | Default | Example Phrases |
|-----------|-------------|---------|-----------------|
| **PR Number/URL** | Specific PR to review | Current branch vs base | `"review PR #123"`, `"review https://dev.azure.com/..."` |
| **Review scope** | Focus areas | All areas | `"review for security"`, `"check performance"` |
| **Target branch** | Base for comparison (PR review) | `develop` | Implicit from PR or branch |
| **File/Path filter** | Limit to certain paths | All changed files | `"review src/auth/"` |
| **Review depth** | Quick vs thorough | Thorough | `"quick review"`, `"surface review"`, `"deep review"` |
| **Output format** | How to present | Structured markdown | `"as comments"`, `"summary only"` |

---

## Example Prompts

```
# Full PR review (current branch vs develop)
review this PR
review my changes
review PR #123

# Code snippet or file
review this code
review this code for security issues
check my code

# Focused areas
review for security
review for performance and async patterns
check code quality

# Quick vs thorough
quick review of my changes
surface review
thorough review / deep review

# General
code review please
analyze this PR
feedback on my implementation
does this code look good?
```

---

## Safety Guardrails

The skill **WILL NOT**:

| Category | Protected Items |
|----------|-----------------|
| **Code** | Never modifies source code or files |
| **Git** | No destructive commands (reset --hard, clean -fd, branch -D, force push) |
| **Repositories** | Never pushes changes |
| **PRs** | Never auto-approves or auto-rejects PRs |
| **Review** | Never skips critical security or correctness checks; never gives vague feedback |

---

## Deliverables

Every review produces:

1. **Review Summary** — Verdict (Approve / Request Changes / Comment) and overall assessment
2. **Findings by Severity** — Counts and list of Critical / High / Medium / Low issues
3. **Detailed Feedback** — Per finding: severity, location, issue, suggestion, context
4. **Positive Feedback** — Recognition of well-implemented patterns
5. **Recommendations** — Actionable next steps
6. **Review Metadata** — Files reviewed, scope, PR number (if applicable), date

---

## Review Output Example

```markdown
# Code Review Summary

## Verdict
Request Changes

## Overall Assessment
3 high-priority issues and several medium/low suggestions. Logic and security areas need attention before merge.

## Findings Summary
- **Critical**: 0 issues
- **High**: 3 issues
- **Medium**: 5 issues
- **Low**: 4 issues

## Key Concerns
1. SQL injection risk in UserService.cs:45 — use parameterized queries
2. Blocking async call in MessageHandler.cs — use await
3. Missing null check in arrayHelper.ts:23

## Positive Highlights
- Clear separation of concerns in API layer
- Good use of TypeScript types in new components

...
*Review completed on 2025-02-26 | Files reviewed: 12 | PR: 123*
```

---

## Troubleshooting

| Issue | Solution |
|-------|----------|
| Skill not triggering | Ensure agent skills are enabled in your environment (e.g. in VS Code: `chat.useAgentSkills`, `chat.agent.enabled`) |
| "PR not accessible" | For Azure DevOps: ensure `az` is installed and logged in; for GitHub: ensure `gh` is installed and authenticated |
| No changes to review | Confirm you have commits on your branch that aren’t on the base (e.g. develop); run `git fetch origin` |
| Want to review a specific PR | Use "review PR #&lt;id&gt;" or paste the PR URL |
| Too much output | Ask for "quick review" or "surface review" to limit to Critical/High findings |

---

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2025-02 | Initial README for pr-review skill |
