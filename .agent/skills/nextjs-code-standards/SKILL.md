---
name: nextjs-code-standards
description: Next.js and React code standards for the ChartSwap new portal (Ontellus ChartSwap). Use when writing or reviewing the new portal frontend (ontellus.chartswap), adding components, implementing state (Zustand), calling Salesforce or .NET APIs, adding a new API integration, writing unit tests, or applying project code style and naming conventions.
---

# Next.js Code Standards (ChartSwap New Portal)

This skill defines **project standards for the ChartSwap new portal** — the Ontellus ChartSwap Next.js frontend (in `ontellus.chartswap/`). It covers architecture, code style, naming, components, state (Zustand), TypeScript, backend/Salesforce integration, and errors. Apply when implementing or reviewing features, components, or store logic in the new portal.

**Scope:** ChartSwap new portal only (Next.js app in `ontellus.chartswap/`). Do not apply these standards to other ChartSwap repos (e.g. .NET services, Salesforce).

## Architecture and design

- Clean, maintainable, scalable code; SOLID principles
- Prefer functional and declarative over imperative
- Type safety and static analysis; component-driven development
- Avoid over-engineering; start simple, add complexity only when needed

## Planning before implementation

- Step-by-step planning; detailed pseudocode before coding
- Document component architecture and data flow
- Consider edge cases and error scenarios

## Code style (summary)

- Tabs for indentation; single quotes for strings (except to avoid escaping)
- Omit semicolons unless required for disambiguation
- No unused variables; space after keywords and before function parentheses
- Strict equality (`===`) only; space around infix operators and after commas
- Else on same line as closing brace; curly braces for multi-line conditionals
- Always handle error parameters in callbacks
- Line length ≤ 80 characters; trailing commas in multiline object/array literals

Full code-style list and naming table: [reference.md](reference.md).

## Naming conventions (quick reference)

| Kind | Convention | Examples |
|------|------------|----------|
| Components, types, interfaces | PascalCase | `UserProfile`, `AuthWizard` |
| Directories, file names | kebab-case | `auth-wizard`, `user-profile.tsx` |
| Variables, functions, hooks, props | camelCase | `handleClick`, `useAuth` |
| Env vars, constants | UPPERCASE | `API_URL`, `MAX_RETRIES` |
| Event handlers | handle + Verb | `handleClick`, `handleSubmit` |
| Booleans | is/has/can prefix | `isLoading`, `hasError`, `canSubmit` |
| Custom hooks | use + Noun | `useAuth`, `useForm` |

Short names allowed: err, req, res, props, ref. Prefer full words otherwise.

## Component and feature implementation

- **Components:** Functional components with TypeScript interfaces; use `function` keyword
- **Logic:** Extract reusable logic into custom hooks; use composition
- **Performance:** `React.memo()` where it helps; cleanup in `useEffect`; `useCallback` for callbacks; `useMemo` for expensive computations; stable keys in lists (avoid index); avoid inline functions in JSX; dynamic imports for code splitting
- **Next.js:** Metadata, caching, error boundaries as appropriate; built-in `Image`, `Link`, `Script`, `Head`; implement loading states

## TypeScript

- Strict mode; clear interfaces for props, state, and store shape
- Type guards for nullable values; generics where needed
- Prefer `interface` when extending; use `Partial`, `Pick`, `Omit`, mapped types as needed

## State management

**Local:** `useState` for component-level UI only; avoid lifting state unless shared; initialize explicitly.

**Global (Zustand):**
- One store per domain/feature; flat, minimal state
- Separate state, actions, selectors; prefer updater functions
- Use selectors to avoid unnecessary re-renders
- No derived data in store (compute in selectors); no non-serializable values unless required
- Reset store on logout or context change
- Store layout: dedicated `stores/` or feature-scoped dir; export store hook and typed selectors; hooks named `use<Feature>Store` (e.g. `useAuthStore`, `useOrderStore`)
- Performance: shallow comparison or selectors; avoid subscribing to whole store; keep actions synchronous; validate before persisting
- **Avoid:** single giant store; mixing UI and business state; mutating nested refs; storing raw API responses; using Zustand as server cache
- **API and server state:** Use Zustand for data from APIs (Salesforce, .NET). Do not add new shared/global state in React Context; prefer Zustand stores (e.g. `useXxxStore`). Existing Context may remain; new features and new API state must use Zustand.

Full Zustand and store structure: [reference.md](reference.md).

## Backend / Salesforce integration

The new portal (ontellus.chartswap) talks to **chartswap-Salesforce** and **.NET services** via REST/SOAP APIs. Backend logic and data live in those repos, not in the frontend.

