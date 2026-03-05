---
name: tester
description: Combine QA test planning (strategy, scenarios, test cases, regression/edge coverage, requirements testability review) with browser-style automation using Playwright Test in JavaScript/TypeScript (Next.js-friendly). Use when you need to decide what to test, produce a QA checklist/test cases, and/or create Playwright specs to verify real user flows in a running web app (selectors, screenshots, traces, console logs). For Jest/React Testing Library implementation patterns, refer to nextjs-code-standards.
---

# Tester (QA Planning + Browser Automation)

This skill merges two layers of testing:

- **Test design**: turn requirements into clear, executable test coverage.
- **Browser automation**: validate critical flows in a running app using **Playwright Test (JS/TS)**.

## Decision guide

- If you need **what to test** → write a **test strategy + test cases** first (below).
- If you need **proof it works in the UI** → write **Playwright specs** (below).
- If you need **fast feedback on isolated logic/components** → use **Jest/RTL** patterns (see `nextjs-code-standards`).

## Browser test decision tree

```
User task → Is it static HTML?
    ├─ Yes → Identify selectors directly from HTML
    │         ├─ Success → Write Playwright Test spec using selectors
    │         └─ Fails/Incomplete → Treat as dynamic (below)
    │
    └─ No (dynamic webapp) → How will the server run?
        ├─ Use Playwright `webServer` (recommended for Next.js) → Write Playwright Test spec
        └─ Start the server manually (already running) → Use `baseURL` and write Playwright Test spec
```

**Note:** prefer Playwright Test’s `webServer` for most cases; it makes tests more reproducible and CI-friendly.

## Test Case Format

| ID | Description | Preconditions | Steps | Expected Result | Type |
|----|--------------|----------------|-------|-----------------|------|
| TC-001 | [Short desc] | [Setup] | 1. Step 1<br>2. Step 2 | [Outcome] | Functional |

**Types**:
- **Functional**: expected behavior works
- **Edge**: boundaries, invalid input, empty states, max length
- **Regression**: existing behavior unchanged
- **Integration**: cross-component/system flow

## Test strategy (what to include)

Keep it short and concrete:
- **Scope**: in / out
- **Environments**: local / QA / prod-like
- **Data**: required records, seeded users, roles, feature flags
- **Risks**: fragile areas, dependencies, high-impact failures
- **Coverage goals**: critical paths + top regressions + known edge cases

## Requirements review (testability checklist)

Flag issues before testing starts:
- Acceptance criteria are **measurable** and **unambiguous**
- Clear success/failure outcomes (no “works correctly”)
- Error/empty/loading states defined
- Permissions/roles and audit requirements specified
- Non-functional constraints called out (performance, accessibility)

## Unit testing standards (what to cover)

Focus on **behavior coverage**, not line coverage:
- **Components**: render states, interactions, conditional UI, a11y
- **Hooks**: initial state, transitions, side effects, cleanup, edge cases
- **Utilities/services**: transformations, validation, error handling
- **API routes**: validation, status codes, auth, error scenarios

For Jest + React Testing Library setup, patterns, and examples, see `nextjs-code-standards`.

For Jest/RTL code examples, see nextjs-code-standards/references/testing-examples.md.”

---

# Playwright Test (JS/TS) for browser-style testing

Use Playwright when you need confidence in **real user flows** across routing, hydration, and client/server boundaries.

## Recommended setup: `webServer` (Next.js-friendly)

Minimal `playwright.config.ts` idea:

```ts
import { defineConfig } from '@playwright/test';

export default defineConfig({
  use: {
    baseURL: 'http://localhost:3000',
    trace: 'on-first-retry',
  },
  webServer: {
    command: 'npm run dev',
    port: 3000,
    reuseExistingServer: !process.env.CI,
    timeout: 120_000,
  },
});
```

## Example spec (`*.spec.ts`)

```ts
import { test, expect } from '@playwright/test';

test('home page loads', async ({ page }) => {
  await page.goto('/');
  await page.waitForLoadState('networkidle');
  await expect(page).toHaveTitle(/ChartSwap/i);
});
```

## Selector guidance (stability first)

Prefer these, in order:
- `page.getByRole(...)` (best)
- `getByLabel`, `getByPlaceholder`, `getByText` (good)
- `data-testid` + `page.getByTestId(...)` (great when UI text is volatile)
- CSS selectors (last resort)

## Reconnaissance-then-action (debug pattern)

```ts
await page.goto('/');
await page.waitForLoadState('networkidle');
await page.screenshot({ path: 'inspect.png', fullPage: true });
await page.pause(); // inspect selectors in Playwright Inspector
```

## Capture browser console logs (high-signal failures)

```ts
page.on('console', (msg) => {
  // Consider filtering to warn/error in real usage
  console.log(`[browser:${msg.type()}] ${msg.text()}`);
});
```

## Common pitfall

❌ Don’t inspect/act on a dynamic page before it’s ready  
✅ Do `await page.waitForLoadState('networkidle')` and/or assert key UI is visible with `expect(locator).toBeVisible()`