**Repos:**
- **ontellus.chartswap** — `repos/Chartswap-Frontend/ontellus.chartswap/` (this app; UI and API client code)
- **chartswap-Salesforce** — `repos/chartswap-Salesforce/` (Salesforce backend; Apex, REST/SOAP endpoints)
- **.NET services** — same Chartswap-Frontend repo (microservices); frontend may call them as well

**API routes (Next.js BFF):**
- **Location:** `src/pages/api/` (Pages Router). One file per route; URL is `/api/` + path (e.g. `pages/api/requests/requests.ts` → `/api/requests/requests`).
- **Internal prefix (browser → Next.js):** `/api/`. Client uses `AxiosClientMiddleware` with `EndpointType.Internal` (baseUrl `/api/`).
- **External prefix (Next.js → Salesforce):** Base URL from `NEXT_PUBLIC_BASE_API_URL`; Salesforce paths use `apexrest/` (e.g. `apexrest/getrequestslist`). Full URL: `getEndpointUrl(EXTERNAL_ENDPOINTS.xxx)` in `@/utils/Helper`.

**Common pattern:**
- **Client (browser):** Use `AxiosClientMiddleware` with `EndpointType.Internal`; path from `ENDPOINTS` in `@/config/AppConfig`. CSRF and NextAuth are handled by the middleware.
- **API route handler (server):** Use `RouteHandler({ GET, POST, ... })` from `@/lib/server/services/RouteHandler/RouteHandler`; use `AxiosServerMiddleware` and `getEndpointUrl(EXTERNAL_ENDPOINTS.xxx)` to call Salesforce. Add new internal paths to `ENDPOINTS`, new Salesforce paths to `EXTERNAL_ENDPOINTS` in `src/config/AppConfig.ts`.
- **Env:** `NEXT_PUBLIC_BASE_API_URL` (Salesforce base); optionally `BASE_MOCK_API_URL` for mocks. Never commit secrets; use `.env.local` and `.env.example` in `ontellus.chartswap/`.
- **API contracts and endpoints:** Documented in repo `agents.md` (API Contracts, Common Patterns). When designing or changing contracts, use the **api-integration** skill.

**When adding a new API (workflow):**

1. **Contract:** Check `agents.md` (and any API docs) for existing endpoints. If you are **adding or changing** an endpoint/contract, use the **api-integration** skill to design it (REST, auth, request/response).
2. **Backend:** If the API lives in Salesforce, use **salesforce-development** for Apex/REST in chartswap-Salesforce. If it is a .NET endpoint, use **dotnet-backend**.
3. **Frontend (ontellus.chartswap):** Implement the call using the common pattern above: new route under `src/pages/api/` with `RouteHandler`; add entries to `ENDPOINTS` / `EXTERNAL_ENDPOINTS` in `AppConfig.ts`; client uses `AxiosClientMiddleware` (Internal) or server uses `AxiosServerMiddleware` + `getEndpointUrl(EXTERNAL_ENDPOINTS.xxx)`. **Store server/API state in Zustand**, not in React Context. Follow this skill for code style and naming.
4. **Standards:** Apply this skill (nextjs-code-standards) for all frontend code, including the integration layer and Zustand stores.

## UI and styling

- Shared UI library for consistent, accessible components; composition over custom one-offs
- Tailwind for utilities; contrast and spacing for accessibility; CSS variables for theme/spacing

## Security

- Sanitize input (e.g. DOMPurify for HTML); validate all user input; use proper auth

## Error handling and validation

- **Forms:** Zod for schemas; clear error messages; React Hook Form or equivalent
- **Errors:** Error boundaries; log to external service (e.g. Sentry); user-friendly fallback UI

## Unit testing

Test Next.js components, hooks, services, and API routes using Jest and React Testing Library. Tests co-locate with source files (e.g. `Button.tsx` → `Button.test.tsx`).

**Testing stack:** Jest 29.6.2, React Testing Library 14.0.0, TypeScript 5.1.6

**File structure:**
```
src/
  components/Button/
    Button.tsx
    Button.test.tsx
  hooks/
    useCart.tsx
    useCart.test.tsx
```

**Run tests:**
```bash
npm test              # Run all tests
npm run coverage      # Run with coverage
npm run watch         # Watch mode
```

**For implementation patterns:** Component/hook/context/service/API testing, query priority, mocking strategies, and best practices: [references/nextjs-testing.md](references/nextjs-testing.md)

**For code examples:** Render helpers, error states, form submission, toast notifications, test organization: [references/testing-examples.md](references/testing-examples.md)

## Reference

- Full code style rules, naming table, and Zustand details: [reference.md](reference.md)
- Unit testing patterns and mocking: [references/nextjs-testing.md](references/nextjs-testing.md)
- Testing code examples: [references/testing-examples.md](references/testing-examples.md)
